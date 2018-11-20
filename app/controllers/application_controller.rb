# frozen_string_literal: true

class ApplicationController < ActionController::API
  self.responder = ApplicationResponder
  include ActionController::MimeResponds
  respond_to :json
  rescue_from CanCan::AccessDenied do |_exception|
    render status: :forbidden
  end
  before_action :configure_permitted_parameters, if: :devise_controller?
  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name second_name email password password_confirmation])
  end
end
