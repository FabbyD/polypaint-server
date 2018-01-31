class SessionsController < ApplicationController
  def create
    user = User.find_by(name: params[:session][:name])
    if user && user.authenticate(params[:session][:password])
      log_in user
      render status: :ok,
        json: { user: { id: @user.id } }.to_json
    else
			head :unauthorized
    end
  end

  def destroy
    log_out
		head :ok
  end
end
