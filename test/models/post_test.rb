require "test_helper"

describe Post do
  describe "Validations" do
    it "Should is invalid without a name" do
      post = Post.new(title: "")
      refute post.valid?

      assert_includes post.errors[:title], "can't be blank"
    end
  end
end