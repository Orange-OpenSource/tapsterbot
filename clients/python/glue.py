# -*- coding: utf_8 -*-
# SPDX-FileCopyrightText: 2018 Orange SA
# SPDX-License-Identifier: BSD-2-Clause OR MIT

"""
File.......: glue.py
Brief......: File including all the Python glue to use for the client, except the API of the bot
Version....: 2.3.0
Since......: 10/01/2018
"""

# *******
# IMPORTS
# *******

# For robot connection check process
import requests

# To wait between each cascaded command
import time

# For files
import os.path

# For regular expressions and patterns
import config as clientConfig

# Commands parsing
from commands_parser import *


# *********
# FUNCTIONS
# *********

# Function: welcome()
def welcome():
        """
            Displays the welcome message.
        """
        print "*************************************"
        print "* Welcome to Tapster2 Python client *"
        print "*************************************"
        return
# End of Function: welcome()

# Function: help()
def help():
        """
            Displays the help, i.e. the commands the client can deal with.
        """
        print ""
        print "Here are the commands you can use for the Tapster2 bot:"
        print "\ttap x y.........................: Tap on (x,y) using the 2D landmark of the device"
        print "\tlong-tap x y d..................: Make a long tap on (x,y) with a duration of d (in ms) using the 2D landmark of the device"
        print "\tdouble-tap x y d................: Make a double tap on (x,y) with a duration of d (in ms) using the 2D landmark of the device"
        print "\ttriple-tap x y d................: Make a triple tap on (x,y) with a duration of d (in ms) using the 2D landmark of the device"        
        print "\tn-tap n x y.....................: Tap n times on (x,y) using the 2D landmark of the device"
        print "\tstress-tap n x y................: Make n taps on (x, y) with a dedicated duration between each swipe which can be short enough to stress the app"
        print "\tswipe x1 y1 x2 y2...............: Swipe from (x1, y1) to (x2, y2) using the 2D landmark of the device"
        print "\tn-swipe n x1 y1 x2 y2...........: Make n swipes from (x1, y1) to (x2, y2) using the 2D landmark of the device"
        print "\tstress-swipe n x1 y1 x2 y2......: Make n swipe from (x1, y1) to (x2, y2) with a dedicated duration between each swipe which can be short enough to stress the app"
        print "\treset...........................: Reset the position of the bot"
        print "\tget-angles......................: Get the angles of the arms of the bot"
        print "\tset-angles a b c................: Define the 3 angles (a = theta 1, b = theta 2, c = theta3) for the arms of the bot"
        print "\tget-position....................: Get the posiition of the arms in its 3D landmark"
        print "\tset-position x y z..............: Set the position of the bot in its 3D landmark at (x,y,z) coordinates"
        print "\tconfig..........................: Display the global configuration in use"
        print "\tstatus..........................: What is the status of the bot?"
        print "\tcheck...........................: Check if the robot's server is up"
        print "\trepeat..........................: Repeat the last executed command"
        print "\tdance...........................: Let's dance!"
        print "\tstop-dance......................: Stop dancing"
        print "\tget-calibration.................: Get the calibration data in use for the bot"
        print "\tset-calibration JSON............: Define the calibraiton data to use for the bot, defined in JSON format"
        print "\tcontact-z.......................: Get the Z-axis value of the contact point, i.e. the point where the device's screen should be touched"
        print "\tposForScreen x y................: Get the position of the bot for these (x,y) screen-based coordinates"
        print "\tangForPos x y z.................: Get the angles of the arms for the (x,y,z) 3D coordinates"
        print "\tsquare n length.................: Draw a square with a dedicated length, and draw each nth point"
        print "\tstar............................: Draw a star"
        print "\ttriangle x1 y1 x2 y2 x3 y3......: Draw a triangle using 3 points (x1, y1) (x2, y2) (x3, y3)"
        print "\tcircle x y r....................: Draw a circle centered on point (x,y) with r radius"
        print "\tcross x1, y1 x2 y2 x3 y3 x4 y4..: Draw a cross using 4 points, drawing two strokes, with strokes (x1, y1) -> (x4, y4) and (x2, y2) -> (x3, y3)"
        print "\tspiral x y n r..................: Draw a spiral centered on (x,y) using n rings with an r radius"
        print "\trandom n minW minH maxW mawH....: Draw a random pattern with (n-1) strokes in a defined area (points picked with [minW ; maxW] and [minH; maxH])"
        print "\thelp............................: Display this help"
        print "\tbye.............................: Good bye!"
        print ""
        return
