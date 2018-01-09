require 'yaml'

LASTDATEFILE = 'lastdate.txt'.freeze
OUTPUTFILE = 'output.txt'.freeze

# Configuration for feedcollector
class FcConfig
  def initialize(file)
    @config = YAML.load_file(file)
  end

  def feeds
    @config['feeds'].map { |f| f['name'] }
  end

  def url(name)
    @config['feeds'].select { |h| h['name'] == name }[0]['url']
  end

  def outputdir
    @config['outputdir']
  end

  def lastdatefile(feed)
    outputdir + '/' + feed + "/#{LASTDATEFILE}"
  end

  def outputfile(feed)
    outputdir + '/' + feed + "/#{OUTPUTFILE}"
  end
end

conf = FC_Config.new('config.yml')
puts conf.feeds.inspect
puts conf.url('health')
puts conf.outputfile('health')
