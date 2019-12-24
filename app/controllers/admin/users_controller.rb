class Admin::UsersController < AdminController
  prepend_before_action :load_user, except: :index
  prepend_before_action :load_user_index, only: :index
  before_action :check_admin

  def index; end

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
    else
      flash.now[:alert] = t "msg.destroy_danger"
    end
    redirect_to admin_users_path
  end

  private

  def load_user_index
    @users = User.recent.search(params[:search])
                 .paginate page: params[:page], per_page: Settings.size.s10
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = I18n.t ".id_unexist"
    redirect_to admin_users_path
  end

  def update_user_params
    params.require(:user).permit User::DATA_TYPE_UPDATE_ADMIN
  end
end
