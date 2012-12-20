class VotesController < ApplicationController

	def create
		post = Post.find(params[:post_id])
		post.votes.create(params[:vote])
	 	respond_to do |format|
	 		format.html { redirect_to root_path }
	 		format.js do
	 			@post = post.id.to_json
	 			@post_votes = post.vote_number.to_json
	 		end 
	 end
	end

end
