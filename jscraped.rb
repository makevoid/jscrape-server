#if ENV["RACK_ENV"] == "production"
  require 'daemons'
  Daemons.run('jscrape.rb')
#end