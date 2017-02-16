class ReposController < ApplicationController

  def show
    repos_hash = GithubAPI.new(params[:user_name]).repos_hash
    @repos.each {|r| RepoImage.update_obj(r)} if params[:update] == true
    @repos = repos_hash.map do |repo|
      RepoImage.find_or_create(repo)
    end
  end
end
