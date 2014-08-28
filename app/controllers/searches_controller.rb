class SearchesController < ApplicationController
  def show
    @search = Search.new(params[:search][:term])
  end
end