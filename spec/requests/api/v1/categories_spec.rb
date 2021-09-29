require "rails_helper"

RSpec.describe "Api::V1::Categories", type: :request do
  describe "POST /api/v1/categories" do
    subject { post(api_v1_categories_path, params: params) }

    context "nameとbodyに必要な情報が存在するとき" do
      let(:params) { attributes_for(:category).merge(attributes_for(:idea)) }
      it "カテゴリーとアイデアの作成に成功する" do
        expect { subject }.to change { Idea.count }.by(1)
        res = JSON.parse(response.body)
        expect(res["status"]).to eq "201"
        expect(response).to have_http_status(:ok)
      end
    end

    context "カテゴリーが既に存在するとき" do
      let!(:category) { create(:category, name: "既存カテゴリー") }
      let(:params) { attributes_for(:category, name: "既存カテゴリー").merge(attributes_for(:idea)) }
      it "アイデアだけ作成される" do
        expect { subject }.to change { Idea.count }.by(1) &
                              not_change { Category.count }
        res = JSON.parse(response.body)
        expect(res["status"]).to eq "201"
        expect(response).to have_http_status(:ok)
      end
    end

    context "全情報が空欄のとき" do
      let(:params) { attributes_for(:category, name: nil).merge(attributes_for(:idea, body: nil)) }
      it "作成に失敗する" do
        expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context "カテゴリーが空のとき" do
      let(:params) { attributes_for(:category, name: nil).merge(attributes_for(:idea)) }
      it "作成に失敗する" do
        expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context "bodyが空欄のとき" do
      let(:params) { attributes_for(:category).merge(attributes_for(:idea, body: nil)) }
      it "作成に失敗する" do
        expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end

  describe "GET /api/v1/categories" do
    subject { get(api_v1_categories_path, params: params) }

    let!(:ideas) { create_list(:idea, idea_count) }
    let(:idea_count) { 4 }
    context "検索したカテゴリーのアイテムが存在する時" do
      let!(:category_item) { create(:category) }
      let!(:idea1) { create(:idea, category: category_item) }
      let!(:idea2) { create(:idea, category: category_item) }
      let!(:idea3) { create(:idea, category: category_item) }
      let(:params) { attributes_for(:category, name: category_item.name) }
      it "指定したカテゴリーを持つアイデア一覧を返す" do
        subject
        res = JSON.parse(response.body)

        expect(res["data"].count).to eq 3
        expect(res["data"][0].keys).to eq ["id", "category", "body", "created_at"]
        expect(res["data"][0]["category"]).to eq params[:name]
        expect(response).to have_http_status(:ok)
      end
    end

    context "リクエストが空のとき" do
      it "登録されているアイデアの一覧を返す" do
      end
    end

    context "リクエストしたカテゴリーが存在しないとき" do
      it "404を返す" do
      end
    end
  end
end
