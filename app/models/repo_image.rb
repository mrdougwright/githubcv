class RepoImage < ApplicationRecord
  after_commit :screengrab, on: [:create, :update]

  def self.update_or_create(repo)
    obj = self.find_by_repo_name(repo.full_name)
    obj ? self.update_obj(obj,repo) : self.create_webshot(repo)
  end

  def self.create_webshot(repo)
    self.create(url: repo.homepage, desc: repo.description, name: repo.name, repo_name: repo.full_name)
  end

  def self.update_obj(obj, repo)
    obj.update_attributes(url: repo.homepage, desc: repo.description, name: repo.name, repo_name: repo.full_name)
    obj
  end

  def screengrab
    WebshotWorker.perform_async(id)
  end
end
