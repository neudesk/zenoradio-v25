class UserMailer < ActionMailer::Base
  default from: 'Admin <admin@zenoradio.com>', :return_path => 'admin@zenoradio.com'

  def request_content(options = {})
  	@content = options
    mail(to: options["to_emails"], subject: 'Request content')
  end
end