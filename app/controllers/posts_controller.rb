class PostsController < ApplicationController

def index
	@posts = Post.order("created_at DESC").page(params[:page]).per(5)
end

def show
	@post = Post.find(params[:id])
	@player_code = @post.get_player_code
end

def new
	@post = Post.new
end

def create
	@post = Post.new(params[:post])
  @post.set_link_type
	@post.set_embed_code
	@post.set_artist
  @post.set_title
	if @post.save
	  redirect_to(posts_path, :notice => 'Post was successfully created.')
	else
	  render 'new'
	end
end

end
