# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.


# https://docs.docker.com/engine/install/ubuntu
$ubuntu_docker_script = <<-SCRIPT

#Uninstall old versions
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove $pkg; done

#Set up the repository
#Update the apt package index and install packages to allow apt to use a repository over HTTPS
apt-get update -y
apt-get install ca-certificates curl gnupg -y 

#Add Docker’s official GPG key
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

#Use the following command to set up the repository
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
tee /etc/apt/sources.list.d/docker.list > /dev/null

#Install Docker Engine, containerd, and Docker Compose
sudo apt-get update -y
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

#Verify that the Docker Engine installation is successful by running the hello-world image.
sudo docker run hello-world

#https://docs.docker.com/engine/install/linux-postinstall/
#Linux post-installation steps for Docker Engine

# Check if the docker group exists
if grep -q docker /etc/group; then

  # Print that the docker group exists
  echo "The docker group exists."

else

  # Create the docker group
  sudo groupadd docker

  # Print that the docker group is created
  echo "The docker group is created."

fi

#Add your user to the docker group.

# Check if the vagrant user exists
if grep -q vagrant /etc/passwd; then

  # Print that the vagrant user exists
  echo "The vagrant user exists."
  
  # Add the vagrant user to the docker group
  usermod -aG docker vagrant

  # Print that the vagrant user is added to the docker group
  echo "The vagrant user is added to the docker group.

else

  # Create the vagrant user
  useradd vagrant

  # Print that the vagrant user is created
  echo "The vagrant user is created."

  # Add the vagrant user to the docker group
  usermod -aG docker vagrant

  # Print that the vagrant user is added to the docker group
  echo "The vagrant user is added to the docker group.

fi


#Configure Docker to start on boot with systemd
systemctl enable docker.service
systemctl enable containerd.service

# Check if docker is enabled to start on boot
status=$(systemctl is-enabled docker)

# Print the status of docker
echo "Docker is configured to start on boot: $status"

SCRIPT



Vagrant.configure("2") do |config|

  config.vm.provider "virtualbox" do |vb|
    # vb.gui = false
    vb.memory = "1024"
    vb.cpus = 2
    # vb.customize ["modifyvm", :id, "--groups", "/kali-sandbox"] # create vbox group
  end


    config.vm.define "vg-nuclei-01" do |kalicluster|
      # https://app.vagrantup.com/ubuntu/boxes/lunar64
      kalicluster.vm.box = "ubuntu/lunar64" #23.04
      # https://app.vagrantup.com/ubuntu/boxes/jammy64
      # kalicluster.vm.box = "ubuntu/jammy64" #22.04 OK
      # https://app.vagrantup.com/ubuntu/boxes/hirsute64
      # kalicluster.vm.box = "ubuntu/hirsute64" #21.04
      # https://app.vagrantup.com/ubuntu/boxes/focal64
      # kalicluster.vm.box = "ubuntu/focal64" #20.04
      # ssl inspection by corporate firewall
      kalicluster.vm.box_download_insecure = true      
      # https://app.vagrantup.com/ubuntu/boxes/impish64
      # kalicluster.vm.box = "ubuntu/impish64" #21.10
      # https://app.vagrantup.com/ubuntu/boxes/xenial64
      # kalicluster.vm.box = "ubuntu/xenial64" #16.04
      kalicluster.vm.hostname = "vg-nuclei-01"
      #bridged network,DHCP disabled, manual IP assignment
      # kalicluster.vm.network "public_network", ip: "10.35.8.67"
      #bridged network,DHCP enabled,auto IP assignment
      kalicluster.vm.network "public_network"
      # kalicluster.vm.network "private_network", ip: "192.168.50.6"
      # kalicluster.vm.network "forwarded_port", guest: 80, host: 81
      #Disabling the default /vagrant share can be done as follows:
      # kalicluster.vm.synced_folder ".", "/vagrant", disabled: true
      kalicluster.vm.provider "virtualbox" do |vb|
          vb.name = "vbox-nuclei-01"
          vb.memory = "1096"
          vb.gui = false
      end
      # kalicluster.vm.provision "shell",    inline: "hostnamectl set-hostname vg-kali-05"
      kalicluster.vm.provision "shell", inline: $ubuntu_docker_script
      kalicluster.vm.provision :shell, path: "provisioning/nuclei.sh"
      kalicluster.vm.provision :shell, path: "provisioning/bootstrap.sh"

    end


end
