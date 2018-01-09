#!/usr/bin/env ruby
#
# Feed collector application by Adam Kovesdi (c) 2017
require 'logger'
require 'optparse'
require './logfacility'
require './feedparser'
require './fcconfig'
require './feed'

CONFIGFILE = 'config.yml'.freeze
DAEMONOUT = '/tmp/feedcollectorout.txt'.freeze

# main class
class Feedcollector
  include Logfacility

  attr_reader :feeds
  attr_reader :sleepinterval

  def dofeed(feed)
    entries = Feedparser.parsefeed(feed.url)
    count = feed.writenewentries(entries)
    lastupdate = Feedparser.newestdate(entries)
    feed.updatelastdatefile(lastupdate)
    count
  end

  def doallfeeds
    out = 'Parsing'
    @feeds.each do |feed|
      out += " #{feed.name[0..1]} "
      count = dofeed(feed)
      out += count.to_s
    end
    log(out)
  end

  def cyclic_feedparse
    log("Starting feed collection, sleep interval #{sleepinterval}")
    loop do
      doallfeeds
      sleep(sleepinterval)
    end
  end

  def interactive
    cyclic_feedparse
  rescue Interrupt
    fatal('Stopping on interrupt')
    exit(0)
  end

  def daemon
    @logdevice = 'feedcollector.log'
    $stdin.reopen('/dev/null')
    $stdout.reopen(DAEMONOUT, 'a')
    $stderr.reopen(DAEMONOUT, 'a')
    begin
      cyclic_feedparse
    rescue SignalException
      fatal('Stopping on signal')
      exit(0)
    end
  end

  def daemonize
    pid = fork do
      daemon
    end
    puts "Feedcollector daemon pid is #{pid}"
    Process.detach pid
  end

  def initialize(config = CONFIGFILE)
    # $stdout.sync = true
    @conf = FcConfig.new(config)
    @conf.createdirs
    @sleepinterval = @conf.sleepinterval
    initfeeds
  end

  protected

  def initfeeds
    @feeds = []
    @conf.feeds.each do |f|
      newfeed = Feed.new(f, @conf.url(f), @conf.outputfile(f),
                         @conf.lastdatefile(f))
      @feeds.push(newfeed)
    end
  end
end

# Main program
# option parser
options = {}
OptionParser.new do |opts|
  opts.banner = 'Usage: feedcollector.rb [options]'
  opts.on('-fCONFIGFILE', '--configfile=CONFIGFILE',
          'YAML Configuration file') do |f|
    options[:configfile] = f
  end
  opts.on('-h', '--help', 'Prints this help') do
    puts opts
    exit
  end
end.parse!

options[:configfile] ||= CONFIGFILE
fc = Feedcollector.new(options[:configfile])
$stdout.sync = true
fc.interactive
