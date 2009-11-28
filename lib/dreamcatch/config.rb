module Dreamcatch
  class Config
    class << self
      attr_accessor :remote_url
      attr_accessor :username
      attr_accessor :password
      
      def remote_url
        "http://#{@remote_url}"  
      end
      
      def credentials
        Base64.encode64("#{@username}:#{@password}").gsub(/\n+/, "")
      end
    end
  end
end