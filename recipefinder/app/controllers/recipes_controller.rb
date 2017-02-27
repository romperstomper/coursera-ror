class RecipesController < ApplicationController
  def index
    unless params[:search]
      params[:search] = :chocolate
    end
  end
end
