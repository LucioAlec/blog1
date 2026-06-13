class CommentsController < ApplicationController
  before_action :set_post, only: [ :index, :new, :create ]
  def index
    @comments = @post.comments
  end

  def new
    @comment = @post.comments.new
  end

  def create
    @comment = @post.comments.new(comments_params)

    if @comment.save
      redirect_to post_comments_path(@post), notice: "OK"
    else
      flash.now[:alert] = "OOPS!"
      render :new, status: :unprocessable_entity
    end
  end



private
  def set_post
    @post = Post.find(params[:post_id])
  end

  def comments_params
    params.require(:comment).permit(:description)
  end
end
