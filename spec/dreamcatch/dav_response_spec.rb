require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Dreamcatch::DAVResponse do
  before :each do
    @response = Dreamcatch::DAVResponse.new
  end
      
  it "has status attribute" do
    @response.should respond_to(:status)
  end

  it "has status_code attribute" do
    @response.should respond_to(:status_code)
  end

  it "has head attribute" do
    @response.should respond_to(:head)
  end

  it "has body attribute" do
    @response.should respond_to(:body)
  end
end
