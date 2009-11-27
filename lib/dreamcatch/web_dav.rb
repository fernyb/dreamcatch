module Dreamcatch
  class WebDav
    attr_reader :remote_url
    attr_accessor :notifier
    attr_accessor :webdav
    
    def initialize(url, notify=nil)
      @remote_url = url
      @webdav ||= Dreamcatch::DAV.new
      @webdav.notifier = notify
      @notifier = notify
    end
    
    def exists?(save_name)
      save_name << "/" if save_name.match(/\.git$/)
      webdav.exists?("#{remote_url}/#{save_name}")
    end
    
    def delete(repo_name)
      webdav.delete("#{remote_url}/#{repo_name}/")
    end
    
    def rename(name, new_name)
      unless webdav.exists?("#{remote_url}/#{new_name}")
        webdav.rename("#{remote_url}/#{name}", "#{remote_url}/#{new_name}")
      else
        @notifier.errors << Dreamcatch::Error.new(%Q{#{new_name} does not exists})
      end
    end
    
    def put(local_dir, save_name)
      if exists?("#{save_name}")
        @notifier.errors << Dreamcatch::Error.new(%Q{#{save_name} already exists})
        return nil
      elsif File.directory?("#{local_dir}/#{save_name}")
        recursive_put(local_dir, save_name)
      elsif !File.directory?("#{local_dir}/#{save_name}")
        webdav.put("#{remote_url}/#{save_name}", "#{local_dir}/#{save_name}")
      end
    end
    
    def recursive_put(local_dir, save_name)
      if webdav.mkcol("#{remote_url}/#{save_name}")
        results = Dir["#{local_dir}/#{save_name}/**/*"].collect do |local_file|
          base_file_name = local_file.split("#{local_dir}")
          if File.directory?(local_file)
            webdav.mkcol("#{remote_url}#{base_file_name}")
          else
            webdav.put("#{remote_url}#{base_file_name}", "#{local_dir}#{base_file_name}")
          end
        end.select {|status| status == false || status.nil? }
        results.include?(false) == false
      end
    end
    
  end
end