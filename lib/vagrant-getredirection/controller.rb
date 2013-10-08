require 'pp'

module VagrantGetredirection
  class Controller
    def initialize(app, env)
        @app = app
        @env = env
        @vboxcmd = determine_vboxcmd
    end

    def determine_vboxcmd
      if windows?
        # On Windows, we use the VBOX_INSTALL_PATH environmental
        if ENV.has_key?("VBOX_INSTALL_PATH")
          # The path usually ends with a \ but we make sure here
          path = File.join(ENV["VBOX_INSTALL_PATH"], "VBoxManage.exe")

          "\"#{path}\""
        end
      else
        # for other platforms assume it is on the PATH
        'VBoxManage'
      end
    end

    def windows?
      %W[mingw mswin].each do |text|
        return true if RbConfig::CONFIG["host_os"].downcase.include?(text)
      end
      false
    end

    def run(machine, redirects)
        instance_id = machine.id
        instance_name = machine.name
        redirects[instance_name] = {}

        result=command("#{@vboxcmd} showvminfo #{instance_id}")

        result.each do |line|
          data = /^NIC [0-9]+ Rule\([0-9]+\):\s*name\s*=\s*(?<name>.*?),.*?host port\s*=\s*(?<hostport>[0-9]+),.*?guest port\s*=\s*(?<guestport>[0-9]+)/.match(line)

          unless data == nil
            redirects[instance_name][data['guestport']] = data['hostport']
          end
        end
    end

    def command(command)
        output=nil
        IO.popen("#{command}") do |f|
          output = f.readlines
        end

        output
    end
  end
end
