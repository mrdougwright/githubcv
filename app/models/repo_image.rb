class RepoImage < ApplicationRecord

  def self.find_or_create(repo)
    #repo params: name, full_name, homepage, description
    obj = self.find_by_repo_name(repo.full_name)
    return obj if obj && obj.image_url.present?
    obj ? self.create_webshot(obj) : self.create_obj(repo)
  end

  def self.create_obj(repo)
    obj = self.create(
      name: repo.name, url:  repo.homepage,
      desc: repo.description, repo_name: repo.full_name
    )
    self.create_webshot(obj)
    obj
  end

  def self.create_webshot(repo_img)
    filename = repo_img.repo_name.gsub("/","-") + ".png"
    ws = Webshot::Screenshot.instance
    file = ws.capture(repo_img.url, filename, timeout: 100, width: 1028, height: 700)

    s3_obj = S3_BUCKET.object(filename)
    if s3_obj.upload_file(file.path)
      repo_img.update_attribute(:image_url, s3_obj.public_url)
    end
    repo_img
  end

end
