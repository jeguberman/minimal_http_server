HISTORY=Hash.new { |h, k| h[k] = [] }
@i=0


def sputs(string, color: :white, important: false,) #puts string to sterr stream with color for aided visibility
  begin
    tid = threadID
    string = string.send(color)
    string = string.gsub(/[\r\n]/,"")

    hPush(string, tid)

    string = "#{tid}: " + string
    STDERR.puts(string)
    return true

  rescue Exception => e
    eString ="#{e.backtrace[0]}: #{e.message} (#{e.exception.class})\r\n".red

    (0... e.backtrace.length).each do |frame|
      eString.concat "#{9.chr}from #{e.backtrace[frame]}".red
    end

    hPush eString, tid
    STDERR.puts(eString)

    raise e

  end
end

def hPush(string, tid) #format string for history log and push to history log
  e = Time.now
  msStamp = "  #{e.strftime('%6L')}  ".magenta
  hString = "#{string}#{e}"#.strftime(" @ %I:%M:%S%p")}"
  # threadStamp = "#{tid.rjust(4,'0')}"
  threadStamp = "#{tid}"
  threadStamp = threadStamp.rjust(4,'0').cyan + "  "
  threadStamp = threadStamp.cyan
  HISTORY[tid].push (msStamp + hString)
  HISTORY[:all].push (msStamp + threadStamp + hString)
end


def dumpHistory #serializes history object and writes it log
  puts "\r\nClosing from interrupt, printing log history to ./log"
  log = File.open("log","a")
  log.puts "&!\r\n"
  log.puts Time.now
  HISTORY.default = nil
  l = Marshal.dump(HISTORY)
  log.puts l
  log.puts "&!\r\n"
  log.close
end

def readHistory #unused
  HISTORY.each do |k,v|
    next if k == :all
    log.puts "#{k}:\r\n"
    v.each_with_index do |message, ix|
      log.puts "    #{ix.to_s.rjust(4,'0')}:#{message}"
    end
  end
  log.puts "order"+"  milSec  ".magenta+"thrd".cyan+"  *************************************".blue
  HISTORY[:all].each_with_index do |entry, ix|
    log.puts "#{ix.to_s.rjust(4,'0')} #{entry}"
  end

end