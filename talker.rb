require_relative 'redis-config'

@voices = [
  'Alex',
  'Agnes',
  'Bruce',
  'Kathy',
  'Fred',
  'Princess',
  'Junior',
  'Vicki',
  'Ralph',
  'Victoria',
  'Albert',
  'Bad',
  'Bahh',
  'Bells',
  'Boing',
  'Bubbles',
  'Cellos',
  'Deranged',
  'Good',
  'Hysterical',
  'Pipe',
  'Trinoids',
  'Whisper',
  'Zarvox'
]

@user = ARGV[1] || ENV['USER']
@voice = @voices.sample
@voice_index = @voices.index(@voice)

system('clear')

loop do
  system('clear')
  puts "You are transmitting to slacker-say @ #{$host}.\nType q to stop it\n"
  puts "Your voice is: #{@voice}"
  puts "Type [ or ] to change your voice."
  print '> '
  msg = STDIN.gets

  break if ['q', 'exit', 'quit'].include? msg.chomp
  if msg.chomp == '['
    @voice_index = (@voice_index - 1) % @voices.count
    @voice = @voices[@voice_index]
  elsif msg.chomp == ']'
    @voice_index = (@voice_index + 1) % @voices.count
    @voice = @voices[@voice_index]
  else
    msg = msg.strip.gsub(/[^0-9a-z ]/i, '') # strip non-alphanumeric chars from message
    $redis.publish :slacker, {user: @user, voice: @voice, msg: msg}.to_json unless msg.empty?
  end
end
