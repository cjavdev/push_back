class SessionsController < ApplicationController
  before_action :require_user, only: :destroy

  def create
    # this does a lot, including creating a user and authorization
    # if non had existed
    user = User.try_find_or_build_from_json!(params)
    if user
      login(user)
      render "users/show", locals: { user: user }
 #     render json: { token: user.session_token }
    else
      render json: { errors: ["Invalid credentials"] },
        status: :forbidden
    end
  end

  def destroy
    logout
    render json: { success: "Logged out" }
  end

  # def find_for_oauth_by_email(email, resource=nil)
  #   if user = User.find_by_email(email)
  #     user
  #   else
  #     user = User.new(:email => email, :password => Devise.friendly_token[0,20])
  #     user.save
  #   end
  #   return user
  # end

  # def find_for_oauth_by_name(name, resource=nil)
  #   if user = User.find_by_name(name)
  #     user
  #   else
  #     user = User.new(:name => name, :password => Devise.friendly_token[0,20], :email => "#{UUIDTools::UUID.random_create}@host")
  #     user.save :validate => false
  #   end
  #   return user
  # end
end
