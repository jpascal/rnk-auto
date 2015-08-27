require_relative 'boot'

Sidekiq.configure_server do |config|
  config.redis = { namespace: 'rnk-auto' }
end

Sidekiq::Cron::Job.destroy_all!
Sidekiq::Cron::Job.new(RNK.config['job'].merge({:'name' => 'RKN::Request', :'klass' => 'RNK::Request'})).save


