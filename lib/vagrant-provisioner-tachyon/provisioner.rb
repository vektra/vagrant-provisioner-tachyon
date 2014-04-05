module VagrantPlugins
  module Tachyon
    class Provisioner < Vagrant.plugin("2", :provisioner)
      def configure(root_config)
        # Calculate the paths we're going to use based on the environment
        root_path = @machine.env.root_path
        @expanded_path = @config.expanded_path(root_path)


        # Setup the module paths
        @module_paths = []
        @module_paths << [@expanded_path, config.playbook_path]

        folder_opts = {}
        folder_opts[:type] = @config.synced_folder_type if @config.synced_folder_type
        folder_opts[:owner] = "root" if !@config.synced_folder_type

        # Share the module paths
        @module_paths.each do |from, to|
          root_config.vm.synced_folder(from, to, folder_opts)
        end
      end

      def verify_shared_folders(folders)
        folders.each do |folder|
          if !@machine.communicate.test("test -d #{folder}", sudo: true)
            raise PuppetError, :missing_shared_folders
          end
        end
      end

      def provision
        # Check that the shared folders are properly shared
        check = []
        @module_paths.each do |host_path, guest_path|
          check << guest_path
        end

        # Make sure the temporary directory is properly set up
        @machine.communicate.sudo("mkdir -p #{config.playbook_path}; chmod 0777 #{config.playbook_path}")

        verify_shared_folders(check)

        @machine.ui.detail "Installing tachyon..."

        # Setup tachyon
        @machine.communicate.tap do |comm|
          comm.sudo("test -e .tachyon/tachyon || (mkdir -p .tachyon && cd .tachyon && curl -s https://s3-us-west-2.amazonaws.com/tachyon.vektra.io/install.sh | bash)")
        end

        @machine.ui.detail "Running tachyon..."

        # Run tachyon
        cmd = ".tachyon/tachyon #{@module_paths.first.last}/#{config.site_file}"
        @machine.communicate.sudo(cmd) do |type, data|
          # Output the data with the proper color based on the stream.
          color = type == :stdout ? :green : :red
          @machine.env.ui.info(
            data, :color => color, :new_line => false, :prefix => false)
        end
      end
    end
  end
end
