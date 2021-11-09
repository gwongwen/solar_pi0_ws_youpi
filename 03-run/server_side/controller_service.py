import time
import ttn

app_id = "solar-pi0-ws-app"
access_key = "ttn-account-v2.CH-ETSz4qqD5BFz5xT_EytCk-Su1SvdBALzIfo4ljkc"

#to send the reconfiguration message, to see where we do it
def send_reconfiguration_message(seconds_until_next_meassure):
  try:
    message = "reconfig_sleep_time;" + str(seconds_until_next_meassure)
    publish.single("config_sensor_node_1",message,retain=True,hostname="192.168.0.145",port=1881)
  except Exception as err:
    print("Couldn't send the message to " + "192.168.0.145" + ":" + str(1881))    
    print(sys.exc_info())
    traceback.print_tb(err.__traceback__)

def uplink_callback(msg, client):
  print("Received uplink from ", msg.dev_id)
  print(msg)

handler = ttn.HandlerClient(app_id, access_key)

# using mqtt client
mqtt_client = handler.data()
mqtt_client.set_uplink_callback(uplink_callback)
mqtt_client.connect()
time.sleep(60)
mqtt_client.close()

