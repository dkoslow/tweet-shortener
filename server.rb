require 'socket'
require_relative('tweet_shortener')
require_relative('tree')

class Server
  EOF = "\n"

  def initialize(port = 3000)
    @control_socket = TCPServer.new(port)
    trap(:INT) { exit }
  end

  def gets
    @client.gets(EOF)
  end

  def respond(message)
    @client.write(message)
    @client.write(EOF)
  end

  def run
    @tree = Tree.create_tree

    loop do
      @client = @control_socket.accept

      pid = fork do
        respond "OHAI. This is the tweet shortener"

        loop do
          tweet = gets

          if tweet
            abbreviated_tweet = TweetShortener.abbreviate_tweet(tweet, @tree)
            respond(abbreviated_tweet)
          else
            @client.close
            break
          end
        end
      end

      Process.detach(pid)
    end
  end
end

server = Server.new(3000)
print "Server running on port 3000...\n"
server.run