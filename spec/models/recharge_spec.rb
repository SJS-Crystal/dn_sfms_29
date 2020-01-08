require "rails_helper"

RSpec.describe Recharge do
  context "associations" do
    it{should belong_to(:sender).class_name User.name}
    it{should belong_to(:receiver).class_name User.name}
  end
end
