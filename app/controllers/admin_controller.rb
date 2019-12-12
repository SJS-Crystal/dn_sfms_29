class AdminController < ApplicationController
  before_action :check_logged_in, :check_user
  layout "admin/application"

  private

  def check_admin
    return if current_user.admin?

    redirect_to root_path
    flash[:danger] = t "msg.danger_permission"
  end

  def check_user
    return unless current_user.user?

    redirect_to root_path
    flash[:danger] = t "msg.danger_permission"
  end

  def check_admin?
    current_user.admin?
  end

  def check_owner?
    current_user.owner?
  end
end
