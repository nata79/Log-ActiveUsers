require 'set'

class ActiveUsers
  def initialize
    @ips     = Hash.new
    @mutex   = Mutex.new
    @running = true
  end

  def run
    @expire_thread = Thread.new { expire @ips, @mutex }

    while (log_line = gets) && @running
      ip = log_line.match(/(?:[0-9]{1,3}\.){3}[0-9]{1,3}/).tap do |result|
        result[0] if result
      end

      if ip
        @mutex.synchronize do
          @ips[ip] = Time.now
        end

        print "Active Users: " + @ips.size.to_s + "\r"
      end
    end
  end

  def stop
    @running = false
    @expire_thread.join
  end
private
  def expire ips, mutex
    while @running
      mutex.synchronize do
        ips.each do |ip, last_request|
          if last_request < Time.now - 60
            ips.delete ip
          end
        end
      end

      sleep 5
    end
  end
end

a = ActiveUsers.new

Signal.trap("INT") do
  a.stop
end

a.run
