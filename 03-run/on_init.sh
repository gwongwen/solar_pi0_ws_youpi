#!/bin/bash
#
# Shell script designed to take 3 measures within 1'30
# using a BME680 sensor.
#
# The Solar Pi Platter wakes the Pi up every 15 minutes during the day and allows
# the RFM95W LoRa module the, taking 3 meauses, storing the result in a file
# and sending to LoRa gateway server.
#
# The script is designed to be run by /etc/rc.local when the Pi boots.  It looks at
# the power-up reason and does not execute if the Pi was powered on because the user
# powered up using the Solar Pi Platter button.
#

echo beginning of script

# test of the transmission
cd /home/pi/solar_pi0_ws_tutorial/01-hardware/tests/
sudo python3 test_send_lora.py

# times to start and stop each date are military format: HHMM
STARTOFDAY=0800
ENDOFDAY=2000

# time (in seconds) between two measures
TIMELAPSE=1800		# 30 mins

# time (in seconds) between two battery test
TIMELOWBATT=600		# 10 mins

# get the date from the RTC
MYDATE=$(talkpp -t)
MYHHMM=${MYDATE:4:4}

echo "setup date from RTC"
# set our date from the RTC
date $MYDATE

# get the power-up reason from the board (along with other status)
STATUS=$(talkpp -c S)

# bail out of the script if we powered on because the user manually turned us on
if [ $STATUS -ge 16 ]; then
	# STATUS includes a power-up reason of "Button"
	exit
fi

echo "setup wakeup and alarm"
# set our next wakeup time
if [ $MYHHMM -gt $ENDOFDAY ]; then
	# getting dark: Set an alarm for tomorrow morning
	talkpp -a $(date --date=tomorrow +%m%d$STARTOFDAY%Y.00)
else
	# set an alarm for 30 minutes from now
	talkpp -d $TIMELAPSE
fi

echo "alarm ON"
# enable the alarm
talkpp -c C0=1

echo "battery test"
# read battery voltage
BATT=$(talkpp -c B)

if [ $BATT -lt 3.45 ]; then
    talkpp -d $TIMELOWBATT  # set to restart Pi Platter in 10 mins
    talkpp -c O=15  		# turn off Pi Platter in 30 seconds
else
    echo "run python script to read sensor and send data to TTN"
    # initialisation of our raspberry pi zero
	cd /home/pi/solar_pi0_ws_youpi/03-run/raspi_side/gateway_mode
	bash run_gateway_node.js
	cd ..
	# run measurement program and enable mqtt server
	cd /home/pi/solar_pi0_ws_youpi/03-run/raspi_side/sensor_mode
	sudo mqtt_client.py
    sudo python pi_pp_bmp388.py
fi

echo "shutdown Pi Platter board"
# and finally shutdown and then power off
talkpp -c O=15
shutdown now