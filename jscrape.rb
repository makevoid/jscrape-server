require 'goliath'
require 'em-http'
require 'em-synchrony'
require 'em-synchrony/em-http'

path = File.expand_path "../", __FILE__
require "#{path}/lib/goliath-env"

require 'uri'


class Jscrape < Goliath::API
  # reload code on every request in dev environment
  use ::Rack::Reloader, 0 if Goliath.dev?

  def scrape(url)
    url = URI.unescape url
    resp = EM::HttpRequest.new(url).get :timeout => 4 
    
    if resp.response_header.status == 200
      resp.response
    else
      raise "scraping failed: #{url}"
    end
  end
  
  def response(env)
    headers = {}
    request = env.request
    #return raise "You can't use GET requests" if  env.get?
    if match = request.path.match(/^\/q\/(?<url>.*)/)
      body = scrape match[:url]
      headers["Access-Control-Allow-Origin"] = request.origin
    else  
      body = "Resource not found"
    end
    [200, headers, body]
  end    

end



# PROXY (also see em-proxy) 
#
# EventMachine.run {
#       http = EventMachine::HttpRequest.new('http://www.website.com/').get :proxy => {
#         :host => 'www.myproxy.com',
#         :port => 8080,
#         :authorization => ['username', 'password'] # authorization is optional
#     }
