require 'test_helper.rb'

class CreateUserTest < ActionDispatch::IntegrationTest
   
   def setup
      @user = User.new(username: "user", email: "user@example.com", password: "password")
   end
   
   test "get new user form and create user" do
      get signup_path 
      assert_template 'users/new'
      assert_difference 'User.count', 1 do
         post users_path, params: {user: {username: "user", email: "user@example.com", password: "password" }}
         follow_redirect!
      end
      assert_template 'users/show'
      assert_match "user", response.body
       
   end
   
   test "invalid submission results in failure" do
      get signup_path 
      assert_template 'users/new'
      assert_no_difference 'User.count' do
         post users_path, params: {user: {username: " ", email: " ", password: " " } }
      end
      assert_template 'users/new'
      assert_select 'h2.panel-title'
      assert_select 'div.panel-body'
       
   end
   
   
   test "Username and password should be valid" do
      assert @user.valid?
   
   end
   
   test "Username should be unique" do
       @user.save
       user2 = User.new(username: "user", email: "user1@example.com", password: "password")
       assert_not user2.valid?
       
   end
   
    test "Email should be unique" do
       @user.save
       user2 = User.new(username: "user1", email: "user@example.com", password: "password")
       assert_not user2.valid?
       
   end

    
end