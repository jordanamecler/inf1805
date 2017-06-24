# Museum Audio Streamer

## Requirements

- NodeMCU ESP8266
- Speakers
- PIR sensors

## Install
- On MacOSX:
```
$ brew install mosquitto

$ pip install -r requirements.txt
```

## Running

- Call the follow on your shell to start the Mosquitto broker on localhost:
```
$ mosquitto
```

- Run ```server.py``` to start the application
```
$ python server.py
```

## Example

- With both the mosquitto broker and the ```server.py``` running, call these commands on different terminal windows:
```
$ mosquitto_pub -d -t node/connect -m '{ "number": 1, "name": "classroom" }'

$ mosquitto_sub -d -t song/info

$ mosquitto_sub -d -t song/stream
```

You should see the results being printed on the ```server.py``` window and on the subscribers window.

## Topics

- ```song/info```:

Returns information about the song that is playing.

- ```song/stream```

Returns chunks of data of the song that is being streamed.

- ```node/connect```

Adds a node to the node network

- ```node/sensor```

Nodes publish their sensor data to this topic.

- ```node/neighbours```

The server returns each node's neighbours.


