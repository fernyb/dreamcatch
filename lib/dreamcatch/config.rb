module Dreamcatch
  class Config
    class << self
      attr_accessor :remote_url
      attr_accessor :username
      attr_accessor :password
      
      def remote_url
        if !@username.nil? && !@password.nil?
          "http://#{@username}:#{@password}@#{@remote_url}"
        else
          "http://#{@remote_url}"
        end  
      end
      
      def credentials
        Base64.encode64("#{@username}:#{@password}").gsub(/\n+/, "")
      end
    end
  end
end