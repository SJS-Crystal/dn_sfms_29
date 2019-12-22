class ApplicationController < ActionController::Base
  rescue_from ActionController::InvalidAuthenticityToken, with: :show_error
  before_action :set_locale
  before_action :configure_permitted_parameters, if: :devise_controller?

  include SessionsHelper
  include UsersHelper

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit :sign_up,
                                      keys: User::DATA_TYPE_USERS
    devise_parameter_sanitizer.permit :account_update,
                                      keys: User::DATA_TYPE_UPDATE_PROFILE
  end

  def show_error
    flash[:alert] = I18n.t ".invalid athenticity token"
    redirect_to request.base_url
  end
end
