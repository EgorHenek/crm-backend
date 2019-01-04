class ClientMailer < ApplicationMailer
  default from: 'УРАЛТРЕЙД <support@crm.henek.ru>'

  def welcome_email
    @client = params[:client]
    mail(to: @client.email, subject: 'Спасибо за подписку')
  end
end
