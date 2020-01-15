#! /bin/bash

# Create users and config directories
function setup_app () {
  local daemon=$1
  [ -z "$2" ] && local directory=$1 || local directory=$2

  useradd -r $daemon
  mkdir /config/$directory
  chown $daemon:$daemon /config/$directory
}

# Common
mkdir /config
apt-get update
apt-get install curl net-tools software-properties-common -y

# OpenVPN
apt-get install openvpn -y

# UFW
apt-get install ufw -y

# Deluge
add-apt-repository ppa:deluge-team/ppa -y
apt-get install deluged deluge-web -y
setup_app deluge

# Mono
apt-get install gnupg ca-certificates
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
echo "deb https://download.mono-project.com/repo/ubuntu stable-bionic main" | tee /etc/apt/sources.list.d/mono-official-stable.list
apt-get update
apt-get install mono-runtime -y

# Sonarr
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 0xA236C58F409091A18ACA53CBEBFF6B99D9B78493
echo "deb http://apt.sonarr.tv/ master main" | tee /etc/apt/sources.list.d/sonarr.list
apt-get update
apt-get install nzbdrone -y
setup_app sonarr
chown -R sonarr:sonarr /opt/NzbDrone

# Radarr 
curl -L -O $( curl -s https://api.github.com/repos/Radarr/Radarr/releases | grep linux.tar.gz | grep browser_download_url | head -1 | cut -d \" -f 4 )
tar -xvzf Radarr.develop.*.linux.tar.gz
mv Radarr /opt
setup_app radarr
chown -R radarr:radarr /opt/Radarr

# Jackett
curl -L -O $( curl -s https://api.github.com/repos/Jackett/Jackett/releases | grep LinuxAMDx64.tar.gz | grep browser_download_url | head -1 | cut -d \" -f 4 )
tar -zxvf Jackett.*.tar.gz
mv Jackett /opt
setup_app jackett Jackett
chown -R jackett:jackett /opt/Jackett

# Copy install scripts and enable services
rsync -a ./etc/ /etc/
_SERVICES=( deluged deluge-web radarr sonarr jackett )
for _SERVICE in "${_SERVICES[@]}"
do
  systemctl enable $_SERVICE.service
  systemctl start $_SERVICE.service
done
