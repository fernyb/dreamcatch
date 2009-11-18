module Dreamcatch
  class WebDav
    attr_reader :remote_url
    
    def initialize(url)
      @remote_url = url
    end
    
    def webdav
      Dreamcatch::DAV
    end
    
    def exists?(save_name)
      webdav.exists?("#{remote_url}/#{save_name}")
    end
    
    def delete(repo_name)
      webdav.delete("#{remote_url}/#{repo_name}/")
    end
    
    def rename(name, new_name)
      if !webdav.exists?("#{remote_url}/#{new_name}")
        webdav.rename("#{remote_url}/#{name}", "#{remote_url}/#{new_name}")
      end
    end
    
    def put(local_dir, save_name)
      if File.directory?("#{local_dir}/#{save_name}")
        recursive_put(local_dir, save_name)
      else
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
        end.select {|status| status == false }
        results.size > 0 ? results : true
      end
    end
    
  end
end