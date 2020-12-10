if [ -f /etc/iotedge/config.yaml ];
then
   sleep 10
   # inject the connection string passed by variable dcs
   sudo sed -i "s#\(device_connection_string: \).*#\1\"$dcs\"#g" /etc/iotedge/config.yaml
   sudo systemctl restart iotedge
   rm -f /etc/cron.d/configure-device_connection_string
   unset dcs
   rm -- "$0"
else
   exit 0
fi
