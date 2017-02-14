class ReposController < EndUserController
  def show
    @pdf = RepoImage.find_or_create(params[:user_name],'https://robodex.herokuapp.com/').file
  end
end
