$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'dreamcatch'
require 'spec'
require 'spec/autorun'


Spec::Runner.configure do |config|
  
end

def response_for(name)
  File.open(File.dirname(__FILE__) + "/fixtures/response/#{name}.txt") {|f| f.read }
end


def response_for_into_array(name)
  f = File.new(File.dirname(__FILE__) + "/fixtures/response/#{name}.txt")
end