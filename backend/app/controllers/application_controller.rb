# frozen_string_literal: true

# Main application controller
class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  before_action :authenticate_user!

  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def current_user
    User.from_auth_token(request.headers['Authorization'])
  end

  def authenticate_user!
    render json: { error: 'Unauthorized' }, status: :unauthorized unless current_user
  end

  private

  def not_found
    render json: { error: 'Not found' }, status: :not_found
  end
end
