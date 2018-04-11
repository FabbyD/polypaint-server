class UsersController < ApplicationController
  include RenderHelper

  def create
    if params[:user].blank?
      return render status: :bad_request,
        json: {:error => 'User param cannot be empty.'}.to_json
    end
    @user = User.new(user_params)
    if @user.save
			log_in @user
      render status: :ok,
        json: { user: { id: @user.id } }.to_json
    else
      render_bad_request(@user.errors.full_messages)
    end
  end

  def update
    if params[:user].blank?
      return render status: :bad_request,
        json: {:error => 'User param cannot be empty.'}.to_json
    end

    user = User.find(params[:id])
    if user
      if user.update(user_params)
        head :ok
      else
        render_bad_request(user.errors.full_messages)
      end
    else
      render status: :not_found
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :password)
    end
end
