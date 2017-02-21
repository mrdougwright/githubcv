class GithubAPI
  attr_reader :github, :user_name

  def initialize(user_name)
    @github = Github.new basic_auth: "#{ENV['GITHUB_LOGIN']}:#{ENV['GITHUB_PERSONAL_TOKEN']}"
    @user_name = user_name
  end

  def repos_hash
    list = github.repos.list user: user_name
    list.select{ |repo| !repo.homepage.blank? } # only repos with a url
  end
end
