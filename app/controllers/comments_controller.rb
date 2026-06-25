class CommentsController < ApplicationController
  before_action :set_post
  before_action :set_comment,  only: [ :edit, :update, :destroy ]

  def new
    @comment = @post.comments.new
  end

  def create
    @comment = @post.comments.new(comments_params)

    if @comment.save
      redirect_to post_path(@post), notice: "OK"
    else
      flash.now[:alert] = "OOPS!"
      render :new, status: :unprocessable_entity
    end
  end

  def edit ; end

  def update
    if @comment.update(comments_params)
      redirect_to @post, notice: "Comment updated successfully"
    else
      flash.now[:alert] = "Post not updated"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy
      redirect_to @post, notice: "Comment successfully deleted!"
  end


private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def set_comment
    @comment = @post.comments.find(params[:id])
  end

  def comments_params
    params.require(:comment).permit(:description)
  end
end
