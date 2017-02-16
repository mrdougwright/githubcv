class RepoImage < ApplicationRecord

  def self.find_or_create(repo)
    obj = self.find_by_repo_name(repo.full_name)
    return obj if obj && !obj.image_url.nil?
    self.create_webshot(repo)
  end

  def self.create_webshot(repo)
    filename = "#{repo.full_name.gsub('/','-')}.png"
    repo_obj = self.create(url: repo.homepage, desc: repo.description, name: repo.name, repo_name: repo.full_name)

    begin
      ws = Webshot::Screenshot.instance # tried to add sidekiq to this
      file = ws.capture(repo.homepage, filename, timeout: 10, width: 600, height: 400)
      obj = S3_BUCKET.object(filename)
      if obj.upload_file(file.path)
        repo_obj.update_attribute(:image_url, obj.public_url)
      end
      AWS.config.http_handler.pool.empty! # clear bad memory in aws gem
    rescue Exception => e
      puts "Error in create_webshot: #{e}"
    end
    repo_obj
  end
end
