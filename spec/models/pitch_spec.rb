require "rails_helper"

RSpec.describe Pitch do
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
    it do
      should validate_length_of(:limit).is_at_least(Settings.size.s1).
        is_at_most Settings.size.s2
    end
    it{should allow_value(1).for :limit}
    it{should allow_value(99).for :limit}
    it{should_not allow_value(111).for :limit}
    it{should_not allow_value("1a").for :limit}

    it do
      @picth = Pitch.new
      # should allow_value(DateTime.now.zone).for :start_time
    end
  end

  context "delegates" do
    it {should delegate_method(:id).to(:user).with_prefix true}
  end
end
