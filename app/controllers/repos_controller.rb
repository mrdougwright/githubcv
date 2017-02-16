class ReposController < ApplicationController

  def show
    repos_hash = GithubAPI.new(params[:user_name]).repos_hash
    @repos = repos_hash.map do |repo|
      RepoImage.update_or_create(repo)
    end
  end
end
