class StaticPagesController < ApplicationController
  def home
    @q = Pitch.ransack params[:q]
    @pitches = @q.result.accessible_by(current_ability).newest
                 .paginate page: params[:page], per_page: Settings.size.s_12
    respond_to do |format|
      format.html{render :home}
      format.js {}
    end
  end

  def blog; end

  def about; end

  def contact; end
end
