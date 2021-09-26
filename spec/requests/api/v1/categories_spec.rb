require "rails_helper"

RSpec.describe "Api::V1::Categories", type: :request do
  describe "POST /api/v1/categories" do
    subject { post(api_v1_categories_path, params: params) }
    context "nameとbodyに必要な情報が存在するとき" do
      let(:params) { attributes_for(:category).merge(attributes_for(:idea)) }
      it "カテゴリーとアイデアの作成に成功する" do
        expect{ subject }.to change {Idea.count}.by(1)
        res = JSON.parse(response.body)
        expect(res["status"]).to eq "201"
        expect(response).to have_http_status(:ok)
      end
    end


  end
end
