$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'dreamcatch'
require 'spec'
require 'spec/autorun'


Spec::Runner.configure do |config|
  
end

def response_for(method)
  File.open(File.dirname(__FILE__) + "/fixtures/response/#{method}.txt") {|f| f.read }
end
