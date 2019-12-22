class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    generic_callback :facebook
  end

  def google_oauth2
    generic_callback :google_oauth2
  end

  def generic_callback provider
    @user = User.from_omniauth request.env["omniauth.auth"]
    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      return unless is_navigational_format?

      set_flash_message :notice, :success, kind: provider.capitalize
    else
      redirect_to new_user_session_path
      return unless is_navigational_format?

      set_flash_message :error, :failure, kind: provider.capitalize
    end
  end
end
