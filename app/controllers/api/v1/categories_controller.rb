class Api::V1::CategoriesController < ApplicationController
  def create
    category = Category.find_or_create_by!(category_params)
    category.ideas.create!(idea_params)
    render json: { status: "201" }
  end

  def index
    category_word = Category.where(name: params[:name])
    result = Idea.find_by(category_id: category_word.ids)
    no_match = Idea.order(created_at: :asc).includes(:category)

    if result
      render json: match_result(result)
    else
      render json: not_match_result(no_match)
    end
  end

  private

    def not_match_result(not_match_items)
      not_match_items.map do |item|
        format(item)
      end
    end

    def match_result(match_item)
      format(match_item)
    end

    def format(item)
      {
        "data": [
          {
            "id": item.id.to_s,
            "category": item.category.name.to_s,
            "body": item.body.to_s,
            "created_at": item.created_at.to_i.to_s,
          },
        ],
      }
    end

    def category_params
      params.permit(:name)
    end

    def idea_params
      params.permit(:body)
    end
end
