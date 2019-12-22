class UsersController < ApplicationController
  before_action ->{authenticate_user! force: true}, :admin_user
  before_action :load_user, except: :index
  layout :load_layout

  def index
    @users = User.recent.search(params[:search])
                 .paginate page: params[:page], per_page: Settings.size.s10
  end

  def edit; end

  def update
    if @user.update update_user_params
      flash[:notice] = t ".profile_updated"
      redirect_to admin_users_path
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:notice] = t "msg.destroy_success"
      redirect_to admin_users_path
    else
      flash.now[:alert] = t "msg.destroy_danger"
      redirect_to admin_users_path
    end
  end

  private

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = I18n.t ".id_unexist"
    redirect_to admin_users_path
  end

  def update_user_params
    params.require(:user).permit User::DATA_TYPE_UPDATE_ADMIN
  end

  def admin_user
    return if current_user.admin?

    redirect_to root_path
    flash[:alert] = t "msg.danger_permission"
  end

  def load_layout
    request.original_url.include?("admin") ? "admin/application" : "application"
  end
end
