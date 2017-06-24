import time
import json
import paho.mqtt.client as mqtt
from song import AudioHandler
from node_net import NodeNet, Node

def handle_node_connect(client, userdata, msg):
    """
    Ex:
        {
            number: 1,
            name: "classroom"
        }
    """
    print "Handle node connect..."

    data = json.loads(msg.payload)
    node = node_net.add_node(data["number"], data["name"])
    print "Added " + str(node)


def handle_node_sensor(client, userdata, msg):
    print("Handle node sensor...")

topics_subscribed = {
    "node/connect": handle_node_connect,
    "node/sensor": handle_node_sensor,
}

def on_connect(client, userdata, flags, rc):
    print "Connected with result code "+str(rc)

    client.subscribe("song/info")
    client.subscribe("song/stream")

    client.subscribe("node/connect")
    client.subscribe("node/sensor")
    client.subscribe("node/neighbours")
    

def on_message(client, userdata, msg):
    # print("Topic: " + msg.topic)
    # print(str(msg.payload))

    try:
        callback = topics_subscribed[msg.topic]
        callback(client, userdata, msg)
        
    except KeyError:
        pass


hostname = "localhost"
port = 1883
keep_alive = 60

client = mqtt.Client()
client.on_connect = on_connect
client.on_message = on_message

client.connect(hostname, port, keep_alive)
client.loop_start()

node_net = NodeNet()

song = {
    "name": "jump_8k", 
    "path": "songs/jump_8k.u8",
}
audio = AudioHandler(song["path"])

while True:
       
    client.publish("song/info", json.dumps(song))

    for chunk in audio.get_chunks():
        client.publish("song/stream", chunk)

        time.sleep(2)

    print "Restart song"

