class ApplicationResponder < ActionController::Responder
  protected

  def json_resource_errors
    {
        status: false,
        errors: resource.errors.full_messages
    }
  end
end