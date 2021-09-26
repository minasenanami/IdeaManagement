require "rails_helper"

RSpec.describe Category, type: :model do
  describe "正常系" do
    context "nameが一意のとき" do
      let(:category) { build(:category) }
      it "カテゴリーの作成に成功する" do
        expect(category).to be_valid
      end
    end
  end

  describe "異常系" do
    context "nameが空のとき" do
      let(:category) { build(:category, name: nil) }
      it "カテゴリーの作成に失敗する" do
        expect(category).to be_invalid
        expect(category.errors.details[:name][0][:error]).to eq :blank
      end
    end

    context "nameが重複するとき" do
      let!(:first_category) { create(:category, name: "青") }
      let(:category) { build(:category, name: "青") }
      it "カテゴリーの作成に失敗する" do
        expect(category).to be_invalid
        expect(category.errors.details[:name][0][:error]).to eq :taken
      end
    end
  end
end
