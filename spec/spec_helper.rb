ENV["RACK_ENV"] = "test"
path = File.expand_path "../../", __FILE__



require 'goliath/test_helper'
require "#{path}/jscrape"

RSpec.configure do |c| 
  c.include Goliath::TestHelper, :example_group => {
    :file_path => /spec\/integration/
  }
end
