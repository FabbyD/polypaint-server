class UsersController < ApplicationController
  def new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # success
      head :ok
    else
      head :bad_request
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :password)
    end
end
