class ReviewsController < ApplicationController
  before_action :authenticate_user!

  def index
    post = Post.find(params[:post_id])
    @reviews = post.reviews_for(current_user)

    respond_to do |format|
      format.js
    end
  end

  def new
    @post = Post.find(params[:post_id])
    @review = @post.reviews.new
    respond_to do |format|
      format.js
    end
  end

  def create
    @post = Post.find(params[:post_id])
    @review = Review.new(review_params)
    @review.draft = true if params[:commit] == 'Save As Draft'

    if @review.save
      @reviews = @post.reviews_for(current_user)
      flash[:success] = 'Your review was successfully saved!'
      respond_to do |format|
        format.js { render :file => 'reviews/index' }
      end
    else
      render 'new'
    end
  end

  def edit
    @post = Post.find(params[:post_id])
    @review = Review.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  def update
    @review = Review.find(params[:id])
    @review.draft = false if params[:commit] == 'Submit Review'
    if @review.update(review_params)
      @post = Post.find(params[:post_id])
      @reviews = @post.reviews_for(current_user)
      flash[:success] = 'Your review was successfully saved!'
      respond_to do |format|
        format.js { render :file => 'reviews/index' }
      end
    else
      render 'new'
    end
  end

  private

  def review_params
    params.require(:review).permit(:body, :post_id, :user_id, :parent_id)
  end
end