ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 'bundler/setup'
require 'time'
require 'base64'

module RNK
  def self.production?
    ENV['RNK_ENV'] == 'production'
  end
  def self.mode
    production? ? 'production' : 'development'
  end
  def self.config
    @@config ||= YAML.load_file(File.expand_path('../config.yml', __FILE__))[self.mode]
  end
  def self.groups
    ['default'] << self.mode
  end
  def self.root
    File.expand_path('../../', __FILE__)
  end
  def self.soap
    @soap ||= Savon.client(
        wsdl: self.config['wsdl'],
        follow_redirects: true,
        log_level: :info,
        raise_errors: true,
        encoding: 'windows-1251'
    )
  end
end

Bundler.require(*RNK.groups)

Dir[File.join(RNK.root, 'app/*.rb')].each {|file| require file }

Mail.defaults do
  delivery_method :smtp, RNK.config['smtp']
end

Mailer.config(RNK.config['smtp'])
