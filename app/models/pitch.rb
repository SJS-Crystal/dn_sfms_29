class Pitch < ApplicationRecord
  NUMBER_FORMAT = /\A[\d]+\z/i.freeze
  PARAMS = %i(name description country city district address picture phone
              start_time(4i) start_time(5i)
              end_time(4i) end_time(5i) limit).freeze
  belongs_to :user
  has_many :subpitches, dependent: :destroy

  validates :name, presence: true, length: {maximum: Settings.size.s50}
  validates :description, length: {maximum: Settings.size.s255}
  validates :country, :city, :district,
            presence: true, length: {maximum: Settings.size.s50}
  validates :address, presence: true, length: {maximum: Settings.size.s100}
  validates :phone, presence: true, numericality: true,
            length: {in: Settings.size.s6..Settings.size.s12}
  validates :end_time, date: {after: :start_time}
  validates :limit, presence: true, format: {with: NUMBER_FORMAT},
            length: {in: Settings.size.s1..Settings.size.s2}
  validates :start_time, time: true
  validate :play_time_bigger_limit

  delegate :id, to: :user, prefix: true
  has_one_attached :picture

  scope :newest, ->{order(created_at: :desc)}

  scope :by_user, ->(id_user){where("user_id = ?", id_user)}

  private

  def play_time_bigger_limit
    return if limit.nil?
    return if (end_time - start_time) / 3600 >= limit

    errors.add :play_time_invalid, I18n.t("msg.play_time_invalid")
  end
end
