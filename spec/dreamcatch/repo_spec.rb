require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Dreamcatch::Repo" do
  before :all do
    @repo = Dreamcatch::Repo.new({
      :dir  => "/tmp",
      :name => "test.git"
    })
  end
  
  it "must provide name for repo name" do
    @repo.instance_variable_get(:@name).should == "test.git"
    @repo.instance_variable_get(:@dir).should == "/tmp"
  end
  
  it "throws exception when initialize without repo name" do
    lambda {
      Dreamcatch::Repo.new
    }.should raise_error Dreamcatch::Invalid
  end
  
  describe :local_repo do
    it "returns the path to local repo" do
      @repo.local_repo.should == "/tmp/test.git"
    end
  end
  
  describe :local_repo_exists? do
    it "returns true when local repo exists" do
      repo_name = "/tmp/test.git"
      
      `mkdir #{repo_name}`
      @repo.local_repo_exists?.should be_true
      `rm -rf #{repo_name}`
    end
  end
  
  describe :init_bare do
    it "creates a bare git repository" do
      Grit::Repo.should_receive(:init_bare).with("test.git").and_return true
      @repo.init_bare("test.git").should be_true
    end
  end
  
  describe :errors do
    it "should return an array" do
      @repo.errors.should be_kind_of(Array)
    end
    
    it "should have errors"
  end
  
  describe :upload_to_webdav do
    it "should execute put from webdav" do
      local_dir, repo_name = "/Users/fernyb", "file.txt"
      @repo.webdav.should_receive(:put).with(local_dir, repo_name)
      @repo.upload_to_webdav(local_dir, repo_name)
    end
  end
  
  describe :rename do
    it "should execute webdav.rename when exists" do
      @repo.webdav.should_receive(:exists?).with("test.git").and_return true
      @repo.webdav.should_receive(:rename).with("test.git", "new_name").and_return true
      @repo.rename("new_name").should be_true
    end

    it "should not execute webdav.rename when not exists" do
      @repo.webdav.should_receive(:exists?).with("test.git").and_return false
      @repo.webdav.should_not_receive(:rename).with("test.git", "new_name")
      @repo.rename("new_name").should be_nil
    end    
  end
  
  describe :save do
    before :each do
      @repo.stub!(:local_repo_exists?).and_return true
      @repo.stub!(:init_bare).and_return false
    end
    
    it "should upload_to_webdav when local repo exists" do
      @repo.should_receive(:upload_to_webdav).with(@repo.instance_variable_get(:@dir), @repo.instance_variable_get(:@name))
      @repo.save
    end
    
    it "should init bare local repo and upload to webdav" do
      @repo.stub!(:local_repo_exists?).and_return false
      @repo.should_receive(:init_bare).with(@repo.local_repo).and_return true
      @repo.should_receive(:upload_to_webdav).with(@repo.instance_variable_get(:@dir), @repo.instance_variable_get(:@name))
      @repo.save
    end
  end
  
  describe :delete do
    it "should delete when it does exists"
    it "should remove local repo when it does exists"
  end
end
