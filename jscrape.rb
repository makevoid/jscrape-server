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
    head = { :"cookie" => "f2=40000000" }
    req = EM::HttpRequest.new(url).head(head).get :timeout => 4 
    

    
    status = req.response_header.status
    responses = [] unless responses
    if status.to_s =~ /20[0123456]/
      [req.response, responses]
    elsif status.to_s =~ /30[0123]/
      responses << [url, status]
      url = req.response_header.location      
      get_url(url, { responses: responses })
    else
      raise "scraping failed: #{url} - status: #{status}"
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
      body, responses = scrape match[:url]
      #host = "http://#{env["HTTP_HOST"]}"
      #raise host.inspect
      headers["Access-Control-Allow-Origin"] = "*" #host
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
