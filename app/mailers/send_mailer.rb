class SendMailer < ApplicationMailer

  def send_test_mail
    mail(to: "benabcd5779@gmail.com", subject: "TEST!!!!")
  end

end
