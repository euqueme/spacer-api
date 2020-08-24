class ApplicationController < ActionController::API
  before_action :set_format

  private

  def set_format
    request.format = 'json'
  end
end
