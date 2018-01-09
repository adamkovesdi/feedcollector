#!/usr/bin/env ruby
#
# Feed collector application by Adam Kovesdi (c) 2017
require 'logger'
require './feedparser'
require './fcconfig'
require './feed'

SLEEPTIME = 1800
CONFIGFILE = 'config.yml'.freeze
LOGDEVICE = STDOUT
# LOGDEVICE = 'feedcollector.log'
DAEMONOUT = '/tmp/feedcollectorout.txt'.freeze

# main class
class Feedcollector
  attr_reader :feeds

  def log(text)
    @outputlog.info(text)
  end

  def error(text)
    @outputlog.error(text)
  end

  def fatal(text)
    @outputlog.fatal(text)
  end

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
    log("Starting feed collection, sleep interval #{SLEEPTIME}")
    loop do
      doallfeeds
      sleep(SLEEPTIME)
    end
  end

  def interactive
    cyclic_feedparse
  rescue Interrupt
    fatal('Stopping on interrupt')
    exit(0)
  end

  def daemon
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

  def initialize
    @outputlog = Logger.new(LOGDEVICE)
    conf = FcConfig.new(CONFIGFILE)
    conf.createdirs
    @feeds = []
    conf.feeds.each do |f|
      newfeed = Feed.new(f, conf.url(f), conf.outputfile(f),
                         conf.lastdatefile(f))
      @feeds.push(newfeed)
    end
  end
end

fc = Feedcollector.new
fc.interactive
