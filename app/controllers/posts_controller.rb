class PostsController < ApplicationController

def index
	@posts = Post.order("created_at DESC").page(params[:page]).per(5)
end

def show
	@post = Post.find(params[:id])
	@player_code = @post.get_player_code(@post)
end

def new
	@post = Post.new
end

def create
	@post = Post.new(params[:post])
  @post.set_link_type
	@post.set_embed_code
	@post.set_album_artist
	if @post.link_type == 'album'
		@post.title = @post.extract_album_title(@post.url) 
	else
		@post.title = @post.extract_track_title(@post.url)
	end
	if @post.save
	  redirect_to(posts_path, :notice => 'Post was successfully created.')
	else
	  render 'new'
	end
end

end
