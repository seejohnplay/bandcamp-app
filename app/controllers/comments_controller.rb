class CommentsController < ApplicationController
  def index
    post = Post.find(params[:post_id])
    @comments = post.comments.includes(:user)
    respond_to do |format|
      format.js
    end
  end

  def new
    @post = Post.find(params[:post_id])
    @comment = @post.comments.new
    respond_to do |format|
      format.js
    end
  end

  def create
    @post = Post.find(params[:post_id])
    @comment = Comment.new(comment_params)

    if @comment.save
      @comments = @post.comments.includes(:user)
      flash[:success] = 'Your comment was successfully added!'
      respond_to do |format|
        format.js { render :file => 'comments/index.js.erb' }
      end
    else
      render 'new'
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :post_id, :user_id, :parent_id)
  end
end