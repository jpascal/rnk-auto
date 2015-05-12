#encoding: UTF-8

module RNK
  class Response
    include Sidekiq::Worker
    def perform(code, repeat = true)
      begin
        # Есть код запроса, надо получить результат
        logger.info("Fetch result: #{code}")
        response = RNK.soap.call :get_result, message: { code: code }
        body = response.body[:get_result_response]
        unless body[:result]
          # Результат по запросу не сформирован
          if body[:result_code] == '0'
            # Пока отрабатывается
            logger.warn body[:result_comment]
            # Следующая попытка через 10 минут
            if repeat
              logger.info 'Reschedule report\'s downloading'
              RNK::Response.delay_for(60 * 10).perform_async(code, repeat)
            end
          else
            # Ошибка в запросе
            logger.error body[:result_comment]
            # Отправить письмо или СМС об ошибке
            Mailer.error(error: body[:result_comment]).deliver!
          end
        else
          # Результат получен
          path = File.join(RNK.root,'files' ,Time.now.strftime('%d-%m-%Y-%H-%M')+'.zip')
          File.new(path,'w').write(Base64.decode64(body[:register_zip_archive]))
          logger.info "Result was fetched to #{path}"
          mail = Mailer.response(code: code)
          mail.add_file(:filename => Time.now.strftime('%d-%m-%Y-%H-%M')+'.zip', :content => File.read(path))
          mail.deliver!
        end
      rescue => error
        logger.error error.message
        Mailer.error(error: body[:result_comment]).deliver!
      end
    end
  end
end