class UsersController < EndUserController
  def show
    @user = User.find(params[:id])
  end
end
