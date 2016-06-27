namespace :rnk do
  desc 'Generate and send request to RNK'
  task :request do
    on roles(:app) do
      within current_path do
        execute :bundle, :exec, './bin/request'
      end
    end
  end
  desc 'Fetch result from RNK by code (rnk:response[code])'
  task :response, :code do |_, args|
    on roles(:app) do
      within current_path do
        execute :bundle, :exec, './bin/response', args[:code]
      end
    end
  end
end