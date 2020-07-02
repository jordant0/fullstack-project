# frozen_string_literal: true

module Api
  # Handle user registration and login
  class UsersController < ApplicationController
    skip_before_action :authenticate_user!, only: %i[create login]

    # POST /api/users
    def create
      user = User.new(create_params)
      if user.save
        render json: { auth: user.auth_token }, status: :ok
      else
        render json: { errors: user.errors.full_messages.to_sentence }, status: :bad_request
      end
    end

    # GET /api/users/login
    def login
      user = User.find_by(email: params[:email])
      return render json: { error: 'No user with such email found' }, status: :bad_request unless user

      if user.authenticate(params[:password])
        render json: { auth: user.auth_token }, status: :ok
      else
        render json: { error: 'Invalid login' }, status: :bad_request
      end
    end

    private

    def create_params
      params.permit(:email, :password)
    end
  end
end
