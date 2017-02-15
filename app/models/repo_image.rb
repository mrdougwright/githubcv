class RepoImage < ApplicationRecord

  def self.find_or_create(repo)
    img = self.find_by_name(repo.name)
    return img if img
    self.create_webshot(repo)
  end

  def self.create_webshot(repo)
    filename = "#{repo.name}.png"
    ws = Webshot::Screenshot.instance # need to add sidekiq to this
    file = ws.capture(repo.homepage, filename, timeout: 5, width: 500, height: 200)

    obj = S3_BUCKET.object(filename)
    if obj.upload_file(file.path)
      self.create(image_url: obj.public_url, url: repo.homepage, desc: repo.description, name: repo.name)
    end
  end
end
