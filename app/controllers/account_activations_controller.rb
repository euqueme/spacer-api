class AccountActivationsController < ApplicationController
  skip_before_action :authorize_request, only: :edit
    def edit
      user = User.find_by(email: params[:email])
      if user && !user.activated? && user.authenticated?(:activation, params[:id])
        user.activate
        #log_in user
        #render inline: "<p><%= Account Activated! %></p>"
        render plain: "Account Activated!"
      #  redirect_to user
      end
    end
end
