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
  end
  
  describe :credentials do
    it "returns credentials base64 encoded" do
      Dreamcatch::Config.username = "username"
      Dreamcatch::Config.password = "password"
      Dreamcatch::Config.credentials.should == "dXNlcm5hbWU6cGFzc3dvcmQ="
    end

    it "credentials should not be username:password" do
      Dreamcatch::Config.username = "john"
      Dreamcatch::Config.password = "doe"
      Dreamcatch::Config.credentials.should_not == "dXNlcm5hbWU6cGFzc3dvcmQ="
    end
    
    it "should base64 encode username and password" do
      Dreamcatch::Config.username = "username"
      Dreamcatch::Config.password = "password"
      
      Base64.should_receive(:encode64).with("username:password").and_return "username:password"
      Dreamcatch::Config.credentials
    end    
  end
end
