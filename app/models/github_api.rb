class GithubAPI
  attr_reader :github, :user_name

  def initialize(user_name)
    @github = Github.new client_id: ENV['GITHUB_CLIENT_ID'], client_secret: ENV['GITHUB_CLIENT_SECRET']
    @user_name = user_name
  end

  def repos_hash
    list = github.repos.list user: user_name
    list.select{ |repo| !repo.homepage.blank? } # only repos with a url
  end
end
