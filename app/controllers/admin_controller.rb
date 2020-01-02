class AdminController < ApplicationController
  before_action :authenticate_user!, :check_user
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

  def get_user_by pitch
    pitch.user_id
  end

  def check_pitch_owner pitch
    return unless check_owner?
    return if get_user_by(pitch) == current_user.id

    flash[:danger] = t "msg.danger_permission"
    redirect_to admin_pitches_path
  end
end
