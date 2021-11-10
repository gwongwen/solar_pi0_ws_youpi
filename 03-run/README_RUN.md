### On init application (after verifying that all scripts work well !)
We want the script on_init.sh to be runned on system init. To do so, there are multiple choices but, as we wanted to keep it simple and lightweight, we are going to change the /etc/rc.local file to execute our file at the begining. 

To do so we only have to add one line to the /etc/rc.local (need sudoers) before the exit 0:

```
sudo /bin/bash /home/pi/solar_pi0_ws_tutorial/03-src_project_v0/on_init.sh
```

### Application (receiver) make the raspi able to read messages sent by the server
As the downlink with lora is not a possibility, the lora node will retrieve the last message from an mqtt server that will be deployed on the Server that controlls the device. In this MQTT client, it will be configured to retain the last message until consumed.

- Sleep time reconfiguration: Time to the next time the board will turn herself on. Thiw will be used by the on_init script. The message will follow the structure: ***reconfig_sleep_time;15*** being the second parameter the time in seconds.

### Sensor controller service (on your server)
To begin, you need to install docker and mqtt with the scripts on **02-initial_configuration/serer** and the python dependencies. Then, the python service to run will be located in **03-src_project/server_side/controller_service.py**

### Gateway (receiver) 
To configure the raspberry as a gateway, you have to follow the instructions and install the requirements in **02-initial_configuration/raspberry/gateway**. Then, to run the service, execute the file in **03-src_project/raspi-side/gateway_mode/run_gateway_node.sh** 

### TO DO:
### improve the on_init script and, then, push it in bin/bash
### deactivate wifi and every ssh method(more lightweight) at the end and only connect when you want to access the mqtt to read more updates
