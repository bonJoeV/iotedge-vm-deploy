#! /bin/bash

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
sudo systemctl unmask iotedge
sudo systemctl restart iotedge
sudo docker run --runtime=nvidia --rm nvidia/cuda:11.0-base nvidia-smi
