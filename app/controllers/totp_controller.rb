class TotpController < ApplicationController
  authorize_resource class: false

  def create
    if current_user.otp_secret.present? && code_params[:code] === current_user.current_otp
      current_user.otp_required_for_login = true
      current_user.save
      render json: { success: true }, status: :created
    elsif current_user.otp_secret.present? && code_params[:code].present? && code_params[:code] != current_user.current_otp
      render json: { success: false }, status: :unprocessable_entity
    else
      current_user.otp_secret = User.generate_otp_secret
      current_user.save
      render json: { success: true, code: current_user.otp_secret, url: current_user.otp_provisioning_uri("CRM:#{current_user.email}", issuer: "CRM") }
    end
  end

  def delete
    if code_params[:code] === current_user.current_otp
      current_user.otp_required_for_login = false
      current_user.otp_secret = nil
      current_user.save
      render json: { success: true }
    else
      render json: { success: false, error: 'Код авторизации отсутствует или введён неверно' }, status: :unprocessable_entity
    end
  end

  def send_code
    SendTwoFactorAuthenticationMailer.with(email: current_user.email, code: current_user.current_otp).send_token.deliver_now
    render json: { success: true }, status: :created
  end

  protected

  def code_params
    params.permit(:code)
  end
end
