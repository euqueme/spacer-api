module V1
  class AuthenticationController < ApplicationController
    skip_before_action :authorize_request, only: :authenticate

    # return auth token once user is authenticated
    def authenticate
      user = User.find_by(email: params[:email])

      if user.activated?
        auth_token =
          AuthenticateUser.new(auth_params[:email], auth_params[:password]).call
        json_response(auth_token: auth_token)
      else
        json_response({ message: "Activate user first" }, :unprocessable_entity)
      end
    end

    private

    def auth_params
      params.permit(:email, :password)
    end
  end
end

