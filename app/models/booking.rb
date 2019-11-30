class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :subpitch
  has_one :rating, dependent: :destroy

  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :subpitch_id, presence: true
  validates :total_price, presence: true
  validate :check_status, on: :payment
  validate :check_exist, on: :payment

  delegate :full_name, to: :user, prefix: true
  delegate :name, to: :subpitch, prefix: true

  scope(:today, lambda do
    where "date_format(start_time, \"%Y%m%d\") = ?",
          Time.zone.today.strftime("%Y%m%d")
  end)
  scope :paid, ->{where status: Settings.paid_status_booking}
  scope :asc, ->{order(created_at: :asc)}
  scope :desc, ->{order(created_at: :desc)}

  private

  def check_status
    return unless (Booking.find_by id: id).status.zero?

    errors.add :base, I18n.t("cant_repay")
  end

  def check_exist
    return unless Booking.find_by subpitch_id: subpitch_id,
      start_time: start_time, status: Settings.paid_status_booking

    errors.add :base, I18n.t("exist_paid_booking")
  end
end
