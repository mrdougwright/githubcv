class Api::V1::ApiReposController < ApplicationController
  def index
    repos_hash = GithubAPI.new(params[:user_name]).repos_hash
    @repos = repos_hash.map do |repo|
      RepoImage.find_or_create(repo)
    end
    render json: @repos
  end

  def show
    repos_hash = GithubAPI.new(params[:user_name]).repos_hash
    repo = repos_hash.select{|r| r.name == params[:repo_name]}.first
    @repo = RepoImage.find_or_create_webshot(repo)
    render json: @repo
  end

  def update
    repos_hash = GithubAPI.new(params[:user_name]).repos_hash
    @repos = repos_hash.map do |repo|
      RepoImage.update_obj(repo)
    end
    render json: @repos
  end
end
