require "vagrant"

module VagrantPlugins
  module Tachyon
    class Plugin < Vagrant.plugin("2")
      name "tachyon"
      description <<-DESC
      Provides support for provision via the tachyon tool
      DESC

      config(:tachyon, :provisioner) do
        require File.expand_path("../config", __FILE__)
        Config
      end

      provisioner(:tachyon) do
        require File.expand_path("../provisioner", __FILE__)
        Provisioner
      end
    end
  end
end
