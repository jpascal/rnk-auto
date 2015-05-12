require File.expand_path('../config/boot', __FILE__)

require 'sinatra'
require 'sidekiq/web'

run Sidekiq::Web

