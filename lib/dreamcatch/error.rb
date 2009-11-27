module Dreamcatch
  class Error
    attr_accessor :description
    
    def initialize(msg)
      @description = msg
    end
    
    def to_s
      @description
    end
  end
end