
# Feed object for feedcollector
class Feed
  def initialize(name, url, outputfile, lastupdatefile)
    @name = name
    @url = url
    @outputfile = outputfile
    @lastupdatefile = lastupdatefile
  end
end
