class CommentsController < ApplicationController
  def create
    @comment = Comment.create(strong)
    if @comment.save
      redirect_to prototype_path(@comment.prototype)
    else
      @prototype = Prototype.find(params[:prototype_id])
      @comments = @prototype.comments
      render "prototypes/show"
    end
  end

  private
  def strong
    params.require(:comment).permit(:text).merge(user_id: current_user.id, prototype_id: params[:prototype_id])
  end
end
