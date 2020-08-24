 class V1::UsersController < ApplicationController
    skip_before_action :authorize_request, only: :create
    # POST /signup
    # return authenticated token upon signup
  
    def create
      user = User.create!(user_params)
      auth_token = AuthenticateUser.new(user.email, params[:password]).call
      response = { message: Message.account_created, auth_token: auth_token }
      json_response(response, :created)
    end
  
    private
  
    def user_params
      params.permit(
        :email,
        :password
      )
    end
  end