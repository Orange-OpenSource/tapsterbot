#!/usr/bin/env python3
# -*- coding: utf_8 -*-
# SPDX-FileCopyrightText: 2018 Orange SA
# SPDX-License-Identifier: BSD-2-Clause OR MIT

"""
File.......: client.py
Brief......: The Python client to use so as to drive the Tapster 2 bot
Version....: 2.0.1
Since......: 10/01/2018
"""

import argparse
import sys

import glue
from config import *
from commands_parser import *

if __name__ == "__main__":

    # Check args if this execution is a "light" execution, i.e. without verbatims
    parser = argparse.ArgumentParser(description='Python client for Tapster2 robot.')
    parser.add_argument('--url', dest='robotserverurl', help="The URL of the robot's server", required=False)
    parser.add_argument('--light', dest='command', help='Run in light mode, i.e. without verbatims nor prompts.', required=False)
    parser.add_argument('--file', dest='commandsfile', help='Load a file at this path containing a list of commands to process seperated by a line break.', required=False)
    parser.add_argument('--version', action='version', help='Displays the version of this program.', version='%(prog)s '+CLIENT_VERSION)
    args = parser.parse_args()

    if args.robotserverurl:
        config.ROBOT_URL = args.robotserverurl
    else:
        config.ROBOT_URL = DEFAULT_ROBOT_URL

# In this case we are in light mode

    if args.command:
        if not checkRobotConnection():
            sys.exit()
        command = args.command
        if isRobotCommand(command):
            parseCommand(command)
        elif glue.isHelpCommand(command):
            glue.help()
        elif glue.isConfigCommand(command):
            glue.config()
        else:
            print "ERROR: Bad command: '" + command + "'"
        sys.exit()

# In this case we are in commands file mode

    if args.commandsfile:
        if not checkRobotConnection():
            sys.exit()
        pathOfFile = args.commandsfile
        if glue.checkFile(pathOfFile):
            print "Will process file: '" + pathOfFile + "'"
            glue.processCommandsFile(pathOfFile)
        else:
            print "ERROR: File not found: '" + commandsFile + "'"
        sys.exit()

# In that case we are in verbose / interactive mode

    # Welcome guys!
    print "Version " + CLIENT_VERSION
    glue.welcome()

    checkRobotConnection()

    # Some help?
    glue.help()

    # Deal with commands
    stop = False
    lastCommand = None
    while not stop:
        command = glue.askForCommand()
        if glue.isRepeatCommand(command):
            command = lastCommand
        if isRobotCommand(command):
            parseCommand( command )
        elif glue.isHelpCommand(command):
            glue.help()
        elif glue.isConfigCommand(command):
            glue.config()
        elif glue.isStopCommand(command):
            stop = True
        else:
            print "Nope. Bad command: '" + command + "'"
        lastCommand = command
    # Bye!
    print "Ok, bye!"
