path = File.expand_path "../../", __FILE__

require 'goliath'
require "#{path}/lib/goliath-env"

describe Goliath::Env do
  
  before :each do    
    @env = Goliath::Env.new
  end
  
  context "should parse" do
    
    it "zero param" do
      @env["QUERY_STRING"] = ""
      @env.params.should == {}
    end
    
    it "a param" do
      @env["QUERY_STRING"] = "a=b"
      @env.params.should == { a: "b" }
    end
    
    it "two params" do
      @env["QUERY_STRING"] = "a=b&c=d"
      @env.params.should == { a: "b", c: "d" }
    end
    
  end
  
 end