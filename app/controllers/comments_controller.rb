class CommentsController < ApplicationController
  def create
    @meetup = Meetup.find(params[:meetup_id])
    @comment = @meetup.comments.build(comment_params)
    if @comment.save
      redirect_to meetup_path(@meetup), notice: "Thanks for commenting!"
    else
      flash.now[:notice] = "ERRAH"
      render "meetups/show"
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:title, :body)
  end
end
