class PostsController < ApplicationController

  def index
    if @tag = params[:tag]
      @posts = Post.tagged_with(@tag).order("created_at DESC").page(params[:page]).per(5)
    else
      @posts = Post.order("created_at DESC").page(params[:page]).per(5)
    end

    @tags = Post.tag_counts_on(:tags)
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
    begin
      raise unless @post.playable?
      @post.set_link_type
      @post.set_embed_code
      @post.set_artist
      @post.set_title
      logger.debug 'now setting TAGSS ....................'
      @post.set_tags
      if @post.save
        redirect_to(posts_path, :notice => 'Post was successfully created.')
      else
        render 'new'
      end
    rescue
      redirect_to new_post_path, :flash => { :error => 'Something went wrong. Please make sure your URL is a valid Bandcamp URL containing playable audio.' }
    end
  end
end
