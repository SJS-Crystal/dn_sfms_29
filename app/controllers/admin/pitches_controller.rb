class Admin::PitchesController < AdminController
  before_action :load_pitches_index, only: :index
  before_action :load_pitch, :check_pitch_owner,
    only: %i(show edit update destroy)


  def index; end

  def show; end

  def new
    @pitch = current_user.pitches.build
  end

  def create
    @pitch = current_user.pitches.build pitch_params
    if @pitch.save
      flash[:success] = t ".success"
      redirect_to admin_pitch_path(@pitch)
    else
      flash.now[:danger] = t ".danger"
      render :new
    end
  end

  def edit; end

  def update
    if @pitch.update pitch_params
      flash[:success] = t ".success"
      redirect_to admin_pitch_path(@pitch)
    else
      flash.now[:danger] = t ".danger"
      render :edit
    end
  end

  def destroy
    if @pitch.destroy
      flash[:success] = t ".success"
    else
      flash[:danger] = t ".danger"
    end
    redirect_to admin_pitches_path
  end

  private

  def load_pitch
    @pitch = Pitch.find_by id: params[:id]
    return if @pitch

    flash[:danger] = t ".pitchs.danger_load"
    redirect_to admin_pitches_path
  end

  def pitch_params
    params.require(:pitch).permit Pitch::PARAMS
  end

  def load_pitches_index
    @pitches = Pitch.accessible_by(current_ability, :update)
                    .search(params[:search]).newest
                    .paginate page: params[:page], per_page: Settings.size.s10
  end

  def check_pitch_owner
    return unless check_owner?
    return if @pitch.user_id == current_user.id

    flash[:danger] = t "msg.danger_permission"
    redirect_to admin_pitches_path
  end
end
