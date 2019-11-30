module UsersHelper
  private

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t ".id_unexist"
    redirect_to root_path
  end

  def correct_user
    return if current_user? @user

    flash[:danger] = t ".not_allow"
    redirect_to root_path
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t ".please_log_in"
    redirect_to login_path
  end
end
