#!/usr/bin/env sh

ROOT=$(dirname $0)
ROOT="$ROOT/../"

exit_code=0

cd $ROOT
rake -T --trace || exit_code=1
rake build --trace || exit_code=1
vagrant plugin uninstall vagrant-getredirection || true
vagrant plugin install pkg/vagrant-getredirection-0.3.gem || exit_code=1
vagrant plugin list

exit $exit_code
cd -
