require 'test_helper'

class ReminderMailerTest < ActionMailer::TestCase
  tests ReminderMailer
  def test_remind
    @expected.subject = 'ReminderMailer#remind'
    @expected.body    = read_fixture('remind')
    @expected.date    = Time.now

    assert_equal @expected.encoded, ReminderMailer.create_remind(@expected.date).encoded
  end

end
