require 'rss'
require 'date'

# Feed object for feedcollector
class Feed
  attr_reader :name, :url

  def initialize(name, url, outputfile, lastupdatefile)
    @name = name
    @url = url
    @outputfile = outputfile
    @lastupdatefile = lastupdatefile
  end

  def updatelastdatefile(updatedate)
    # updates last update file with the given date/time
    f = File.open(@lastupdatefile, 'w')
    f.puts(updatedate)
    f.close
  end

  # Public method - call this
  def writenewentries(entries)
    lastupdate = getlastupdate
    f = File.open(@outputfile, 'a')
    count = writenewer(f, entries, lastupdate)
    f.close
    count
  end

  protected

  def writenewer(file, entries, lastupdate)
    count = 0
    entries.each do |e|
      if e['date'] > lastupdate
        file.puts(e.values[0..-1].join('|'))
        count += 1
      end
    end
    count
  end

  def getlastupdate
    # returns time object of last update
    lastupdate = Time.new(1979, 1, 1)
    if File.file?(@lastupdatefile)
      datestring = IO.read(File.join(File.dirname(__FILE__),
                                     @lastupdatefile)).chomp
      lastupdate = Time.rfc2822(datestring)
    end
    lastupdate
  end
end
