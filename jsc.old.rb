require 'eventmachine'
require 'em-http'



EventMachine.run {
  http = EventMachine::HttpRequest.new('http://www.google.').get :timeout => 10

  http.callback {
    status = http.response_header.status
    if status == 200
      p http.response
    elsif status == 301 || status == 302
      puts "Wrong url, this is redirecting to: #{http.response_header.location}"
    else
      puts "Wrong http status: #{status}"
    end
 
  

    # EventMachine.stop
  }
}