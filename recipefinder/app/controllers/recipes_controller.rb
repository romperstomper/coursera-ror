class RecipesController < ApplicationController
  def index
    @search = params[:search] || :chocolate
    #@visit = Recipes.for(search) 
  end
end
