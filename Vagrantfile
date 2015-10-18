# -*- mode: ruby -*-
# vi: set ft=ruby :
# Source : https://github.com/commercialhaskell/stack/blob/master/etc/vagrant/centos-7-x86_64/Vagrantfile
Vagrant.configure(2) do |config|
  config.vm.box = "bento/centos-7.1"
  config.vm.synced_folder "D:/Apps/.vagrant.d", "/host/.vagrant.d"
  config.vm.synced_folder "D:/Apps/.docker", "/host/.docker"
  config.vm.synced_folder ".", "/host/project"
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "2048"
  end
  config.vm.provision "shell", run: "always", inline: <<-SHELL
    set -xe
    export PATH=/usr/local/bin:$PATH
    yum -y update
    yum -y install epel-release
    yum -y install perl make automake gcc gmp-devel zlib-devel tar which git python-boto deltarpm python-deltarpm rpm-build rpm-sign ncurses-devel
    if ! [[ -f /usr/local/bin/stack ]]; then
      curl -sSL https://s3.amazonaws.com/download.fpcomplete.com/centos/7/fpco.repo >/etc/yum.repos.d/fpco.repo
      yum -y install stack
    fi
    if ! which docker; then
      cat >/etc/yum.repos.d/docker.repo <<-EOF
[dockerrepo]
name=Docker Repository
baseurl=https://yum.dockerproject.org/repo/main/centos/7
enabled=1
gpgcheck=1
gpgkey=https://yum.dockerproject.org/gpg
EOF
      yum -y install docker-engine
      usermod -aG docker vagrant
    fi
    if ! which cabal; then
      pushd /host/project
      stack --install-ghc install cabal-install
      cp `stack exec which cabal` /usr/local/bin/cabal
      popd
    fi
    if ! which fpm; then
        yum -y install ruby-devel
        gem install fpm --version '< 1.4.0'
    fi
    if ! [[ -d /opt/rpm-s3 ]]; then
      mkdir -p /opt
      git clone https://github.com/crohr/rpm-s3 /opt/rpm-s3
      (cd /opt/rpm-s3; git submodule update --init)
      echo 'export PATH="/opt/rpm-s3/bin:$PATH"' >/etc/profile.d/rpm-s3.sh
    fi
  SHELL
end
