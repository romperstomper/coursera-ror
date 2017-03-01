class RecipesController < ApplicationController
  def index
    @search = params[:search] || :chocolate
    @visit = Recipe.for(@search) 
  end
end
