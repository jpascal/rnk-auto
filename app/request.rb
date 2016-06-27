#encoding: UTF-8

module RNK
  class Request
    include Sidekiq::Worker
    def perform(schedule_response = true)
      begin
        # Нету кода запроса, надо отправить запрос
        logger.info 'Send new request.'

        document = Document.new(RNK.config['operator'].merge(csptestf: RNK.config['csptestf']))
        document.save

        # Отправляем запрос на сервер РКН
        response = RNK.soap.call :send_request, message: {
          requestFile: Base64.encode64(document.request.read),
          signatureFile: Base64.encode64(document.sign.read),
          dumpFormatVersion: RNK.config['format'].to_s
        }
        body = response.body[:send_request_response]
        unless body[:result]
          # Ошибка в разпросе
          logger.error body[:result_comment]
          Mailer.error(error: body[:result_comment]).deliver!
        else
          # Получен код для получения результата
          logger.info "Received code '#{body[:code]}' for request"
          # Отправить писмо или СМС об сформированном запросе
          Mailer.request(code: body[:code]).deliver!
          if schedule_response
            RNK::Response.delay_for(60 * 10).perform_async(body[:code], true)
            logger.info "Scheduled get report after 60 seconds for '#{body[:code]}'"
          end
        end
        document.destroy
      rescue => error
        logger.error error.message
        Mailer.error(error: error.message).deliver!
      end
    end
  end
end