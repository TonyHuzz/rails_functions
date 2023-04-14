class HomeController < ApplicationController
  # require 'pb_string'   #require lib_name   可以在config/Application.rb裡面寫入autoload，這樣就不用在Controller寫require，也可以在app底下建立lib資料夾，在rails5裡面可以自動require lib資料夾內的東西

  def index
    @number = PbVersion.number
    @string1 = PbVersion.string1
    @string2 = PbVersion.new.string2
    @author = PbVersion.author
  end

  def send_mail                 #送信
    SendMailer.send_test_mail.deliver_now
    redirect_to root_path
  end
end
