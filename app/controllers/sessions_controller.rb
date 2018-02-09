require 'set'

class SessionsController < ApplicationController
  @@user_list = Set.new

  def create
    user = User.find_by(name: params[:session][:name])
    if user && !@@user_list.include?(user.id) && user.authenticate(params[:session][:password])
      @@user_list.add?(user.id)
      puts "New user ! #{@@user_list.size()}"
      render status: :ok,
        json: { user: { id: user.id } }.to_json
    else
			head :unauthorized
    end
  end

  def destroy
    id = params[:user_id]
    puts "Size #{@@user_list.size()}"
    puts "Bye #{id}! #{@@user_list.size()}"
    @@user_list.delete?(id.to_i)
    puts "Deleted! #{@@user_list.size()}"
		head :ok
  end
end
