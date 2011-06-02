require 'rubygems'
require 'stomp'


client = Stomp::Client.new("failover://(stomp://:@localhost:61613,stomp://:@remotehost:61613)?initialReconnectDelay=5000&randomize=false&useExponentialBackOff=false")
puts "Subscribing ronaldo"
client.subscribe("/queue/ronaldo", {:ack => "client", "activemq.prefetchSize" => 1, "activemq.exclusive" => true }) do |msg|
  File.open("file", "a") do |f|
    f.write(msg.body)
    f.write("\n----------------\n")
  end
  
  client.acknowledge(msg)
end

client.on_connect do
  puts "Yey! I'm connected"
end

client.on_connect_fail do
  puts "Oh lord"
end

loop do
  sleep(1)
  puts "."
end
