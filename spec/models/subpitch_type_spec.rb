require "rails_helper"

RSpec.describe SubpitchType do
  context "aasociations" do
    it{should have_many(:subpitch).dependent :destroy}
  end

  context "validations" do
    it{should validate_presence_of :name}
    it{should validate_length_of(:name).is_at_most Settings.size.s50}
    it{should validate_length_of(:description).is_at_most Settings.size.s255}
  end

  describe ".search" do
    it "return array matches expect" do
      type1 = SubpitchType.create! name: "Sân cao cấp"
      type2 = SubpitchType.create! name: "San thường"
      type3 = SubpitchType.create! name: "noname"
      SubpitchType.search("Sân").should eq [type1, type2]
    end
  end
end
