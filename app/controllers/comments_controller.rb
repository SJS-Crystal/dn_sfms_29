class CommentsController < ApplicationController
  authorize_resource
  prepend_before_action :preprocess_and_save, only: :create
  prepend_before_action :check_creator, only: %i(update destroy)
  prepend_before_action :load_author_comment, only: %i(update destroy)
  prepend_before_action :load_comment, only: %i(update destroy)
  prepend_before_action :authenticate_user!

  def create
    respond_to do |format|
      if !flash.now[:alert]
        format.js{flash.now[:notice] = t ".comment_success"}
      else
        format.js{flash.now[:alert]}
      end
    end
  end

  def destroy; end

  def update; end

  private

  def preprocess_and_save
    load_rating
    load_subpitch
    allow_user_booked_and_owner
    return if flash.now[:alert]

    @comment = current_user.comments.build comment_params
    flash.now[:alert] = @comment.errors.full_messages.first unless @comment.save
  end

  def comment_params
    params.require(:comment).permit Comment::ALLOW_PARAMS
  end

  def allow_user_booked_and_owner
    return if flash.now[:alert]

    @user_booked = @rating.booking.user
    @owner = @subpitch.pitch.user
    return if current_user?(@user_booked) || current_user?(@owner)

    flash.now[:alert] = t ".not_allow"
  end

  def load_rating
    return if flash.now[:alert]

    @rating = Rating.find_by id: comment_params[:rating_id]
    return if @rating

    flash.now[:alert] = t ".not_found_rating_id"
  end

  def load_subpitch
    return if flash.now[:alert]

    @subpitch = @rating.subpitch
  end

  def load_author_comment
    @user = User.find_by id: @comment.user_id
  end

  def load_comment
    @comment = Comment.find_by id: params[:comment][:id]
    return if @comment

    flash[:danger] = t ".not_found_comment"
    redirect_to root_path
  end
end
