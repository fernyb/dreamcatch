module Dreamcatch
  class Invalid < StandardError; end
  
  class Repo
    attr_reader :webdav
    attr_reader :errors
    
    def initialize(opts={})
      @name = opts[:name]
      @dir  = opts[:dir]
      raise Dreamcatch::Invalid.new("Repo must have name") if @name.nil?
      raise Dreamcatch::Invalid.new("Repo must have dir") if @dir.nil?
      @webdav = Dreamcatch::WebDav.new(Dreamcatch::Config.remote_url)    
    end
    
    def delete
      status = []
      status << webdav.delete("#{@name}") if webdav.exists?("#{@name}")
      if local_repo_exists?
        status << true if FileUtils.remove_dir(local_repo)
      end
      
      if status.size == 2 
        status.select {|s| s == true }.to_a.size == 2
      else
        status.first
      end
    end
    
    def rename(new_name)
      if webdav.exists?("#{@name}")
        webdav.rename(@name, new_name)
      end
    end
    
    def save
      if local_repo_exists?
        upload_to_webdav(@dir, @name)
      elsif init_bare(local_repo)
        upload_to_webdav(@dir, @name)
      end
    end
    
    def local_repo
      "#{@dir}/#{@name}"
    end
    
    def local_repo_exists?
      File.exists? local_repo
    end
    
    def upload_to_webdav(local_dir, repo_name)
      webdav.put(local_dir, repo_name)
    end
    
    def init_bare(local_repo_path)
      Grit::Repo.init_bare(local_repo_path)
    end
    
    def errors
      []
    end
  end

end