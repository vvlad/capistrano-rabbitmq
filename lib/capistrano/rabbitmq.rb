require "capistrano/rabbitmq/version"
require "capistrano/ubuntu"

module Capistrano
  module Rabbitmq
    # Your code goes here...
  end
end


import File.expand_path("../tasks/rabbitmq.rake", __FILE__ )
