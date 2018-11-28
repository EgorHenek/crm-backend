# frozen_string_literal: true

class SessionsController < Devise::SessionsController
  def create
    warden.authenticate!(scope: resource_name, recall: "#{controller_path}#new")
    render status: 200, json: { success: true, token: current_token }
  end

  def show
    if user_signed_in?
      render json: { user: {id: current_user.id, first_name: current_user.first_name, second_name: current_user.second_name, last_name: current_user.last_name, email: current_user.email, roles: current_user.roles.map(&:name), otp_required_for_login: current_user.otp_required_for_login}}
    end
  end

  private

  def current_token
    request.env['warden-jwt_auth.token']
  end
end
