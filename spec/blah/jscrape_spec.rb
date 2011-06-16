path = File.expand_path "../../", __FILE__

require "#{path}/jscrape"


class FakeSocketClient < EventMachine::Connection

  attr_writer :onopen, :onclose, :onmessage
  attr_reader :data

  def initialize
    @state = :new
    @data = []
  end

  def receive_data(data)
    @data << data
    if @state == :new
      @onopen.call if @onopen
      @state = :open
    else
      @onmessage.call(data) if @onmessage
    end
  end

  def unbind
    @onclose.call if @onclose
  end
end


describe Jscrape do
  url = "http://localhost:3000/q/http%3A%2F%2Fwww.google.com"
  
  it "should make a request" do
    
    EM.run {
      server = Server.new(:host => '0.0.0.0', :port => 12345)
      server.start

      #// opens the socket client connection
      socket = EM.connect('0.0.0.0', 12345, FakeSocketClient)

      #// assigning the onopen client callback directly
      socket.onopen = lambda {
        server.players.size.should == 1
        socket.data.last.chomp.should == "READY"
        EM.stop
      }
    }
    
  end
end