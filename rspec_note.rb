# class ChangeUsersToUtf8mb4 < ActiveRecord::Migration[6.0]
#   def change
#     # # for each table that will store unicode execute:
#     # execute "ALTER TABLE users CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_bin"
#     # # for each string/text column with unicode content execute:
#     # execute "ALTER TABLE users MODIFY email VARCHAR(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin"
#   end
# end



# test by using request and feature specs.

#   # config/specs/features/teams_spec.html
#   RSpec.feature 'Teams' do
#     scenario 'when a user views the teams' do
#       Team.create(name: 'Team Rocket')
#       visit '/teams'
#       expect(page).to have_content 'Team Rocket'
#     end
#   end 

#   # config/specs/requests/teams_spec.html
#   RSpec.describe 'Teams', type: :request do
#     describe 'GET /teams.json' do
#       it "includes the team" do
#         team = Team.create(name: 'Team Rocket')
#         get teams_path(format: :json) 
#         expect(parsed_response.first['name']).to eq 'Team Rocket'
#       end  
#     end
#     describe 'GET /teams' do
#       it "includes the team" do
#         team = Team.create(name: 'Team Rocket')
#         get teams_path
#         expect(page).to have_content 'Team Rocket'
#       end  
#     end
#   end




# test capybara hay hay
# describe "GET 'index'" do
#   it "should be successful" do
#     user = Factory(:user)
#     visit login_path
#     fill_in "login", :with => user.login
#     fill_in "password", :with => user.password
#     click_button "Log in"
#     get 'index'
#     response.should be_success
#   end
# end

# 3.1 Creating an Object
# before_validation
# after_validation
# before_save
# around_save
# before_create
# around_create
# after_create
# after_save
# after_commit/after_rollback
# 3.2 Updating an Object
# before_validation
# after_validation
# before_save
# around_save
# before_update
# around_update
# after_update
# after_save
# after_commit/after_rollback
# 3.3 Destroying an Object
# before_destroy
# around_destroy
# after_destroy
# after_commit/after_rollback






# rails s -b 'ssl://localhost:3000?key=config/certs/localhost.key&cert=config/certs/localhost.crt'
# set_flash_message "key of flash hash", "key in i18n"[, option]

# set_flash_message :notice, :success, kind: provider.capitalize

# research these
# is_navigational_format?
# sign_in_and_redirect user, event: :authentication

#   devise_for :users,
#     controllers:{omniauth_callbacks: "omniauth_callbacks"}

# hot-fix
#   https://localhost:3000/users/edit.1

# let(:current_time) { Time.now }
  # Generates a method whose return value is memoized after the first call. Useful for reducing duplication between examples that assign values to the same local variable. The value will be cached across multiple calls in the same example but not across examples. Note that let is lazy-evaluated: it is not evaluated until the first time the method it defines is invoked.
  
# let:  run only one time when invoke(chỉ chạy 1 lần khi được gọi và được cached cho các lần gọi sau trong cùng example đó, chạy lại khi được gọi trong khối it khác...)
# let!: run before each it block(được cache lại giống let, nhưng nó tự động chạy trước mỗi khối it(không phải sau khi define) mặc dù trong khối it đó không gọi đến nó))

# subject { Person.new(:birthdate => 19.years.ago) }
# subject!
# subject có thể sử dụng implicitly thông qua is_expected.to hoặc should
# subject có thể sử dụng explicitly khi given a name subject(:name){Class.new} (lúc này nó vừa sử dụng được ở dạng implicitly và dạng explicitly như let)

# is_expected.to same as expect(subject).to as should

# subject, let is designed to create state that is reset between each example
# before(:context) is designed to setup state that is shared across all examples in an example group

# before(scope, condition, &block) ⇒ void
#   :suite -- conditions passed along with :suite are effectively ignored.
#   :context
      # thay đổi database
      # run only once before first it block(chỉ chạy một lần duy nhất vào thời điểm trước khối it đầu tiên )
      # reset status every it block (reset trạng thái khi chạy khối it mới nhưng không chạy before)
      # run in an example that is generated to provide group context for the block
      # Instance variables declared in before(:context) are shared across all the examples in the group. This means that each example can change the state of a shared object, resulting in an ordering dependency that can make it difficult to reason about failures.
#   :example
      # thay đổi database, then reset to original status before run before(:context)
      # run in every it example
  # Parameters:
    # scope (Symbol) — :example, :context, or :suite (defaults to :example)
    # conditions (Hash) — constrains this hook to examples matching these conditions e.g. after(:example, :ui => true) { ... } will only run with examples or groups declared with :ui => true.
    # When you add a conditions hash to before(:example) or before(:context), RSpec will only apply that hook to groups or examples that match the conditions. e.g.
          # RSpec.configure do |config|
          #   config.before(:example, :authorized => true) do
          #     log_in_as :authorized_user
          #   end
          # end
          
          # RSpec.describe Something, :authorized => true do
          #   # The before hook will run in before each example in this group.
          # end
          
          # RSpec.describe SomethingElse do
          #   it "does something", :authorized => true do
          #     # The before hook will run before this example.
          #   end
          
          #   it "does something else" do
          #     # The hook will not run before this example.
          #   end
          # end



# order
# before(:suite)    # Declared in RSpec.configure.
# before(:context)  # Declared in RSpec.configure.
# before(:context)  # Declared in a parent group.
# before(:context)  # Declared in the current group.
# before(:example)  # Declared in RSpec.configure.
# before(:example)  # Declared in a parent group.
# before(:example)  # Declared in the current group.

# after(:example) # Declared in the current group.
# after(:example) # Declared in a parent group.
# after(:example) # Declared in RSpec.configure.
# after(:context) # Declared in the current group.
# after(:context) # Declared in a parent group.
# after(:context) # Declared in RSpec.configure.
# after(:suite)   # Declared in RSpec.configure.


require "rails_helper"

class Thing
  def self.count
    @count ||= 0
  end

  def self.count=(val)
    @count += val
  end

  def self.reset_count
    @count = 0
  end

  def initialize
    self.class.count += 1
  end
end

RSpec.describe Thing do
  after(:example) { Thing.reset_count }

  context "using let" do
    let(:thing) { Thing.new }

    it "is not invoked implicitly" do
      Thing.count.should eq(0)
    end

    it "can be invoked explicitly" do
      thing
      Thing.count.should eq(1)
    end
  end

  context "using let!" do
    let!(:thing) { Thing.new }

    it "is invoked implicitly" do
      Thing.count.should eq(1)
    end

    it "returns memoized version on first invocation" do
      thing
      Thing.count.should eq(1)
    end
  end
end

RSpec.describe do
  before :example do
  # before :context do
    @demo = 1; p "declare @demo"
  end

  describe do
    
    it do
      p "add 1 unit to @a 1111"
      @demo += 1
      expect(@demo).to be == 2
      @demo += 1
      expect(@demo).to be == 3
    end

    describe do
      it do
        p "add 1 unit to @a 2222"
        @demo += 1
        expect(@demo).to be == 2
      end
    end
  end

  it do
    p "add 1 unit to @a 3333"
    @demo += 1
    expect(@demo).to be == 2
  end
end
