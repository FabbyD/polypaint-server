class SessionsController < ApplicationController
  def create
    # TODO set session id ?
    user = User.find_by(name: params[:session][:name])
    if user && user.authenticate(params[:session][:password])
      render status: :ok,
        json: { user: { id: user.id } }.to_json
    else
			head :unauthorized
    end
  end

  def destroy
    # TODO destroy session id ?
		head :ok
  end
end
