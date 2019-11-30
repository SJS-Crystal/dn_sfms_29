class Rating < ApplicationRecord
  belongs_to :user
  belongs_to :booking
  delegate :subpitch, to: :booking
  has_many :comments, dependent: :destroy
end
