class RegistrationsController < Devise::RegistrationsController

  def confirmation_email_sent
    flash[:notice] = "You will receive an email with instructions about how to confirm your account in a few minutes."
    redirect_to new_user_session_path
  end

  protected
  def after_inactive_sign_up_path_for(resource)
    confirmation_email_sent_path
  end

end