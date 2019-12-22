require "open-uri"
class User < ApplicationRecord
  after_create_commit :attach_avatar_default
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :validatable, :confirmable, :lockable, :timeoutable, :trackable,
         :omniauthable, omniauth_providers: [:facebook, :google_oauth2]
  DATA_TYPE_USERS = %i(full_name email password password_confirmation).freeze
  DATA_TYPE_UPDATE_PROFILE = %i(full_name phone gender password
    password_confirmation current_password).freeze
  DATA_TYPE_UPDATE_ADMIN = %i(wallet).freeze
  DATA_TYPE_RESETS_PASSWORD = %i(password password_confirmation).freeze
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.freeze
  VALID_PHONE_REGEX = /\A[\d]{10,}\z/i.freeze
  has_one_attached :avatar
  has_many :comments, dependent: :destroy
  has_many :bookings, dependent: :destroy
  has_many :pitches, dependent: :destroy
  validates :full_name, presence: true,
    length: {maximum: Settings.name_in_users_max}
  validates :email, presence: true,
    length: {maximum: Settings.email_in_users_max},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false, scope: :provider}
  validates :uid, uniqueness: {scope: :provider}, allow_nil: true
  validates :phone, format: {with: VALID_PHONE_REGEX}, allow_nil: true
  validates :gender, inclusion: {in: [true, false],
                                 message: "Gender is valid"}, allow_nil: true
  validates :password, presence: true, length:
    {minimum: Settings.password_min}, allow_nil: true
  validates :password, presence: true, length:
    {minimum: Settings.password_min}, on: :reset_password
  validates :wallet, numericality: {greater_than_or_equal_to: 0},
    allow_nil: true
  enum role: {admin: 0, owner: 1, user: 2}
  scope :recent, ->{order created_at: :desc}
  scope :search, (lambda do |search|
    if search
      where("full_name LIKE ? OR email LIKE ?", "%#{search}%", "%#{search}%")
    end
  end)

  class << self
    def from_omniauth auth
      where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
        user.email = auth.info.email
        user.provider = auth.provider
        user.uid = auth.uid
        user.full_name = auth.info.name
        user.password = Devise.friendly_token[0, 20]
        user.confirmed_at = Time.zone.now
        attach_avatar auth, user
      end
    end

    def attach_avatar auth, user
      downloaded_image = URI.parse(auth.info.image.to_s).open
      user.avatar.attach io: downloaded_image,
        filename: Settings.default_avatar_name
    end
  end

  private

  def attach_avatar_default
    return if provider

    avatar.attach io: File.open(Settings.avatar_default_path),
                        filename: Settings.default_avatar_name
  end
end
