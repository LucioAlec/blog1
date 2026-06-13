require "test_helper"

describe PostsController do
  let(:existing_post) { posts(:oldest) }

  describe "Index" do
    it "Should access the index page" do
      get "/posts"

      assert_select "h1", "Posts"
    end

    it "Should order by creation date" do
      get "/posts"

      expected = [ posts(:newest), posts(:oldest) ]
      assert_equal expected, Post.order(created_at: :desc).to_a
    end
  end

  describe "Show" do
    it "Should access a post show page" do
      get "/posts/#{existing_post.id}"

      assert_response :success
      assert_select "h1", "Post #{existing_post.title}"
    end
  end

  describe "New" do
    it "Should access a new post page" do
      get "/posts/new"

      assert_response :success
      assert_select "form"
    end
  end

  describe "Create" do
    it "Should ignore attributes outside the strong params range" do
      assert_difference("Post.count", 1) do
        post "/posts", params:
        { post: {
            title: "Test",
            description: "Just a test",
            created_at: 10.years.ago
          }
        }
      end

      post_record = Post.last
      assert_redirected_to post_record
      assert_equal "Post created successefully.", flash[:notice]

      assert_not_equal 10.years.ago.to_date, post_record.created_at.to_date
    end

    it "Should not create with invalid data" do
      assert_no_difference("Post.count") do
        post "/posts", params:
        {
          post: {
            title: nil,
            description: "Just a test"
          }
        }
      end

      assert_response :unprocessable_entity
      assert_equal "Invalid input!", flash[:alert]
    end
  end

  describe "Edit" do
    it "Should access a edit post page" do
      get "/posts/#{existing_post.id}/edit"

      assert_response :success
      assert_select "form"
    end
  end

  describe "Update" do
    it "Should update a post with valid attributes" do
      assert_changes -> { existing_post.reload.title }, to: "Test" do
        patch "/posts/#{existing_post.id}", params: {
          post: {
            title: "Test",
            description: "Just a test"
          }
        }
      end

      assert_redirected_to existing_post
      assert_equal "Post updated successfully!", flash[:notice]
    end

    it "Should not update a post with invalid attributes" do
      assert_no_changes -> { existing_post.reload.title } do
        patch "/posts/#{existing_post.id}", params:
        { post: {
            title: "",
            description: "Just a test"
          }
        }
      end

      assert_response :unprocessable_entity
    end
  end

  describe "Destroy" do
    it "Should delete a post" do
      assert_difference("Post.count", -1) do
        delete "/posts/#{existing_post.id}"
      end

      assert_response :see_other
      assert_redirected_to posts_path
      assert_equal "Post successfully deleted!", flash[:notice]
    end
  end
end
