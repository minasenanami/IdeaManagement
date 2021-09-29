class Api::V1::CategoriesController < ApplicationController
  def create
    category = Category.find_or_create_by!(category_params)
    category.ideas.create!(idea_params)
    render json: { status: "201" }
  end

  def index
    category_word = Category.where(name: params[:name])
    result = Idea.where(category_id: category_word.ids).includes(:category)

    if result.any?
      render json: { data: match_result(result) }
    elsif params[:name].blank?
      no_match = Idea.order(created_at: :asc).includes(:category)
      render json: { data: match_result(no_match) }
    else
      render json: { status: "404" }
    end
  end

  private

    def match_result(match_items)
      match_items.map do |item|
        format(item)
      end
    end

    def format(item)
      {
        "id": item.id,
        "category": item.category.name,
        "body": item.body,
        "created_at": item.created_at.to_i,
      }
    end

    def category_params
      params.permit(:name)
    end

    def idea_params
      params.permit(:body)
    end
end
