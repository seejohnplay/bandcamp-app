class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :destroy]

  def index
    if @tag = params[:tag]
      @posts = Post.by_tag(@tag, params[:page])
    else
      @posts = Post.by_created_at(params[:page])
    end
  end

  def show
    @post = Post.find(params[:id])
    @comments = @post.comments.includes(:user)
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      redirect_to(posts_path, :notice => 'Post was successfully created.')
    else
      render 'new'
    end
  end


  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to(posts_path, :notice => 'Post was destroyed.')
  end

  private

  def post_params
    params.required(:post).permit(:embed_code, :url, :link_type, :title, :artist, :description, :artist_url)
  end

end