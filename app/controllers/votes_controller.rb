class VotesController < ApplicationController

	def create
		post = Post.find(params[:post_id])
		post.votes.create(params[:vote])
		redirect_to root_path
	end

end
