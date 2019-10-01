require 'test_helper.rb'

class CreateArticleTest < ActionDispatch::IntegrationTest
   
   def setup
      @user = User.create(username: "user", email: "user@example.com", password: "password")
   end
   
   test "get new article form and create article" do
      sign_in_as(@user, "password")
      get new_article_path 
      assert_template 'articles/new'
      assert_difference 'Article.count', 1 do
         post articles_path, params: {article: {title: "title", description: "A description" } }
         follow_redirect!
      end
      assert_template 'articles/show'
      assert_match "title", response.body
       
   end
   
   test "invalid submission results in failure" do
      sign_in_as(@user, "password")
      get new_article_path 
      assert_template 'articles/new'
      assert_no_difference 'User.count' do
         post articles_path, params: {article: {title: "ti", description: "A D" } }
      end
      assert_template 'articles/new'
      assert_select 'h2.panel-title'
      assert_select 'div.panel-body'
       
   end
    
end