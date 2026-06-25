require "test_helper"

describe CommentsController do
let(:existing_post) { posts(:oldest) }
let(:existing_comment) { comments(:one) }

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
      assert_redirected_to "/posts/#{existing_post.id}"
      assert_redirected_to post_path(existing_post)

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

  describe "Edit" do
    it "Should access a edit comment page" do
      get "/posts/#{existing_post.id}/comments/#{existing_comment.id}/edit"

      # get edit_post_comment_path(existing_post, existing_comment)

      assert_response :success
      assert_select "form"
    end
  end

  describe "Update" do
    it "Should update a comment with valid attributes" do
      assert_changes -> { existing_comment.reload.description }, to: "NICE!" do
        patch "/posts/#{existing_post.id}/comments/#{existing_comment.id}",
         params:
          { comment: {
              description: "NICE!"
            }
          }
      end

      assert_redirected_to "/posts/#{existing_post.id}"
      # assert_redirected_to post_path(existing_post)

      assert_equal "Comment updated successfully", flash[:notice]
      assert_equal "NICE!", existing_comment.description
    end

    it "Should not update a comment with invalid attributes" do
        assert_no_changes -> { existing_comment.reload.description } do
        patch "/posts/#{existing_post.id}/comments/#{existing_comment.id}",
         params:
          { comment: {
              description: ""
            }
          }
      end

      assert_response :unprocessable_entity
    end
  end

  describe "Destroy" do
    it "Should delete a comment" do
      assert_difference("Comment.count", -1) do
        delete "/posts/#{existing_post.id}/comments/#{existing_comment.id}"
      end

      assert_redirected_to "/posts/#{existing_post.id}"
      assert_equal "Comment successfully deleted!", flash[:notice]
    end
  end
end
