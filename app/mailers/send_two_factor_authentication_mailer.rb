class SendTwoFactorAuthenticationMailer < ApplicationMailer
  def send_token
    @code = params[:code]
    mail(to: params[:email], subject: 'Код авторизации')
  end
end
