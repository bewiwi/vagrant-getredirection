require 'optparse'
require 'json'

module VagrantGetredirection
  class Command < Vagrant.plugin("2", :command)
    def execute
      options = {}

      opts = OptionParser.new do |opts|
        opts.banner = 'Usage: vagrant redirection <name> [--json] [--port]'
        opts.separator ''

        opts.on('-j', '--json', 'Output redirections as JSON') do |j|
          options['json'] = j
        end

        opts.on('-p', '--port port', 'Output redirection for selected guest port') do |p|
          options['port'] = p
        end
      end

      # Parse the options
      argv = parse_options(opts)
      return if !argv

      contr = VagrantGetredirection::Controller.new(@app, @env)
      redirects = {}

      with_target_vms(argv, :reverse => true) do |machine|
          contr.run(machine, redirects)
      end

      if options['port']

        redirects.each_value do |rules|
          rules.each_key do |guest|
            unless guest == options['port']
              rules.delete(guest)
            end
          end
        end
      end

      if options['json']
        @env.ui.info(JSON.pretty_generate(redirects))
      else
        redirects.each_pair do |machine, rules|
          if redirects.count > 1
            @env.ui.info("[#{machine}] - Redirect :")
          end

          rules.each_pair do |guest, host|
            if options['port']
              @env.ui.info("#{host}")
            else
              @env.ui.info("#{host} => #{guest}")
            end
          end
        end
      end
    end
  end
end
