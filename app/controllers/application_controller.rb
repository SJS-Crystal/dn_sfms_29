class ApplicationController < ActionController::Base
  rescue_from ActionController::InvalidAuthenticityToken, with: :show_error
  rescue_from CanCan::AccessDenied do
    if current_user
      if controller_name == "comments"
        respond_to do |format|
          flash.now[:alert] = t "cant comment"
          format.js{render "comments/create.js.erb"}
        end
      else
        flash[:alert] = t "cancan_authorized"
      end
    elsif controller_name == "comments"
      respond_to do |format|
        flash.now[:alert] = t "unauthenticated"
        format.js{render "comments/create.js.erb"}
      end
    else
      flash[:alert] = t "unauthenticated"
    end
    redirect_to root_url if controller_name != "comments"
  end
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
    if controller_name == "comments"
      flash.now[:alert] = I18n.t ".invalid athenticity token"
    else
      flash[:alert] = I18n.t ".invalid athenticity token"
      redirect_to request.base_url
    end
  end
end
