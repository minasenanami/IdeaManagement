class Api::V1::CategoriesController < ApplicationController
  def create
    category = Category.find_or_create_by!(category_params)
    category.ideas.create!(idea_params)
    render json: { status: "201" }
  end

  private

    def category_params
      params.permit(:name)
    end

    def idea_params
      params.permit(:body)
    end
end
