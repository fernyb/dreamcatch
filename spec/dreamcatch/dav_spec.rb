require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Dreamcatch::DAV do
  describe :headers_and_response_from_response do
    describe :put do
      before :each do
        @resp = Dreamcatch::DAV.send(:headers_and_response_from_response, response_for("put"))
        @resp_two = Dreamcatch::DAV.send(:headers_and_response_from_response, response_for("put_two"))
      end

      it "should return Dreamcatch::Response" do
        [@resp, @resp_two].each {|rp| rp.should be_kind_of(Dreamcatch::DAVResponse) }
      end
    
      it "should have status code 201 Created" do
        [@resp, @resp_two].each {|rp| rp.status_code.should == 201 }
      end
    
      it "should have status" do
        [@resp, @resp_two].each {|rp| rp.status.should == "Created" }
      end
    
      it "should have http headers" do
        [@resp, @resp_two].each do |rp| 
          rp.head.should == "HTTP/1.1 201 Created\r\nDate: Sat, 21 Nov 2009 15:21:40 GMT\r\nServer: Apache\r\nLocation: http://example.com/git/test.txt\r\nVary: Accept-Encoding\r\nMS-Author-Via: DAV\r\nContent-Length: 185\r\nContent-Type: text/html; charset=ISO-8859-1"
        end
      end
    
      it "should have body" do
        [@resp, @resp_two].each do |rp|
          rp.body.should == "<!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\r\n<html><head>\r\n<title>201 Created</title>\r\n</head><body>\r\n<h1>Created</h1>\r\n<p>Resource /git/test.txt has been created.</p>\r\n</body></html>\r\n"
        end
      end        
    end # => end put 
  end
  
  describe :mkcol do
    it "should execute correct command" do
      response = mock("Response", :status_code => 201)
      Dreamcatch::DAV.should_receive(:exec).with(%Q{--request MKCOL --header 'Content-Type: text/xml; charset="utf-8"' http://example.com/git/repo.git}).and_return(response)
      Dreamcatch::DAV.mkcol("http://example.com/git/repo.git")
    end

    it "should return response when status_code is 201" do
      response = mock("Response", :status_code => 201)
      Dreamcatch::DAV.stub!(:exec).and_return(response)
      Dreamcatch::DAV.mkcol("http://example.com/git/repo.git").should == response
    end

    it "should return false when status_code is not 201" do
      response = mock("Response", :status_code => 500)
      Dreamcatch::DAV.stub!(:exec).and_return(response)
      Dreamcatch::DAV.mkcol("http://example.com/git/repo.git").should be_false
    end        
  end
  
end
