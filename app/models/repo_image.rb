class RepoImage < ApplicationRecord

  def self.find_or_create(repo)
    obj = self.find_by_repo_name(repo.full_name)
    if obj
      return obj if obj.image_url.present?
      self.create_webshot(obj, repo)
    else
      self.create_obj(repo)
    end
  end

  def self.create_obj(repo)
    obj = self.create(url: repo.homepage, desc: repo.description, name: repo.name, repo_name: repo.full_name)
    self.create_webshot(obj, repo)
  end

  def self.update_obj(repo)
    obj = RepoImage.find_by_repo_name(repo.full_name)
    obj.update_attributes(url: repo.homepage, desc: repo.description, name: repo.name, repo_name: repo.full_name)
    self.create_webshot(obj, repo)
  end

  def self.create_webshot(repo_obj, repo)
    filename = "#{repo.full_name.gsub('/','-')}.png"
    begin
      ws = Webshot::Screenshot.instance # tried to add sidekiq to this
      file = ws.capture(repo.homepage, filename, timeout: 10, width: 600, height: 400)
      obj = S3_BUCKET.object(filename)
      if obj.upload_file(file.path)
        repo_obj.update_attribute(:image_url, obj.public_url)
      end
    rescue Exception => e
      puts "Error in create_webshot: #{e}"
    end
    repo_obj
  end
end
