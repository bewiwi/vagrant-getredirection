require 'optparse'

module VagrantGetredirection
  class Command < Vagrant.plugin("2", :command)
    def execute

      options = {}

        opts = OptionParser.new do |opts|
          opts.banner = "Usage: vagrant redirection <vm-name>"
          opts.separator ""

        end

        # Parse the options
        argv = parse_options(opts)
        return if !argv

        contr = VagrantGetredirection::Controller.new(@app, @env)
      
        with_target_vms(argv, :reverse => true) do |machine|
            contr.run(machine)
        end
    end

  end
end
