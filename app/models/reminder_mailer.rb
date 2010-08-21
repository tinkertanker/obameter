class ReminderMailer < ActionMailer::Base
  

  def remind(person)
    subject    'You have outstanding promises'
    recipients person.e_mail
    from       'cowdinosaur@gmail.com'
    sent_on    Time.now
    
    body       :person => person
  end

  def remind_no_promise(person)
    subject    'Obameter misses you'
    recipients person.e_mail
    from       'cowdinosaur@gmail.com'
    sent_on    Time.now
    
    body       :person => person
  end

end
