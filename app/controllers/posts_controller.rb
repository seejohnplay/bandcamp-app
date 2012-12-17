class PostsController < ApplicationController

def index
	@posts = Post.all
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
	@post.embed_code = @post.get_album_id(@post.url) if @post.url.include? '/album/'
	@post.embed_code = @post.get_track_id(@post.url) if @post.url.include? '/track/'
	@post.link_type = @post.set_link_type(@post.url)
	@post.artist = @post.extract_album_artist(@post.url)
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
