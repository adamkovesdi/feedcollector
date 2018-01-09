require 'yaml'

LASTDATEFILE = 'lastdate.txt'.freeze
OUTPUTFILE = 'output.txt'.freeze

class FC_Config
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
