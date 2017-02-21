class RepoImage < ApplicationRecord

  def self.find_or_create(repo)
    self.find_by_repo_name(repo.full_name) || self.create(url: repo.homepage, desc: repo.description, name: repo.name, repo_name: repo.full_name)
  end

  def self.find_or_create_webshot(repo)
    obj = self.find_or_create(repo)
    return obj if obj && obj.image_url.present?
    self.create_webshot(obj, repo)
  end

  def self.update_obj(repo)
    old_obj = RepoImage.find_by_repo_name(repo.full_name)
    old_obj.update_attributes(url: repo.homepage, desc: repo.description, name: repo.name, repo_name: repo.full_name)
    self.create_webshot(old_obj, repo)
  end

  def self.create_webshot(repo_obj, repo)
    filename = "#{repo.full_name.gsub('/','-')}.png"
    begin
      ws = Webshot::Screenshot.instance # tried to add sidekiq to this
      file = ws.capture(repo.homepage, filename, timeout: 5, width: 500, height: 200)
      s3_obj = S3_BUCKET.object(filename)
      if s3_obj.upload_file(file.path)
        repo_obj.update_attribute(:image_url, s3_obj.public_url)
      end
    rescue Exception => e
      puts "Error in create_webshot: #{e}"
    end
    repo_obj
  end
end
