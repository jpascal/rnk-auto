namespace :sidekiq do
  desc "Generate sidekiq config file"
  task :config do
    on roles(:app) do
      template "rnk-auto.sh.erb", "#{shared_path}/config/rnk-auto.sh"
    end
  end
end