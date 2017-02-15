class WebshotWorker
  include Sidekiq::Worker

  def perform(repo_id)
    repo = RepoImage.find(repo_id)
    filename = repo.repo_name.gsub("/","-") + ".png"
    ws = Webshot::Screenshot.instance
    file = ws.capture(repo.url, filename, timeout: 100, width: 1028, height: 700)

    obj = S3_BUCKET.object(filename)
    if obj.upload_file(file.path)
      repo.update_attribute(:image_url, obj.public_url)
    end
  end
end
