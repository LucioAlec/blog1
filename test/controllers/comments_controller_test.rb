require "test_helper"

describe CommentsController do
let(:existing_post) { posts(:oldest) }
let(:existing_comment) { comments(:one) }

  describe "Index" do
    it "Should access a index page for posts' comments" do
      get "/posts/#{existing_comment.post_id}/comments"

      assert_response :success
    end
  end

  describe "New" do
    it "Should access a new comment page" do
      get "/posts/#{existing_comment.post_id}/comments/new"

      assert_response :success
      assert_select "form"
    end
  end

  describe "Create" do
    it "Should ignore attributes outside the strong params range" do
      assert_difference("Comment.count", 1) do
        post "/posts/#{existing_comment.post_id}/comments", params:
          { comment: {
              description: "NICE!",
              created_at: 10.years.ago
            }
          }
      end

      comment = Comment.last
      assert_redirected_to "/posts/#{existing_post.id}/comments"
      assert_redirected_to post_comments_path(existing_post)

      assert_equal "OK", flash[:notice]

      assert_not_equal 10.years.ago.to_date, comment.created_at.to_date
    end

    it "Should not create with invalid data" do
      assert_no_difference("Comment.count") do
        post "/posts/#{existing_comment.post_id}/comments", params:
          { comment: {
              description: ""
            }
        }
      end

        assert_response :unprocessable_entity
        assert_equal "OOPS!", flash[:alert]
    end
  end
end
