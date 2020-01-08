require "rails_helper"

RSpec.describe Subpitch do
  describe "associations" do
    it{should have_many(:bookings).dependent :destroy}
    it{should belong_to :pitch}
    it{should belong_to :subpitch_type}
    it{should have_many(:ratings).through :bookings}
    it{should have_many(:comments).through :ratings}
  end

  describe "validations" do
    it{should validate_presence_of :name}
    it{should validate_length_of(:name).is_at_most Settings.size.s50}
    it{should validate_presence_of :price_per_hour}
    it{should validate_numericality_of :price_per_hour}
    it{should validate_presence_of :size}
    it{should validate_length_of(:size).is_at_most Settings.size.s50}
  end

  describe "delegates" do
    it{should delegate_method(:name).to(:pitch).with_prefix}
    it{should delegate_method(:name).to(:subpitch_type).with_prefix}
  end
end
