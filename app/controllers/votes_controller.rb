class VotesController < ApplicationController

  def create
    post = Post.find(params[:post_id])
    post.votes.create(vote_params)
    respond_to do |format|
      format.html { redirect_to root_path }
      format.js do
        @post_id = post.id.to_json
        @post_votes = post.vote_number.to_json
      end
    end
  end

  private

  def vote_params
    params.required(:vote).permit(:direction, :post_id)
  end

end