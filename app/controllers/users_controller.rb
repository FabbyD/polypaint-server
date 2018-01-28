class UsersController < ApplicationController

  def create
    if params[:user].blank?
      return render status: :bad_request,
        json: {:error => 'User param cannot be empty.'}.to_json
    end
    @user = User.new(user_params)
    if @user.save
			log_in @user
      head :ok
    else
      render status: :bad_request,
             json: {:error => @user.errors.full_messages}.to_json
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :password)
    end
end
