# vagrant-getredirection

Provides information on forwarded port configuration: this tool displays guest/host ports in multi-VM mode when VMs are running. Avoid to search in terminal VM startup trace / avoid to open VBox to find the forwarded ports.

Prerequisite:
===================


* Vagrant version >= 1.2.2
* 
```shell
gem install bundler
```

Installation
===================

Full installation

```shell
bin/install.sh
```

Or manual build:

```shell
$ gem install bundler
$ rake -T --trace
$ rake build --trace
$ vagrant plugin uninstall vagrant-getredirection
$ vagrant plugin install pkg/vagrant-getredirection*.gem
$ vagrant plugin list
```

Official HOWTO: http://docs.vagrantup.com/v2/plugins/packaging.html

Usage
===================
```shell
$ vagrant up
$ vagrant redirection
[default] - Redirect : 
2242 => 42000
2280 => 80
2281 => 81
2254 => 5432
2288 => 8888
2222 => 22
```

Uninstallation
===================

```shell
$ vagrant plugin uninstall vagrant-getredirection
```

Test ..
===================

```shell
$ cd test
$ vagrant up test1
$ vagrant redirection
$ vagrant up test2
$ vagrant redirection
```
