path = File.expand_path "../../", __FILE__

require 'spec_helper'


describe Jscrape do
  def scrape_something
    puts "AAAAAAAAA"
    EM.stop
  end
  def mock_mysql2
    puts "AAAAAAAAA2"
    EM.stop
  end

  it "my" do
    with_api(Jscrape) do |a|
      scrape_something
    end
  end
  
  it "my" do
    with_api(Jscrape) do |a|
      mock_mysql2
    end
  end
end