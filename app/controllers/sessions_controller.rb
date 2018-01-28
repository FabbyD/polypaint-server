class SessionsController < ApplicationController
  def create
    user = User.find_by(name: params[:session][:name])
    if user && user.authenticate(params[:session][:password])
      log_in user
			head :ok
    else
			head :unauthorized
    end
  end

  def destroy
    log_out
		head :ok
  end
end
