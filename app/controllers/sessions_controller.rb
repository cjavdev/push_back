class SessionsController < ApplicationController
  before_action :require_user, only: :destroy

  def create
    #{"session_key"=>"true", "accessToken"=>"CAATvnpmdi5cBAPoEpKbZAMifcwTEZCt6cZCAsi0jUhX4A4mZBmwO0dyJuZAium1SkbLQgJAJaq1FZAa6Qnfmob5XN5oqeVeMT1DuZB1MaMXoYm9C7yB8hXDyuWZCjZAgWqhZCFBg6iPPLZCodWVncUarlrqRevyRkbw0a6johGZBJRrMVnUVCFif6wZCz1JpOBDEh8JwJ61OFGMmQZB90pXzlX7dagDnqtgaA30ZBYZD", "expiresIn"=>"5043372", "sig"=>"...", "userID"=>"23803330", "secret"=>"...", "expirationTime"=>"1399787259449", "action"=>"create", "controller"=>"sessions", "format"=>"json"}
    user = User.find_by_credentials("stuff")
    if user
      login(user)
      render json: { token: user.session_token }
    else
      render json: { errors: ["Invalid credentials"] },
             status: :forbidden
    end
  end

  def destroy
    logout
    render json: { success: "Logged out" }
  end
end
