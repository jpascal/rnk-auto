class Mailer
  def self.config(options)
    @@options = options
  end
  def self.response(locals = {})
    mail __method__, 'Файл выгрузки получен', locals
  end
  def self.error(locals = {})
    mail __method__, 'Произошла ошибка', locals
  end
  def self.request(locals = {})
    mail __method__, 'Запрос на выгрузку отправлен', locals
  end
  protected
  def self.mail(template, subject, locals)
    Mail.new do
      from @@options[:from]
      to @@options[:to]
      subject subject
      html_part do
        content_type 'text/html; charset=UTF-8'
        body Template.render(template, locals)
      end
    end
  end
end

