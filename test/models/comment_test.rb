require "test_helper"

describe Comment do
  describe "Validations" do
    it "Should is valid with post to belongs" do
      post = posts(:oldest)
      comment = comments(:one)

      assert comment.valid?
    end
  end
end
