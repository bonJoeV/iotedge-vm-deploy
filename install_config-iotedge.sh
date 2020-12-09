#! /bin/bash
#prepares all the things...
echo "here " $dcs
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
sudo apt install -y docker-ce
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add
curl -s -L https://nvidia.github.io/nvidia-docker/ubuntu18.04/nvidia-docker.list -o nvidia-docker.list
cp nvidia-docker.list /etc/apt/sources.list.d/nvidia-docker.list
apt update
apt install -y nvidia-docker2
pkill -SIGHUP dockerd
wget http://developer.download.nvidia.com/compute/cuda/10.2/Prod/local_installers/cuda_10.2.89_440.33.01_linux.run
sh cuda_10.2.89_440.33.01_linux.run --silent --driver --toolkit --samples
echo "here" $dcs
# Wait for docker daemon to start
while [ $(ps -ef | grep -v grep | grep docker | wc -l) -le 0 ]; do 
  sleep 3
done
# Prevent iotedge from starting before the device connection string is set in config.yaml
sudo ln -s /dev/null /etc/systemd/system/iotedge.service
sudo apt install iotedge -y

while [ ! -f /etc/iotedge/config.yaml ]
do
  sleep 10
done
sleep 10
sudo sed -i "s#\(device_connection_string: \).*#\1\"$dcs\"#g" /etc/iotedge/config.yaml
systemctl unmask iotedge
systemctl start iotedge
sudo docker run --runtime=nvidia --rm nvidia/cuda:11.0-base nvidia-smi
