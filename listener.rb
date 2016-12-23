require_relative 'redis-config'

begin
  system('clear')
  puts "You are listening to turingfm on #{$host}."
  puts "Press Ctrl-C at any time to exit.\n"
  $redis.subscribe(:turingfm) do |on|
    on.message do |channel, msg|
      data = JSON.parse(msg)
      puts "[#{data['user']}]: #{data['msg']}"

      msg = data['msg']
      voice = data['voice']

      # `say -v #{voice} #{msg}` <- scary
      system 'say', '-v', voice, msg # <- safe
      # more info :
      # http://stackoverflow.com/questions/4650636/forming-sanitary-shell-commands-or-system-calls-in-ruby
      # http://ruby-doc.org/core-2.3.3/Kernel.html#method-i-system
    end
  end
  
rescue Interrupt => e
  puts "\ngoodbye"
end
