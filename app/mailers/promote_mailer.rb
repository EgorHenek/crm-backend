class PromoteMailer < ApplicationMailer
  default from: 'УРАЛТРЕЙД <support@crm.henek.ru>'

  def promote_email
    @client = params[:client]
    @text = params[:text]
    mail(to: @client.email, subject: params[:title])
  end
end
