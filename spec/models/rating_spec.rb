require "rails_helper"

RSpec.describe Rating do
  describe "associations" do
    it{should belong_to :user}
    it{should belong_to :booking}
    it{should have_many(:comments).dependent :destroy}
  end

  describe "validations" do
    it{should validate_presence_of :content}
    it{should validate_length_of(:content).is_at_least Settings.size.s10}
    it{should validate_presence_of :star}
    it {should validate_numericality_of(:star)}
    it {should allow_value(3).for(:star)}
    it {should_not allow_value(0).for(:star)}
    it {should_not allow_value(63).for(:star)}
  end

  describe "delegates" do
    it{should delegate_method(:status).to(:booking).with_prefix}
    it{should delegate_method(:total_price).to(:booking).with_prefix}
    it{should delegate_method(:full_name).to(:user).with_prefix}
  end
end
