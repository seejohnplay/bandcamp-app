class ReviewsController < ApplicationController
  before_action :authenticate_user!

  def index
    post = Post.find(params[:post_id])
    @reviews = post.get_reviews_for(current_user)

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

    if @review.save
      @reviews = @post.get_reviews_for(current_user)
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