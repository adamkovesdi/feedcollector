
# Logging module for feedcollector (c)2018 adamkov
module Logfacility
  def log(text)
    writelog(text, 'I')
  end

  def error(text)
    writelog(text, 'E')
  end

  def fatal(text)
    writelog(text, 'F')
  end

  def debug(text)
    writelog(text, 'D')
  end

  def writelog(text, level)
    logstring = "#{Time.now} #{level} #{text}"
    if @logdevice.nil?
      puts logstring
    else
      File.open(@logdevice, 'a') do |f|
        f.puts(logstring)
      end
    end
  end
end
