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

  def sleepinterval
    @config['sleepinterval'].to_i
  end

  def outputdir
    @config['outputdir']
  end

  def url(name)
    @config['feeds'].select { |h| h['name'] == name }[0]['url']
  end

  def lastdatefile(feed)
    "#{outputdir}/#{feed}/#{LASTDATEFILE}"
  end

  def outputfile(feed)
    "#{outputdir}/#{feed}/#{OUTPUTFILE}"
  end

  def createdirs
    Dir.mkdir(outputdir) unless File.directory?(outputdir)
    feeds.each do |f|
      target = "#{outputdir}/#{f}"
      Dir.mkdir(target) unless File.directory?(target)
    end
  end
end
