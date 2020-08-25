class ApplicationController < ActionController::API
  include Response
  include ExceptionHandler

  before_action :set_format

  # called before every action on controllers
  before_action :authorize_request

  attr_reader :current_user

  # Check for valid request token and return user
  def authorize_request
    @current_user = AuthorizeApiRequest.new(request.headers).call[:user]
  end

  private

  def set_format
    request.format = 'json'
  end
end