# End of Function: welcome()

# Function: config()
def config():
    """
        Displays the configuration in use.
    """
    print ""
    print "\tVersion of Python client...............: " + CLIENT_VERSION
    print "\tRobot's server URL.....................: " + clientConfig.ROBOT_URL
    print "\tWait between tap (s)...................: " + str(WAIT_TIME_BETWEEN_TAP)
    print "\tWait between stress swipe (s)..........: " + str(WAIT_TIME_STRESS_SWIPE)
    print "\tWait between cascaded ops (s)..........: " + str(WAIT_BETWEEN_CASCADED_OPERATION)
    print "\tWait between stress tap (s)............: " + str(WAIT_TIME_STRESS_TAP)
    print "\tEscape symbol..........................: '" + ESCAPE_SYMBOL + "'"
    print "\tDefault IP address of the robot........: " + DEFAULT_ROBOT_IP_ADDRESS
    print "\tDefault port fo the robot..............: " + DEFAULT_ROBOT_PORT
    print "\tDefault protocol of the robot..........: " + DEFAULT_ROBOT_PROTOCOL
    print "\tDefault URl of the robot...............: " + DEFAULT_ROBOT_URL
    print ""
# End of Function: config()

# Function: checkFile( path )
def checkFile( path ):
    """
        Checks if the target at the end of the path is a file.
        Returns True if a file, False otherwise
    """
    return os.path.isfile(path)

# Ed of Function: checkFile( path )

# Function: processCommandsFile( path )
def processCommandsFile( path ):
    """
        Processes the file at this path, file containing commands separated by a line break.
        WIll parse each line as a command, except if the line starts with a #
    """

    # Parse the file
    with open(path) as file:
        lines = [line.strip() for line in file]

    # Remove empty lines
    lines = [line for line in lines if len(line) > 0]

    # Process each line
    lastCommand = None
    command = None
    for line in lines:

        # Check if commented command
        if line.startswith(ESCAPE_SYMBOL):
            print "Escaped command."
            continue
        # Repeat command, but check previously if there was a previous command
        if isRepeatCommand(line):
            if lastCommand == None:
                print "Nope. Did you want to repeat nothing?"
                continue
            command = lastCommand
        else:
            command = line
        # Command for robot
        if isRobotCommand(command):
            parseCommand(command)
        # Client-help command
        elif isHelpCommand(command):
            help()
        # Client-config command
        elif isConfigCommand(command):
            config()
        else:
            print "Nope. Bad command: " + command
            continue
        lastCommand = command
        time.sleep(WAIT_BETWEEN_CASCADED_OPERATION)

# End of Function: processCommandsFile( path )

# Function: askForCommand()
def askForCommand():
    """
        Asks for a command to the user.
        Returns the written command.
    """
    return raw_input("> Enter a command: ")
# End of Function: askForCommand()

# Function isStopCommand( command )
def isStopCommand( command ):
        """
            Checks if the command is a stop command.
            Returns a boolean value, true if the command is good, false otherwise.
        """
        return bool(ROBOT_PATTERN_BYE.match(command))
# End of Function isStopCommand( command )

# Function isHelpCommand( command )
def isHelpCommand( command ):
        """
            Checks if the command is an help command.
            Returns a boolean value, true if the command is good, false otherwise.
        """
        return bool(ROBOT_PATTERN_HELP.match(command))
# End of Function isHelpCommand( command )

# Function isConfigCommand( command )
def isConfigCommand( command ):
        """
            Checks if the command is a config command.
            Returns a boolean value, true if the command is good, false otherwise.
        """
        return bool(ROBOT_PATTERN_CONFIG.match(command))
# End of Function isConfigCommand( command )

# Function isRepeatCommand( command )
def isRepeatCommand( command ):
        """
            Checks if the command is a repeat command.
            Returns a boolean value, true if the command is good, false otherwise.
        """
        return bool(ROBOT_PATTERN_REPEAT.match(command))
# End of Function isRepeatCommand( command )
