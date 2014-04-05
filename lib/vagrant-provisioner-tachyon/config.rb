module VagrantPlugins
  module Tachyon
    class Config < Vagrant.plugin("2", :config)
      attr_accessor :tachyon_path
      attr_accessor :playbook_path
      attr_accessor :site_file

      def initialize
        @tachyon_path = UNSET_VALUE
        @playbook_path = UNSET_VALUE
        @site_file = UNSET_VALUE
      end

      def finalize!
        @tachyon_path = "tachyon" if @tachyon_path == UNSET_VALUE
        @playbook_path = "/var/lib/tachyon/playbook" if @playbook_path == UNSET_VALUE
        @site_file = "site.yml" if @site_file == UNSET_VALUE
      end

      # Returns the module paths as an array of paths expanded relative to the
      # root path.
      def expanded_path(root_path)
        Pathname.new(tachyon_path).expand_path(root_path)
      end

      def validate(env)
        {"tachyon provisioner" => []}
      end
    end
  end
end
