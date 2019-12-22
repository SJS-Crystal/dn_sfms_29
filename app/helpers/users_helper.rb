module UsersHelper
  private

  def correct_user user
    return if current_user? user

    flash[:danger] = t ".not_allow"
    redirect_to root_path
  end
end
