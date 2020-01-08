require "rails_helper"

RSpec.describe Comment do
  let(:user){FactoryBot.create :user}
  let(:owner){FactoryBot.create :user, role: 1}
  let(:subpitch_type){FactoryBot.create :subpitch_type}
  let(:pitch){FactoryBot.create :pitch, user_id: owner.id}
  let(:subpitch) do
    @subpitch =
      FactoryBot.create :subpitch, pitch_id: pitch.id,
                                   subpitch_type_id: subpitch_type.id
  end
  context "associations" do
    it{should belong_to :user}
  end

  context "validations" do
    it{should validate_presence_of :rating_id}
    it{should validate_presence_of :content}
    it{should validate_presence_of :rating_id}
    it{should validate_presence_of :content}
    it{should validate_length_of(:content).is_at_most(Settings.comment_length_max)}
    it{should validate_length_of(:content).is_at_most(Settings.comment_length_max)}
  end
  context "scopes" do
    it ".by_rating" do
      @booking1 = FactoryBot.create :booking, user_id: user.id,
        subpitch_id: subpitch.id
      @booking2 = FactoryBot.create :booking, user_id: user.id,
        subpitch_id: subpitch.id
      @rating1 = FactoryBot.create :rating, user_id: user.id,
        booking_id: @booking1.id
      @rating2 = FactoryBot.create :rating, user_id: user.id,
        booking_id: @booking2.id
      @comment1 = FactoryBot.create :comment, user_id: user.id,
        rating_id: @rating1.id
      @comment2 = FactoryBot.create :comment, user_id: user.id,
        rating_id: @rating2.id
      Comment.by_rating(@rating1).should eq [@comment1]
      Comment.by_rating(@rating2).should eq [@comment2]
    end
  end
  it{should delegate_method(:full_name).to(:user).with_prefix true}
end