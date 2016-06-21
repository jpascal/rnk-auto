# config valid only for current version of Capistrano
lock '3.5.0'

set :application, config(:application)
set :repo_url, config(:repo_url)

set :user, config(:user)

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, config(:deploy_to)
set :home_path, config(:home_path)

# Default value for :scm is :git
set :scm, :git

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# Default value for :log_level is :debug
set :log_level, :debug

# Default value for :pty is false
set :pty, true

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/config.yml','config/sidekiq.yml')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp', 'files')

# Default stage
set :stage, :production

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 5

set :rbenv_type, :system
set :rbenv_ruby, '2.2.2'

set :sidekiq_config, File.join(release_path,'config', 'sidekiq.yml')
set :sidekiq_cmd, "#{fetch(:bundle_cmd, "bundle")} exec sidekiq"
set :sidekiqctl_cmd, "#{fetch(:bundle_cmd, "bundle")} exec sidekiqctl"

