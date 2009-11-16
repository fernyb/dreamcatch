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
end
