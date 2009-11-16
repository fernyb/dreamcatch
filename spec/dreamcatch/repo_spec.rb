require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Dreamcatch::Repo" do
  it "must provide name for repo name" do
    repo = Dreamcatch::Repo.new("repo_name")
    repo.instance_variable_get(:@name).should == "repo_name"
  end
  
  it "throws exception when initialize without repo name" do
    lambda {
      Dreamcatch::Repo.new
    }.should raise_error Dreamcatch::Invalid
  end
end
