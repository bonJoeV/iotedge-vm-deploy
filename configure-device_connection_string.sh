#! /bin/bash

#wait for the /etc/iotedge/config.yaml to be written
while [ ! -f /etc/iotedge/config.yaml ]
do
  sleep 10
done
# File written, lets sleep a little longer to ensure no lock
sleep 10
# inject the connection string passed by variable dcs
sudo sed -i "s#\(device_connection_string: \).*#\1\"$dcs\"#g" /etc/iotedge/config.yaml
echo $dcs >/etc/iotedge/config.done.txt
sudo systemctl restart iotedge
