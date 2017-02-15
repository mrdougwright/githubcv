class RepoImage < ApplicationRecord

  def self.find_or_create(repo)
    #repo params: name, full_name, homepage, description
    if obj = self.find_by_repo_name(repo.full_name)
      WebshotWorker.perform_async(obj.id) if obj.image_url.nil?
    else
      obj = self.create(
        name: repo.name,
        url:  repo.homepage,
        desc: repo.description,
        repo_name: repo.full_name
      )
      WebshotWorker.perform_async(obj.id)
    end

    return obj
  end

end
