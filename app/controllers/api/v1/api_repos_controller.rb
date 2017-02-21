class Api::V1::ApiReposController < ApplicationController
  def show
    repos_hash = GithubAPI.new(params[:user_name]).repos_hash
    # @repos.each {|r| RepoImage.update_obj(r)} if params[:update] == true
    @repos = repos_hash.map do |repo|
      RepoImage.find_or_create(repo)
    end
    render json: @repos
  end

  def repo_image
    repos_hash = GithubAPI.new(params[:user_name]).repos_hash
    repo = repos_hash.select{|r| r.name == params[:repo_name]}.first
    @repo = RepoImage.find_or_create_webshot(repo)
    render json: @repo
  end
end
