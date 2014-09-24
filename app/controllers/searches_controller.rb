class SearchesController < ApplicationController
  def show
    query = params[:q].gsub(/\W/, ' ')
    if query.present?
      @search = Post.search(query.split.join(' AND ')).page(params[:page]).per(5)
    elsif params[:q].blank?
      redirect_to root_path
    end
  end
end