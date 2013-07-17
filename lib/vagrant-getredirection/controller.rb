require 'pp'

module VagrantGetredirection 

  class Controller

    def initialize(app, env)
        @app = app
        @env = env
        @vboxcmd=determine_vboxcmd
    end

    def determine_vboxcmd
      if windows?
        # On Windows, we use the VBOX_INSTALL_PATH environmental
        if ENV.has_key?("VBOX_INSTALL_PATH")
          # The path usually ends with a \ but we make sure here
          path = File.join(ENV["VBOX_INSTALL_PATH"], "VBoxManage.exe")
          return "\"#{path}\""
        end
      else
        # for other platforms assume it is on the PATH
        return "VBoxManage"
      end
    end

    def windows?
      %W[mingw mswin].each do |text|
        return true if RbConfig::CONFIG["host_os"].downcase.include?(text)
      end
      false
    end

    def run(machine)
        instance_id = machine.id
        instance_name = machine.name
        result=command("#{@vboxcmd} showvminfo #{instance_id} |grep \"^NIC [0-9] Rule\" | sed 's/^.*host port = \\([0-9]*\\).*guest port = \\([0-9]*\\)/\\1 => \\2/g' ")
        puts "[#{instance_name}] - Redirect : "
        puts "#{result}"
    end

    def command(command,options = {})
        output=nil
        result=IO.popen("#{command}") {|f| output=f.readlines}
        return output
    end

    def is_vm_created?(machine)
        return !machine.id.nil?
    end

  end
end
