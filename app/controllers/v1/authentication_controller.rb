class V1::AuthenticationController < ApplicationController
    skip_before_action :authorize_request, only: :authenticate
    # return auth token once user is authenticated
    def authenticate
      if user.activated?
        auth_token =
          AuthenticateUser.new(auth_params[:email], auth_params[:password]).call
        json_response(auth_token: auth_token)
      else
        json_response(responese, :authenticate)
    end
  
    private
  
    def auth_params
      params.permit(:email, :password)
    end
  end