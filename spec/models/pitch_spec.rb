require "rails_helper"

RSpec.describe Pitch do
  before(init: :pitch) do
    @pitch = FactoryBot.build :pitch
  end
  context "associations" do
    it{should belong_to :user}
    it{should have_many(:subpitches).dependent :destroy}
  end

  context "validations" do
    it{should validate_presence_of :name}
    it{should validate_length_of(:name).is_at_most Settings.size.s50}
    it{should validate_length_of(:description).is_at_most Settings.size.s255}
    it{should validate_presence_of :country}
    it{should validate_length_of(:country).is_at_most Settings.size.s50}
    it{should validate_presence_of :city}
    it{should validate_length_of(:city).is_at_most Settings.size.s50}
    it{should validate_presence_of :district}
    it{should validate_length_of(:district).is_at_most Settings.size.s50}
    it{should validate_presence_of :address}
    it{should validate_length_of(:address).is_at_most Settings.size.s100}
    it{should validate_presence_of :phone}
    it do
      should validate_length_of(:phone).is_at_least(Settings.size.s6).
        is_at_most Settings.size.s12
    end
    it{should validate_presence_of :start_time}
    it{should validate_presence_of :end_time}
    it{should validate_presence_of :limit}

    describe "start_time, end_time, limit", init: :pitch do
      context "with valid start_time, valid end_time" do
        it "is valid with valid limit" do
          @pitch.should be_valid
        end

        it "is not valid with limit is out range" do
          @pitch.limit = (@pitch.end_time - @pitch.start_time) + 1
          @pitch.should_not be_valid
        end

        it "is not valid with limit is nil" do
          @pitch.limit = nil
          @pitch.should_not be_valid
        end
      end

      context "with invalid start_time or invalid end_time" do
        it "is not valid with start_time >= end_time" do
          @pitch.start_time = @pitch.end_time
          @pitch.should_not be_valid
        end
      end
    end
  end

  context "delegates" do
    it {should delegate_method(:id).to(:user).with_prefix true}
  end
end
