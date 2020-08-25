class ApplicationController < ActionController::API
    include Response
    include ExceptionHandler
  
    # called before every action on controllers
    before_action :authorize_request
    attr_reader :current_user

    def get_current
      json_response(user: @current_user)
    end
  
    #private
  
    # Check for valid request token and return user
    def authorize_request
      @current_user = AuthorizeApiRequest.new(request.headers).call[:user]
    end
  end