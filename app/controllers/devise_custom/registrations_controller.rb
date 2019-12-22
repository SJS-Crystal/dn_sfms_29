class DeviseCustom::RegistrationsController < Devise::RegistrationsController
  before_action ->{authenticate_user! force: true}, :load_user, only: :show

  def show; end

  private

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = I18n.t ".id_unexist"
    redirect_to root_path
  end
end
