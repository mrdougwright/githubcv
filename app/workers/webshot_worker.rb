class WebshotWorker
  include Sidekiq::Worker

  def perform(repo_id)
    repo_obj = RepoImage.find(repo_id)
    filename = "#{repo_obj.repo_name.gsub('/','-')}.png"
    begin
      ws = Webshot::Screenshot.instance # tried to add sidekiq to this
      file = ws.capture(repo_obj.url, filename, timeout: 3, width: 600, height: 450, quality: 100)
      obj = S3_BUCKET.object(filename)
      if obj.upload_file(file.path)
        repo_obj.update_attribute(:image_url, obj.public_url)
      end
      # Aws.config.http_handler.pool.empty! # clear bad memory in aws gem
    rescue Exception => e
      puts "Error in create_webshot: #{e}"
    end
  end
end
