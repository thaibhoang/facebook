require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  test "sign_up" do
    mail = UserMailer.sign_up
    assert_equal "Sign up", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
