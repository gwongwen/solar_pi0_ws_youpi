import urllib.request
import mqtt_client.mqtt_client
import os,sys,time,traceback,argparse

def connect_host(host='http://google.com'): # checks if there is internet access, if not it will not be able to reconfigure.
    try:
        urllib.request.urlopen(host)
        return True
    except Exception as err:
        return False

def on_message(client, userdata, message):
    received = str(message.payload.decode("utf-8"))
    print("-----> Message arrived : [" + message.topic + "] " + received)
    message_splitted = received.split(";")
    if(message_splitted[0]=="reconfig_sleep_time"):
        new_sleep_time = int(message_splitted[1])

if(connect_host()):
    try:
        mqtt_functions = mqtt_client("IP",int(1881),"sensor_node_1")
        client = mqtt_functions.client_connect(on_message)
        client = mqtt_functions.subscribe_topic(client,"config_sensor_node_1")
        client = mqtt_functions.start_loop(client)
    except Exception as err:
        print("Couldn't join mqtt server")
        print(sys.exc_info())
        log.critical()
        traceback.print_tb(err.__traceback__)

    time.sleep(10) # this will make the service be connected for 10 seconds then pass to the next instruction
else:
    print("Couldn't connect to internet.")