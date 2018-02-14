class LoginsController < ApplicationController
  # Controller used to authenticate a user login from the application
  # This does not handle login requests from website. See SessionsController for this.

  def create
    user = User.find_by(name: user_params[:name])
    puts "LoginsController.create - username: #{user_params[:name]}"

    if !user
      puts "LoginsController.create - could not find user"
      render status: :unauthorized,
        json: { errors: [ 'Could not authenticate username/password.' ] }.to_json
    elsif UserList.exists?(user.id)
      puts "LoginsController.create - user is already logged in"
      render status: :unauthorized,
        json: { errors: [ 'User is already logged in.' ] }.to_json
    elsif user.authenticate(user_params[:password])
      puts "LoginsController.create - success"
      render status: :ok,
        json: { user: { id: user.id } }.to_json
    else
      puts "LoginsController.create - wrong password"
      render status: :unauthorized,
        json: { errors: [ 'Could not authenticate username/password.' ] }.to_json
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :password)
    end
end
