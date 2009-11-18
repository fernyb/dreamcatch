#
# This class should replace fernyb_davclient which is a total mess
#
module Dreamcatch
  class DAV
    class << self
      def exists?(repo)
        # TODO: implement
      end
    
      def delete(repo)
        # TODO: implement
      end
    
      def rename(current_name, new_name)
        # TODO: implement
      end
    
      def put(remote_file_name, local_file_name)
        curl_command = "--upload-file #{local_file_name} #{remote_file_name}"
        resp = exec(curl_command)
        puts "* PUT: #{resp.status_code} #{resp.status}" if $DEBUG
        if resp.status_code == 201
          resp
        else
          false
        end
      end
      
      def mkcol(remote_url, props)
        
      end
      
      private
      def exec(command, opts=[])
        options = []
        options << "--include"
        options << "--location"
        options  = opts | options
        options = options.join(" ")
        response = nil
        
        curl_command = "curl #{options} #{command}"
        puts "\n*** #{curl_command}\n" if $DEBUG
        Open3.popen3(curl_command) do |stdin, stdout, stderr|
          response = stdout.readlines.join("")
        end
        response = headers_and_response_from_response(response)
      end
      
      def headers_and_response_from_response(response)
        head = response.to_s.scan(/HTTP\/(\d+.\d+) (\d+) (.*)\r/)
        resp = Dreamcatch::DAVResponse.new
        if head.size == 1
         resp.status      = head.first[2]
         resp.status_code = head.first[1].to_i
        elsif head.size >= 2
         resp.status      = head.last[2]
         resp.status_code = head.last[1].to_i
        end
        
        body = response.to_s.split("\r\n\r\n")
        if body.last.match(/^HTTP\/(\d+).(\d+)/)
          resp.head = body.last
          resp.body = nil
        else
          resp.head = body[(body.size - 2)]
          resp.body = body.last
        end
        resp
      end
    end
  end # DAV
end