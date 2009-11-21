require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Dreamcatch::DAV do
  describe :headers_and_response_from_response do
    describe :put do
      it "should return Dreamcatch::Response" do
        resp = Dreamcatch::DAV.send(:headers_and_response_from_response, response_for("put"))
        resp.should be_kind_of(Dreamcatch::DAVResponse)
      end
    end
  end
end
