import time
import paho.mqtt.client as mqtt
from song import AudioHandler


def on_connect(client, userdata, flags, rc):
    print("Connected with result code "+str(rc))

    client.subscribe("song")

def on_message(client, userdata, msg):
    print(msg.topic+" "+str(msg.payload))


hostname = "localhost"
port = 1883
keep_alive = 60

client = mqtt.Client()
client.on_connect = on_connect
client.on_message = on_message

client.connect(hostname, port, keep_alive)
client.loop_start()


while True:

    audio = AudioHandler("songs/jump_8k.u8")

    for chunk in audio.get_chunks():
        client.publish("song", chunk)

        time.sleep(1)

    client.loop_stop()
    break

