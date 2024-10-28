# -*- coding: utf_8 -*-
# SPDX-FileCopyrightText: 2018 Orange SA
# SPDX-License-Identifier: BSD-2-Clause OR MIT

"""
File.......: config.py
Brief......: File including configuration to use and to apply on the client
Version....: 1.3.0
Since......: 10/01/2018
"""

import re

# Version of this Tapster2 Python client
CLIENT_VERSION = "v3.0.0"

# ************
# Robot things
# ************

# Default IP address where the Tapster2 bot is reachable
DEFAULT_ROBOT_IP_ADDRESS = "127.0.0.1"

# Default port to use to as to reach the robot
DEFAULT_ROBOT_PORT = "4242"

# Default protocol to use for the robot
DEFAULT_ROBOT_PROTOCOL = "http"

# Default URL to use to as to reach the robot
DEFAULT_ROBOT_URL = DEFAULT_ROBOT_PROTOCOL + "://" + DEFAULT_ROBOT_IP_ADDRESS + ":" + DEFAULT_ROBOT_PORT

# The URL of the robot's server which will be used / may be overriden by the user
ROBOT_URL = DEFAULT_ROBOT_URL

# Delay in seconds between each tap
WAIT_TIME_BETWEEN_TAP = 0.5

# Delay in seconds between each swipe
WAIT_TIME_BETWEEN_SWIPE = 0.5

# Delay in seconds between each swipe during stress swipes process
WAIT_TIME_STRESS_SWIPE = 0.33

# Delay in seconds between each tap during stress taps process
WAIT_TIME_STRESS_TAP = 0.25

# Deal in seconds between each operation picked and triggered from a commands file
WAIT_BETWEEN_CASCADED_OPERATION = 2

# The escape symbol to commnt a command store din the commands files
ESCAPE_SYMBOL = "#"

# ****************
# URL of Robot API
# ****************

ROBOT_URL_GET_ANGLES = "/angles"
ROBOT_URL_SET_ANGLES = "/setAngles"
ROBOT_URL_GET_POSITION = "/position"
ROBOT_URL_SET_POSITION = "/setPosition"
ROBOT_URL_TAP = "/tap"
ROBOT_URL_LONG_TAP = "/longTap"
ROBOT_URL_DOUBLE_TAP = "/doubleTap"
ROBOT_URL_TRIPLE_TAP = "/tripleTap"
ROBOT_URL_RESET = "/reset"
ROBOT_URL_GET_CALIBRATION = "/calibrationData"
ROBOT_URL_SET_CALIBRATION = "/setCalibrationData"
ROBOT_URL_STATUS = "/status"
ROBOT_URL_DANCE = "/dance"
ROBOT_URL_STOP_DANCE = "/stopDancing"
ROBOT_URL_SWIPE = "/swipe"
ROBOT_URL_POSITION_FOR_SCREEN_COORD = "/positionForScreenCoordinates"
ROBOT_URL_ANGLES_FOR_POSITION = "/anglesForPosition"
ROBOT_URL_CONTACT_Z = "/contactZ"
ROBOT_URL_DRAW_SQUARE = "/drawSquare"
ROBOT_URL_DRAW_STAR = "/drawStar"
ROBOT_URL_DRAW_TRIANGLE = "/drawTriangle"
ROBOT_URL_DRAW_CIRCLE = "/drawCircle"
ROBOT_URL_DRAW_CROSS = "/drawCross"
ROBOT_URL_DRAW_SPIRAL = "/drawSpiral"
ROBOT_URL_DRAW_RANDOM = "/drawRandomPattern"

# ********************************
# Regular expressions for commands
# ********************************

ROBOT_PATTERN_GET_ANGLES = re.compile("^get-angles$")
ROBOT_PATTERN_SET_ANGLES = re.compile("^set-angles (-*\d+(\.\d+)?) (-*\d+(\.\d+)?) (-*\d+(\.\d+)?)$")
ROBOT_PATTERN_GET_POSITION = re.compile("^get-position$")
ROBOT_PATTERN_SET_POSITION = re.compile("^set-position (-*\d+(\.\d+)?) (-*\d+(\.\d+)?) (-*\d+(\.\d+)?)$")
ROBOT_PATTERN_TAP = re.compile("^tap (\d+) (\d+)$")
ROBOT_PATTERN_LONG_TAP = re.compile("^long-tap (\d+) (\d+) (\d+)$")
ROBOT_PATTERN_DOUBLE_TAP = re.compile("^double-tap (\d+) (\d+) (\d+)$")
ROBOT_PATTERN_TRIPLE_TAP = re.compile("^triple-tap (\d+) (\d+) (\d+)$")
ROBOT_PATTERN_RESET = re.compile("^reset$")
ROBOT_PATTERN_GET_CALIBRATION = re.compile("^get-calibration$")
ROBOT_PATTERN_SET_CALIBRATION = re.compile("^set-calibration .+$") #FIXME Improve the regex to make it match to JSON calibration data string
ROBOT_PATTERN_CONFIG = re.compile("^config$")
ROBOT_PATTERN_HELP = re.compile("^help$")
ROBOT_PATTERN_BYE = re.compile("^bye$")
ROBOT_PATTERN_STATUS = re.compile("^status$")
ROBOT_PATTERN_DANCE = re.compile("^dance$")
ROBOT_PATTERN_STOP_DANCE = re.compile("^stop-dance$")
ROBOT_PATTERN_SWIPE = re.compile("^swipe (\d+) (\d+) (\d+) (\d+)$")
ROBOT_PATTERN_N_TAP = re.compile("^n-tap (\d+) (\d+) (\d+)$")
ROBOT_PATTERN_POSITION_FOR_SCREEN_COORD = re.compile("^posForScreen (\d+) (\d+)$")
ROBOT_PATTERN_ANGLES_FOR_POSITION = re.compile("^angForPos (-*\d+) (-*\d+) (-*\d+)$")
ROBOT_PATTERN_CHECK = re.compile("^check$")
ROBOT_PATTERN_STRESS_SWIPE = re.compile("^stress-swipe (\d+) (\d+) (\d+) (\d+) (\d+)$")
ROBOT_PATTERN_STRESS_TAP = re.compile("^stress-tap (\d+) (\d+) (\d+)$")
ROBOT_PATTERN_REPEAT = re.compile("^repeat$")
ROBOT_PATTERN_CONTACT_Z = re.compile("^contact-z$")
ROBOT_PATTERN_N_SWIPE = re.compile("^n-swipe (\d+) (\d+) (\d+) (\d+) (\d+)$")
ROBOT_PATTERN_DRAW_SQUARE = re.compile("square (\d+) (\d+)$")
ROBOT_PATTERN_DRAW_STAR = re.compile("^star$")
ROBOT_PATTERN_DRAW_TRIANGLE = re.compile("^triangle (\d+) (\d+) (\d+) (\d+) (\d+) (\d+)$")
ROBOT_PATTERN_DRAW_CIRCLE = re.compile("^circle (\d+) (\d+) (\d+)$")
ROBOT_PATTERN_DRAW_CROSS = re.compile("^cross (\d+) (\d+) (\d+) (\d+) (\d+) (\d+) (\d+) (\d+)$")
ROBOT_PATTERN_DRAW_SPIRAL = re.compile("^spiral (\d+) (\d+) (\d+) (\d+)$")
ROBOT_PATTERN_DRAW_RANDOM = re.compile("^random (\d+) (\d+) (\d+) (\d+) (\d+)$")
