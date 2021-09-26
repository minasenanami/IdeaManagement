require "rails_helper"

RSpec.describe Idea, type: :model do
  describe "正常系" do
    context "bodyが存在するとき" do
      let(:idea) { build(:idea) }
      it "アイデアの登録に成功する" do
        expect(idea).to be_valid
      end
    end
  end

  describe "異常系" do
    context "bodyが存在しないとき" do
      let(:idea) { build(:idea, body: nil) }
      it "作成に失敗する" do
        expect(idea).to be_invalid
        expect(idea.errors.details[:body][0][:error]).to eq :blank
      end
    end
  end
end
