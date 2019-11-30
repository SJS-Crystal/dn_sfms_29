class Subpitch < ApplicationRecord
  belongs_to :pitch
  belongs_to :subpitch_type

  has_many :bookings, dependent: :destroy
  has_many :ratings, through: :bookings
  has_many :comments, through: :ratings

  delegate :name, to: :pitch, prefix: true
  delegate :name, to: :subpitch_type, prefix: true

  has_one_attached :picture
  scope :by_pitch, ->(pitch_id){where(pitch_id: pitch_id)}
end
