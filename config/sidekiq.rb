require_relative 'boot'

Sidekiq::Cron::Job.destroy_all!
Sidekiq::Cron::Job.new(RNK.config['job'].merge({:'name' => 'RKN::Request', :'klass' => 'RNK::Request'})).save


