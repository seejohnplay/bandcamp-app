class VotesController < ApplicationController

  def create
    post = Post.find(params[:post_id])
    post.votes.create(vote_params)
    post.update(popularity: post.calculate_popularity)
    respond_to do |format|
      format.html { redirect_to root_path }
      format.js do
        @post_id = post.id.to_json
        @post_votes = post.popularity.to_json
      end
    end
  end

  private

  def vote_params
    params.required(:vote).permit(:direction, :post_id)
  end

end