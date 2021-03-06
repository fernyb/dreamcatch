#
# This class should replace fernyb_davclient which is a total mess
#
module Dreamcatch
  class DAV
    attr_accessor :notifier
    
    def exists?(remote_file_name)
      resp = run("#{remote_file_name}")
      puts "* Exists : #{resp.status_code} #{resp.status}\n" if $DEBUG
      if resp.status_code == 404
        false
      elsif resp.status_code == 200
        true
      else
        nil
      end
    end
  
    def delete(remote_file)
      command = []
      command << "--request DELETE"
      command << %Q{--header 'Content-Type: text/xml; charset="utf-8"'}
      command << remote_file
      curl_command = command.join(" ")
      resp = run(curl_command)
    
      puts "* DELETE: #{resp.status_code} #{resp.status}" if $DEBUG
      
      if resp.status_code == 401
        @notifier.add_error Dreamcatch::Error.new("#{resp.status_code} #{resp.status}")
        false
      elsif resp.status_code == 204
        resp
      else
        @notifier.add_error Dreamcatch::Error.new("#{resp.status_code} #{resp.status}")
        false
      end
    end
  
    def rename(current_name, new_name)
      command = []
      command << "--request MOVE"
      command << %Q{--header 'Content-Type: text/xml; charset="utf-8"'}
      command << %Q{--header 'Destination: #{new_name}'}
      curl_command = command.join(" ") + " " + current_name
      resp = run(curl_command)
      puts "* MOVE: #{resp.status_code} #{resp.status}" if $DEBUG
      
      if resp.status_code == 201
        resp
      else
        @notifier.add_error Dreamcatch::Error.new("#{resp.status_code} #{resp.status}")
        false
      end  
    end
  
    def put(remote_file_name, local_file_name)
      command = []
      command << "--upload-file #{local_file_name} #{remote_file_name}"
      curl_command = command.join(" ")
      resp = run(curl_command)
      puts "* PUT: #{resp.status_code} #{resp.status}" if $DEBUG  
      if resp.status_code == 201
        resp
      else
        @notifier.add_error Dreamcatch::Error.new("#{resp.status_code} #{resp.status}")
        false
      end
    end
    
    def mkcol(remote_url)
      curl_command = []
      curl_command << "--request MKCOL"
      curl_command << %Q{--header 'Content-Type: text/xml; charset="utf-8"'}
      curl_command = curl_command.join(" ") + " " + remote_url
      resp = run(curl_command)
      puts "* MKCOL #{resp.status_code} #{resp.status}" if $DEBUG
      if resp.status_code == 201
        resp
      else
        @notifier.add_error Dreamcatch::Error.new("#{resp.status_code} #{resp.status}")
        false
      end
    end
    
    def run(command)
      options = []
      options << "--include"
      options << "--location"
      options << %Q{--header 'Authorization: Basic #{Dreamcatch::Config.credentials}'}
      options = options.join(" ")
      response = nil
      
      curl_command = "curl #{options} #{command}"
      puts "\n*** #{curl_command}\n" if $DEBUG
      
      stdin, stdout, stderr = Open3.popen3(curl_command)
      response = stdout.readlines.join("")
      
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
      if body.last.to_s.match(/^HTTP\/(\d+).(\d+)/)
        resp.head = body.last
        resp.body = nil
      else
        resp.head = body[(body.size - 2)]
        resp.body = body.last
      end
      resp
    end
  end
end