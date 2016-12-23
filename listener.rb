require_relative 'redis-config'

begin
  system('clear')
  puts "You are listening to turingfm on #{$host}."
  puts "Press Ctrl-C at any time to exit.\n"
  $redis.subscribe(:turingfm) do |on|
    on.message do |channel, msg|
      data = JSON.parse(msg)
      user = data['user']
      msg = data['msg'].gsub(/[^0-9a-z ]/i, '')
      voice = data['voice'].gsub(/[^0-9a-z ]/i, '')

      puts "[#{user}]: #{msg}"

      # `say -v #{voice} #{msg}` <- vulnerable
      system 'say', '-v', voice, msg # <- safe
      # more info :
      # http://ruby-doc.org/core-2.3.3/Kernel.html#method-i-system
      # http://stackoverflow.com/questions/4650636/forming-sanitary-shell-commands-or-system-calls-in-ruby
      # http://www.hilman.io/blog/2016/01/stop-using-backtick-to-run-shell-command-in-ruby/
    end
  end

rescue Interrupt => e
  puts "\ngoodbye"
end
