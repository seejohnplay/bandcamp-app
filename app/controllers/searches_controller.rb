class SearchesController < ApplicationController
  def show
    if params[:q].present?
      @search = Post.search(CGI.escape(params[:q])).page(params[:page]).per(5)
    else
      redirect_to(:back)
    end
  end
end