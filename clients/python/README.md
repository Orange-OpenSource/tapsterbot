# python folder

Here are elements defining a client written in Python which can drive the bot (i.e. send to it requests)

## List of files
- _client.py_ The Python-written client to use so as to drive the robot, i.e. the "main" program
- _config.py_ The file having the configuration to use with for examples regular expresions, API's URL, etc.
- _glue.py_ Some Python glue so as to give logic to client and make the link with the _robot_api.py_ file
- _robot_api.py_ The file which uses the HTTP API of the robot
- *commands_parser.py* The file providing methods to parse and check commands

## Usage
```shell
python client.py [-h] [--url ROBORSERVERURL] [--light COMMAND] [--file COMMANDSFILE] [--version]
```

## Samples of commands to give
- tap 100 100
- n-tap 42 100 100
- stress-tap 666 100 100
- reset
- swipe 300 300 100 100
- n-swipe 5 300 300 100 100
- stress-swipe 666 300 300 100 100
- set-position 20 20 -155

## How to use the client
1. Define the configuration of your Tapster2 robot in _config.py_ if needed
2. Then...

To run the Python client in interactive / verbose mode, use:
```shell
  python client.py --url your-robot-url
```
or using the config.py file
```shell
  python client.py
```

To run the Python client in light mode using only a command, use:
```shell
  python client.py --url your-robot-url --light the-command-to-process
```

To run the Python client with a file of commands to process, use:
```shell
  python client.py --url your-robot-url --file path-to-the-command-file
```

If you want to get the version of the Python client, use:
```shell
  python client.py --version
```

The URL you may use must match the pattern _protocol://ip:port_, e.g. _http://192.168.1.13:4242_

## Note
The default value for _--url_ parameter  is a combination of variables defined in _config.py_ like **http://127.0.0.1:4242**.
If you want to use this client, you have to have ['requests'](docs.python-requests.org/en/latest/ "Requests module") module installed.
To do so, you can run the following command or read this [topic](https://stackoverflow.com/questions/17309288/importerror-no-module-named-requests "Stack Overflox post"):
The installed version of _requests_ for this project is **2.18.4**

```shell
  sudo pip install requests
```
