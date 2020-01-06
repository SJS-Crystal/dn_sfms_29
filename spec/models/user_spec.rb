require "rails_helper"

RSpec.describe User do
  let(:empty_user){User.new}
  let(:build_user) do
    User.new email: Faker::Internet.email,
             full_name: Faker::Name.name,
             password: Faker::String.random(length: 6..12)
  end

  before condition: :simulation_user do
    @nam = User.create email: "nam@gmail.com", full_name: "Bui Nhu Nam",
                       password: "123123"
    @hung = User.create email: "hung@gmail.com", full_name: "Nguyen Manh Hung",
                        password: "123123"
    @nhi = User.create email: "nhi@gmail.com", full_name: "Ha Van Nhi",
                       password: "123123"
    @trung = User.create email: "trung@gmail.com", full_name: "Do Nam Trung",
                         password: "123123"
  end

  def invalid_string
    "#{Faker::String.random(length: 100)}"
  end

  context "associations" do
    it {should have_many(:bookings).dependent(:destroy)}
    it {should have_many(:comments).dependent(:destroy)}
    it {should have_many(:pitches).dependent(:destroy)}
    it {should have_many(:likes).dependent(:destroy)}
  end

  context "validates" do
    it {should validate_presence_of :full_name}
    it {should validate_length_of(:full_name).is_at_most(Settings.name_in_users_max)}
    it {should allow_value("#{Faker::Name.name}").for :full_name}
    it {should_not allow_value("Fuckkk💩").for :full_name}
    it {should validate_presence_of :email}
    it {should validate_uniqueness_of(:email).scoped_to(:provider).case_insensitive}
    it {should validate_length_of(:email).is_at_most(Settings.email_in_users_max)}
    it {should allow_value("#{Faker::Internet.email}").for :email}
    it {should_not allow_value(invalid_string).for :email}
    it {should validate_uniqueness_of(:uid).scoped_to(:provider).allow_nil}
    it {should validate_presence_of(:password).allow_nil}
    it {should validate_presence_of(:password).on(:reset_password)}
    it {should validate_length_of(:password).is_at_least(Settings.password_min)}
    it {should validate_length_of(:password).is_at_least(Settings.password_min).on(:reset_password)}
    it {should have_secure_password}
    it {should validate_numericality_of(:wallet).is_greater_than_or_equal_to(0).allow_nil}
    it {should allow_value(Faker::Number.number(digits: Faker::Number.within(range: 10..20))).for :phone}
    it {should allow_value(nil).for :phone}
    it {should_not allow_value(Faker::Alphanumeric.alpha(number: 1..20)).for :phone}
    it {should_not allow_value(Faker::Number.number(digits: Faker::Number.within(range: 1..9))).for :phone}
    it do
      should define_enum_for(:role).
        with_values(admin: 0, owner: 1, user: 2).
        backed_by_column_of_type(:integer)
    end

    it "when user is valid" do
      expect(build_user).to be_valid
    end

    it "when without full_name, email, password" do
      expect(empty_user).to be_invalid
    end
  end

  context "test before_save callback" do
    it "should return email does not contain CAP letters" do
      build_user.email = "ABCde@gmail.com"
      build_user.save
      build_user.email.should eq("abcde@gmail.com")
    end
  end

  context "scopes" do
    it "should return array match", condition: :simulation_user do
      User.search("Nam").should eq [@nam, @trung]
    end

    it "should return users in the correct order", condition: :simulation_user do
      User.recently.should eq [@trung, @nhi, @hung, @nam]
    end
  end

  context ".digest + .new_token" do
    it "should be digest of token" do
      token = User.new_token
      token_digest = User.digest token
      BCrypt::Password.new(token_digest).is_password?(token).should eq true
    end
  end

  context "#remember" do
    it "should update correct remember_token" do
      build_user.remember
      token = build_user.remember_token
      digest = build_user.remember_digest
      BCrypt::Password.new(digest).is_password?(token).should eq true
    end
  end

  context "#authenticated?" do
    it "return true with correct token and digest" do
      token = SecureRandom.urlsafe_base64
      build_user.activation_digest = User.digest token
      build_user.authenticated?(:activation, token).should eq true
    end
  end

  context "#forget" do
    it do
      build_user.remember_digest = "abc"
      build_user.forget
      build_user.remember_digest.should eq nil
    end
  end

  context "#activate" do
    it "should return true" do
      build_user.activate.should eq true
    end
  end

  context "#send_activation_email" do
    it "should send one email" do
      build_user.activation_token = "abc"
      expect {build_user.send_activation_email}.to change {ActionMailer::Base.deliveries.count}.by 1
    end
  end

  context "#send_password_reset_email" do
    it "should send one email" do
      build_user.reset_token = "abc"
      expect {build_user.send_password_reset_email}.to change {ActionMailer::Base.deliveries.count}.by 1
    end
  end

  context "#create_reset_digest" do
    it {build_user.create_reset_digest.should eq true}
  end

  context "#password_reset_expired?" do
    it "return true when timeout" do
      build_user.reset_sent_at = (Settings.timeout_reset_password + 1).hours.ago
      build_user.password_reset_expired?.should eq true
    end

    it "return false when timein" do
      build_user.reset_sent_at = (Settings.timeout_reset_password - 1).hours.ago
      build_user.password_reset_expired?.should eq false
    end
  end

  context "#create_activation_digest" do
    it "should has activation_token attribute" do
      build_user.send :create_activation_digest
      build_user.activation_token.should_not be_empty
    end

    it "should has activation_digest attribute" do
      build_user.send :create_activation_digest
      build_user.activation_digest.should_not be_empty
    end
  end
end
