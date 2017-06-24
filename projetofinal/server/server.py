import time
import json
import paho.mqtt.client as mqtt
from flask import Flask, render_template, redirect, url_for
from song import AudioHandler
from node_net import NodeNet, Node


app = Flask(__name__)

################################
#         Web views
################################

@app.route('/')
def index():
    return render_template('home.html')

@app.route('/stream')
def start():
    return render_template('streaming.html')

@app.route('/stop')
def stop():
    return redirect(url_for('index'))


################################
#         Mqtt handlers
################################
    
def handle_node_connect(client, userdata, msg):
    print "Handle node connect..."

    data = json.loads(msg.payload)
    node = node_net.add_node(data["number"], data["name"])
    print "Added " + str(node)

def handle_node_sensor(client, userdata, msg):
    print("Handle node sensor...")
    


def on_message(client, userdata, msg):
    topics_subscribed = {
        "node/connect": handle_node_connect,
        "node/sensor": handle_node_sensor,
    }

    try:
        callback = topics_subscribed[msg.topic]
        callback(client, userdata, msg)
    except KeyError:
        pass

def on_connect(client, userdata, flags, rc):
    client.subscribe('node/connect')
    client.subscribe('node/sensor')
    client.subscribe('node/neighbours')
    client.subscribe('song/info')
    client.subscribe('song/stream')


def main():

    song = {
        "name": "jump_8k", 
        "path": "songs/jump_8k.u8",
    }
    audio = AudioHandler(song["path"])

    while True:
           
        mqtt.publish("song/info", json.dumps(song))

        for chunk in audio.get_chunks():
            mqtt.publish("song/stream", chunk)

            time.sleep(2)

        print "Restart song"


if __name__ == '__main__':

    hostname = '127.0.0.1'
    port = 1883
    keep_alive = 60

    node_net = NodeNet()

    # Start web server with mqtt

    client = mqtt.Client()
    #client.username_pw_set(username, password)
    client.on_connect = on_connect
    client.on_message = on_message
    client.connect(hostname, port, keep_alive)
    client.loop_start()

    app.run(host='127.0.0.1', port=8000, debug=True)
