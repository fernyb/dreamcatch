require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Dreamcatch::Config do
  describe :accessors do
    it "has username accessor" do
      Dreamcatch::Config.should respond_to(:username)
    end
  
    it "has password accessor" do
      Dreamcatch::Config.should respond_to(:password)  
    end
  
    it "has remote_url accessor" do
      Dreamcatch::Config.should respond_to(:remote_url)
    end
  end
  
  describe :remote_url do
    it "returns url with http prefix" do
      Dreamcatch::Config.username = nil
      Dreamcatch::Config.password = nil
      Dreamcatch::Config.remote_url = "repo.example.com/git"
      Dreamcatch::Config.remote_url.should == "http://repo.example.com/git"
    end
    
    it "returns url with username/password in url" do
      Dreamcatch::Config.username = "username"
      Dreamcatch::Config.password = "password"
      Dreamcatch::Config.remote_url = "repo.example.com/git"
      Dreamcatch::Config.remote_url.should == "http://username:password@repo.example.com/git"  
    end
  end
end
