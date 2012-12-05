class DisplayRedirection < Vagrant::Command::Base
  def execute
    @vagrant_env=Vagrant::Environment.new
    options = {}
    opts = OptionParser.new do |opts|
        opts.banner = "Enters sandbox state"
        opts.separator ""
        opts.separator "Usage: vagrant sandbox on <vmname>"
    end
    argv = parse_options(opts)
    return if !argv
    boxs=argv[0]
    get_redirection(boxs)
  end
  
  def command(command,options = {})
      STDOUT.sync = true
      output=nil
      result=IO.popen("#{command}") {|f| output=f.readlines}
      return output
    end

  def get_redirection(selection)
     on_selected_vms(selection) do |boxname|
        instance_uuid="#{@vagrant_env.vms[boxname.to_sym].uuid}"
        results=command("VBoxManage showvminfo #{instance_uuid} |grep \"^NIC [0-9] Rule\" | sed 's/^.*host port = \\([0-9]*\\).*guest port = \\([0-9]*\\)/\\1 => \\2/g' ")
        puts "[#{boxname}] - Redirect : "
     	results.each { |result| puts "#{result}" }
     end

  end

    def is_vm_created?(boxname)
      if @vagrant_env.vms[boxname.to_sym].nil?
        puts "[#{boxname}] - Box name doesn't exist in the Vagrantfile"
        return false
      else
        return !@vagrant_env.vms[boxname.to_sym].uuid.nil?
      end
    end
    
  def on_selected_vms(selection,&block)
        if selection.nil?
          @vagrant_env.vms.each do |name,vm|
            if @vagrant_env.multivm?
              if name.to_s!="default"
                if is_vm_created?(name)
                  yield name
                else
                  puts "[#{name}] - machine not created"
                end
              end
            else
              if is_vm_created?(name)
                yield name
              else
                puts "[#{name}] - machine not created"
              end
            end
          end
        else
          if is_vm_created?(selection)
            yield selection
          else
            puts "[#{selection}] - machine not created"
          end
        end
      end
  end

Vagrant.commands.register(:redirection) { DisplayRedirection }
