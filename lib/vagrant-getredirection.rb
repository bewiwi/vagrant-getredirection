begin
  require "vagrant"
rescue LoadError
  raise "The Vagrant GetRedirection plugin must be run within Vagrant."
end

require "vagrant-getredirection/version"
require "vagrant-getredirection/controller"

module VagrantGetredirection

  class Plugin < Vagrant.plugin("2")

    name "vagrant-getredirection"
    description <<-DESC
    Display host and forwarded ports
    DESC

    command('redirection') do
      require File.expand_path("../vagrant-getredirection/command", __FILE__)
      Command
    end
  end
end
