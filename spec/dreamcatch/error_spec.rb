require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Dreamcatch::Error do
  it "should have a message" do
    msg = Dreamcatch::Error.new("Failure Message")
    msg.to_s.should == "Failure Message"
  end
  
  it "should respond to description" do
    msg = Dreamcatch::Error.new("Failure Message")
    msg.should respond_to(:description)
  end
end