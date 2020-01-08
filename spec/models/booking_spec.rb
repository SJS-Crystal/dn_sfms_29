require "rails_helper"

RSpec.describe Booking do
  let(:user){FactoryBot.create :user}
  let(:owner){FactoryBot.create :user, role: 1}
  let(:subpitch_type){FactoryBot.create :subpitch_type}
  let(:pitch){FactoryBot.create :pitch, user_id: owner.id}
  let(:subpitch) do
    @subpitch =
      FactoryBot.create :subpitch, pitch_id: pitch.id,
                                   subpitch_type_id: subpitch_type.id
  end
  let(:booking) do
    FactoryBot.create :booking, user_id: user.id, subpitch_id: subpitch.id
  end

  let(:not_pay_booking) do
    FactoryBot.create :booking, user_id: user.id, subpitch_id: subpitch.id,
                                status: 1
  end
  before data: :booking do
    start_time = 1.day.ago
    @booking_past =
      FactoryBot.create :booking, user_id: user.id, subpitch_id: subpitch.id,
                                  start_time: start_time,
                                  end_time: start_time + 1.hour
    start_time = DateTime.now
    @booking_today =
      FactoryBot.create :booking, user_id: user.id, subpitch_id: subpitch.id,
                                  start_time: start_time,
                                  end_time: start_time + 1.hour
  end

  context "associations" do
    it {should have_one(:rating).dependent :destroy}
    it {should belong_to :user}
    it {should belong_to :subpitch}
  end

  context "validations" do
    it{should validate_presence_of :start_time}
    it{should validate_presence_of :end_time}
    it{should validate_presence_of :subpitch_id}
    it{should validate_presence_of :total_price}
    describe "#check_status + #check_exist" do
      it do
        expect(booking).to be_invalid :payment
        expect(booking.errors[:base]).to include I18n.t("cant_repay")
        expect(booking.errors[:base]).to include I18n.t("exist_paid_booking")
      end

      it do
        expect(not_pay_booking).to be_valid :payment
      end
    end
  end

  it "define enum" do
    should define_enum_for(:status).
      with_values(cancel: -1, verifiled_paid: 0, verifiled_not_pay: 1,
        unverifile: 2).backed_by_column_of_type(:integer)
  end

  context "delegates" do
    it {should delegate_method(:full_name).to(:user).with_prefix true}
    it {should delegate_method(:name).to(:subpitch).with_prefix true}
    it {should delegate_method(:pitch).to(:subpitch)}
    it {should delegate_method(:name).to(:pitch).with_prefix true}
    it {should delegate_method(:address).to(:pitch).with_prefix true}
  end

  context "scopes", data: :booking do
    it ".today" do
      Booking.today.should eq [@booking_today]
    end

    it ".recently" do
      Booking.recently.should eq [@booking_today, @booking_past]
    end
  end
end
