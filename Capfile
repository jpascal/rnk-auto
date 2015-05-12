# Load DSL and set up stages
require 'capistrano/setup'

# Include default deployment tasks
require 'capistrano/deploy'

require 'capistrano/rbenv'
require 'capistrano/sidekiq'
require 'capistrano/bundler'

require 'erb'

# for generate config file from *.erb templates
def template(from, to)
  template_path = File.expand_path("../config/templates/#{from}", __FILE__)
  template = ERB.new(File.new(template_path).read).result(binding)
  upload! StringIO.new(template), to
end

# Load custom tasks from `lib/capistrano/tasks` if you have any defined
Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }

def config(key)
  @deploy_config ||= YAML.load_file(File.expand_path('../config/deploy.yml',__FILE__))[fetch(:stage).to_s]
  @deploy_config[key.to_s]
end
