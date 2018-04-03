module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    def disconnect
      UserList.remove(current_user.id)
      Selection.new(current_user.id).clear
    end

    private

    def find_verified_user
      if current_user = User.find_by(id: request.parameters[:user_id])
        UserList.add(current_user.id)
        current_user
      else
        reject_unauthorized_connection
      end
    end
  end
end
