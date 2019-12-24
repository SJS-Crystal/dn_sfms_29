class DeviseCustom::RegistrationsController < Devise::RegistrationsController
  authorize_resource class: User
  prepend_before_action :load_user, only: :show

  private

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = I18n.t ".id_unexist"
    redirect_to root_path
  end
end
