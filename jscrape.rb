require "rubygems"
require 'bundler/setup'

require 'goliath'
require 'em-http'
require 'em-synchrony'
require 'em-synchrony/em-http'

path = File.expand_path "../", __FILE__
require "#{path}/lib/goliath-env"

require 'uri'


Goliath.env = :test
class Jscrape < Goliath::API
  # reload code on every request in dev environment
  use ::Rack::Reloader, 0 if Goliath.dev?

  def get_url(url, requests=[])
    req = EM::HttpRequest.new(url).get :timeout => 4 
    
    status = req.response_header.status
    if status == 200 || status.to_s =~ /30[123]/
      responses << req.response
      raise req.response
      
      get_url(url, { responses: responses })
    else
      raise "scraping failed: #{url}"
    end
  end

  def scrape(url)
    url = URI.unescape url
    get_url url
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
