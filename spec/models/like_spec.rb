require "rails_helper"

RSpec.describe Like do
  let(:user){FactoryBot.create :user}
  let(:owner){FactoryBot.create :user, role: 1}
  let(:subpitch_type){FactoryBot.create :subpitch_type}
  let(:pitch){FactoryBot.create :pitch, user_id: owner.id}
  context "associations" do
    it{should belong_to :user}
    it{should belong_to :subpitch}
  end

  context "scopes" do
    it ".by_subpitch" do
      @subpitch1 =
        FactoryBot.create :subpitch, pitch_id: pitch.id,
                                    subpitch_type_id: subpitch_type.id
      @subpitch2 =
        FactoryBot.create :subpitch, pitch_id: pitch.id,
                                    subpitch_type_id: subpitch_type.id
      @like1 = Like.create! subpitch_id: @subpitch1.id, user_id: user.id
      @like2 = Like.create! subpitch_id: @subpitch2.id, user_id: owner.id
      Like.by_subpitch(@subpitch1.id).should eq [@like1]
      Like.by_subpitch(@subpitch2.id).should eq [@like2]
    end
  end
end
