# -*- coding: utf_8 -*-
# SPDX-FileCopyrightText: 2018 Orange SA
# SPDX-License-Identifier: BSD-2-Clause OR MIT

"""
File.......: robot-api.py
Brief......: File including the API of the robot, using HTTP requests
Version....: 1.4.0
Since......: 10/01/2018
"""

# *******
# IMPORTS
# *******

import requests # You must install previously this module
import json
import time
import config

# *********
# FUNCTIONS
# *********

# Function: checkRobotConnection()
def checkRobotConnection():
    """
        Checks the robot server's connection, i.e. if the server is running.
        Returns the True if status code is 200, False otherwise
    """
    # FIXME Make a better management
    try:
        r = requests.head(config.ROBOT_URL+"/status")
        print "Connection made. Status code: " + str(r.status_code)
        return r.status_code == 200
    except requests.exceptions.ConnectionError:
        print "ERROR: Connection error"
        return False
# End of Function: checkRobotConnection()

# Function: robot_getAngles()
def robot_getAngles():
        """
            Sends to the robot's server an HTTP request so as to get the arms' angles values.
            Displays a text and readable results of the command.
            Returns the results of the command.
        """
        print "Sending get-angles request..."
        request = requests.get(config.ROBOT_URL + config.ROBOT_URL_GET_ANGLES)
        print request.text
        return request.json()
# End of Function: robot_getAngles()

# Function robot_setAngles( theta1, theta1, theta3 )
def robot_setAngles( theta1, theta2, theta3 ):
        """
            Sends to the robot's server an HTTP request so as to set the arms' angles values.
            Parameters: theta1, theta2, theta3 as float numbers.
            Displays a text and readable results of the command.
            Returns the results of the command.
        """
        print "Sending set-angles request..."
        payload = {'theta1': theta1, 'theta2': theta2, 'theta3': theta3}
        request = requests.post(config.ROBOT_URL + config.ROBOT_URL_SET_ANGLES, data=payload)
        print request.text
        return request.json()
# End of Function: robot_setAngles( theta1, theta1, theta3 )

# Function: robot_getPosition()
def robot_getPosition():
        """
            Sends to the robot's server an HTTP request so as to get its position in 3D landmark
            Displays a text and readable results of the command.
            Returns the results of the command.
        """
        print "Sending get-position request..."
        request = requests.get(config.ROBOT_URL + config.ROBOT_URL_GET_POSITION)
        print request.text
        return request.json()
# End of Function: robot_getPosition()

# Function: robot_setPosition( x, y, z )
def robot_setPosition( x, y, z ):
        """
            Sends to the robot's server an HTTP request so as to set the position of its arms in 3D landmark.
            Parameters: x, y, z as integer numbers.
            Displays a text and readable results of the command.
            Returns the results of the command.
        """
        print "Sending set-position request..."
        payload = {'x': x, 'y': y, 'z': z}
        request = requests.post(config.ROBOT_URL + config.ROBOT_URL_SET_POSITION, data=payload)
        print request.text
        return request.json()
# End of Function: robot_setPosition( x, y, z )

# Function: robot_tap( x, y )
def robot_tap( x, y ):
        """
            Sends to the robot's server an HTTP request so as to make it tp at (x, y) using the device's 2D landmark.
            Parameters: x, y as integer numbers.
            Displays a text and readable results of the command.
            Returns the results of the command.
        """
        print "Sending tap request..."
        payload = {'x': x, 'y': y}
        request = requests.post(config.ROBOT_URL + config.ROBOT_URL_TAP, data=payload)
        print request.text
        return request.json()
# End of Function: robot_tap( x, y )

# Function: robot_longTap( x, y, duration )
def robot_longTap( x, y, duration ):
        """
            Sends to the robot's server an HTTP request so as to make a long tap at (x, y) using the device's 2D landmark.
            Parameters: x, y, duration as integer numbers, (x,) in 2D device landmark
            Displays a text and readable results of the command.
            Returns the results of the command.
        """
        print "Sending long tap request..."
        payload = {'x': x, 'y': y, 'duration': duration}
        request = requests.post(config.ROBOT_URL + config.ROBOT_URL_LONG_TAP, data=payload)
        print request.text
        return request.json()
# End of Function: robot_longTap( x, y, duration )

# Function: robot_doubleTap( x, y, duration )
def robot_doubleTap( x, y, duration ):
        """
            Sends to the robot's server an HTTP request so as to make a double tap at (x, y) using the device's 2D landmark.
            Parameters: x, y, duration as integer numbers, (x,) in 2D device landmark
            Displays a text and readable results of the command.
            Returns the results of the command.
        """
        print "Sending long tap request..."
        payload = {'x': x, 'y': y, 'duration': duration}
        request = requests.post(config.ROBOT_URL + config.ROBOT_URL_DOUBLE_TAP, data=payload)
        print request.text
        return request.json()
# End of Function: robot_doubleTap( x, y, duration )

# Function: robot_tripleTap( x, y, duration )
def robot_tripleTap( x, y, duration ):
        """
            Sends to the robot's server an HTTP request so as to make a triple tap at (x, y) using the device's 2D landmark.
            Parameters: x, y, duration as integer numbers, (x,) in 2D device landmark
            Displays a text and readable results of the command.
            Returns the results of the command.
        """
        print "Sending long tap request..."
        payload = {'x': x, 'y': y, 'duration': duration}
        request = requests.post(config.ROBOT_URL + config.ROBOT_URL_TRIPLE_TAP, data=payload)
        print request.text
        return request.json()
# End of Function: robot_tripleTap( x, y, duration )

# Function: robot_reset()
def robot_reset():
        """
            Sends to the robot's server an HTTP request so as to reset it.
            Displays a text and readable results of the command.
            Returns the results of the command.
        """
        print "Sending reset request..."
        payload = {}
        request = requests.post(config.ROBOT_URL + config.ROBOT_URL_RESET, data=payload)
        print request.text
        return request.json()
# End of Function: robot_reset()

# Function: robot_getCalibration()
def robot_getCalibration():
        """
            Sends to the robot's server an HTTP request so as to get its calibration data.
            Displays a text and readable results of the command.
            Returns the results of the command.
        """
        print "Sending get-calibration request..."
        request = requests.get(config.ROBOT_URL + config.ROBOT_URL_GET_CALIBRATION)
        print request.text
        return request.json()
# End of Function: robot_getCalibration()

# Function: robot_setCalibration( jsonData )
def robot_setCalibration( jsonData ):
        """
            Sends to the robot's server an HTTP request so as to define its calibration data to use.
            Parameter: the calibration data in JSON format.
            Displays a text and readable results of the command.
            Returns the results of the command.
        """
        print "Sending set-calibration request..."
        payload = json.loads(jsonData)
        request = requests.post(config.ROBOT_URL + config.ROBOT_URL_SET_CALIBRATION, data=payload)
        print request.text
        return request.json()
# End of Function: robot_setCalibration( jsonData )

# Function: robot_status()
def robot_status():
        """
            Sends to the robot's server an HTTP request so as to get its status.
            Displays a text and readable results of the command.
            Returns the results of the command.
        """
        print "Sending get-status request..."
        request = requests.get(config.ROBOT_URL + config.ROBOT_URL_STATUS)
        print request.text
        return request.json()
# End of Function: robot_status()

# Function: robot_dance()
def robot_dance():
        """
            Sends to the robot's server an HTTP request so as to make it dance.
            Displays a text and readable results of the command.
            Returns the results of the command.
        """
        print "Sending dance request..."
        payload = {}
        request = requests.post(config.ROBOT_URL + config.ROBOT_URL_DANCE)
        print request.text
        return request.json()
# End of Function: robot_dance()

# Function: robot_stopDance()
def robot_stopDance():
        """
            Sends to the robot's server an HTTP request so as to make it stop dancing.
            Displays a text and readable results of the command.
            Returns the results of the command.
        """
        print "Sending stop-dance request..."
        payload = {}
        request = requests.post(config.ROBOT_URL + config.ROBOT_URL_STOP_DANCE)
        print request.text
        return request.json()
# End of Function: robot_stopDance()

# Function: robot_swipe( startX, startY, endX, endY )
def robot_swipe( startX, startY, endX, endY ):
        """
            Sends to the robot's server an HTTP request so as to swipe from (startX, startY) to (endX, endY).
            Parameters: startX, startY, endX, endY as integer numbers.
            Displays a text and readable results of the command.
            Returns the results of the command.
        """
        print "Sending swipe request..."
        payload = {'startX': startX, 'startY': startY, 'endX': endX, 'endY': endY}
        request = requests.post(config.ROBOT_URL + config.ROBOT_URL_SWIPE, data=payload)
        print request.text
        return request.json()
# End of Function: robot_swipe( x, y, z )

# Function: robot_ntap( n, x, y )
def robot_ntap( n, x, y ):
        """
            Sends to the robot's server n HTTP requests so as to tap n times on (x,y).
            Parameters: n, x, y as integer numbers.
            Displays a text and readable results of the command.
            Returns the results of the last executed command.
        """
        print "Sending "+ n + " tap requests..."
        payload = {'x': x, 'y': y}
        for i in range(0, int(n)):
            request = requests.post(config.ROBOT_URL + config.ROBOT_URL_TAP, data=payload)
            print request.text
            time.sleep(config.WAIT_TIME_BETWEEN_TAP)
        return request.json()
# End of Function: robot_ntap( n, x, y )

# Function: robot_posForScreen( x, y )
def robot_posForScreen( x, y ):
        """
            Sends to the robot's server an HTTP request so as to get the 3D coordinates according to the (x,y) 2D coordinates.
            Parameters: x, y as integer numbers.
            Displays a text and readable results of the command.
            Returns the results of the command.
        """
        print "Sending posForScreen request..."
        request = requests.get(config.ROBOT_URL + config.ROBOT_URL_POSITION_FOR_SCREEN_COORD+"/x/"+x+"/y/"+y)
        print request.text
        return request.json()
# End of Function: robot_posForScreen( x, y )

# Function: robot_angForPos( x, y, z )
def robot_angForPos( x, y, z ):
        """
            Sends to the robot's server an HTTP request so as to get the angles of the arms for the (x,y,z) 3D coordinates
            Parameters: x, y, z as integer numbers.
            Displays a text and readable results of the command.
            Returns the results of the command.
        """
        print "Sending angForPos request..."
        request = requests.get(config.ROBOT_URL + config.ROBOT_URL_ANGLES_FOR_POSITION+"/x/"+x+"/y/"+y+"/z/"+z)
        print request.text
        return request.json()
# End of Function: robot_angForPos( x, y, z )

# Function: robot_stressSwipe( n, startX, startY, endX, endY )
def robot_stressSwipe( n, startX, startY, endX, endY ):
        """
            Sends to the robot's server n HTTP requests for swipes from (startX, startY) to (endX, endY) with WAIT_TIME_STRESS_SWIPE duration between each swipe to as to stress the app.
            Parameters:  n, startX, startY, endX, endY as integer numbers.
            Displays a text and readable results of the command.
            Returns the results of the command.
        """
        print "Sending "+ n + " stress swipe requests..."
        payload = {'startX': startX, 'startY': startY, 'endX': endX, 'endY': endY}
        for i in range(0, int(n)):
            request = requests.post(config.ROBOT_URL + config.ROBOT_URL_SWIPE, data=payload)
            print request.text
            time.sleep(config.WAIT_TIME_STRESS_SWIPE)
        return request.json()
# End of Function: robot_stressSwipe( n, startX, startY, endX, endY )

# Function: robot_stressTap( n, x, y )
def robot_stressTap( n, x, y  ):
        """
            Sends to the robot's server n HTTP requests for taps to (x, y) with WAIT_TIME_STRESS_TAP duration between each tap to as to stress the app.
            Parameters:  n, x, y as integer numbers.
            Displays a text and readable results of the command.
            Returns the results of the command.
        """
        print "Sending "+ n + " stress tap requests..."
        payload = {'x': x, 'y': y}
        for i in range(0, int(n)):
            request = requests.post(config.ROBOT_URL + config.ROBOT_URL_TAP, data=payload)
            print request.text
            time.sleep(config.WAIT_TIME_STRESS_TAP)
        return request.json()
# End of Function: robot_stressTap( n, x, y )

# Function: robot_getContactZ()
def robot_getContactZ():
        """
            Sends to the robot's server an HTTP request so as to get its Z contact value.
            Displays a text and readable results of the command.
            Returns the results of the command.
        """
        print "Sending contact-z request..."
        request = requests.get(config.ROBOT_URL + config.ROBOT_URL_CONTACT_Z)
        print request.text
        return request.json()
# End of Function: robot_getContactZ()

# Function: robot_nswipe( n, startX, startY, endX, endY )
def robot_nswipe( n, startX, startY, endX, endY ):
        """
            Sends to the robot's server n HTTP requests so as to make n swipes from (startX, startY) to (endX, endY).
            Parameters:  n, startX, startY, endX, endY as integer numbers.
            Displays a text and readable results of the command.
            Returns the results of the last executed command.
        """
        print "Sending "+ n + " swipe requests..."
        payload = {'startX': startX, 'startY': startY, 'endX': endX, 'endY': endY}
        for i in range(0, int(n)):
            request = requests.post(config.ROBOT_URL + config.ROBOT_URL_SWIPE, data=payload)
            print request.text
            time.sleep(config.WAIT_TIME_BETWEEN_SWIPE)
        return request.json()
# End of Function: robot_nswipe( n, startX, startY, endX, endY )

# Function: robot_drawSquare( n, length )
def robot_drawSquare( n, length ):
        """
            Sends to the robot's serverHTTP requests so as to draw a square with a dedicated length, and draw each n points
            Parameters:  n, length integer numbers.
            Displays a text and readable results of the command.
            Returns the results of the last executed command.
        """
        print "Sending draw square request..."
        payload = {'n': n, 'length': length}
        request = requests.post(config.ROBOT_URL + config.ROBOT_URL_DRAW_SQUARE, data=payload)
        print request.text
        return request.json()
# End of Function: robot_drawSquare( n, length )


# Function: robot_drawStar()
def robot_drawStar():
        """
            Sends to the robot's server an HTTP request so as to draw a star
            Displays a text and readable results of the command.
            Returns the results of the command.
        """
        print "Sending draw star request..."
        payload = {}
        request = requests.post(config.ROBOT_URL + config.ROBOT_URL_DRAW_STAR, data=payload)
        print request.text
        return request.json()
# End of Function: robot_getContactZ()

# Function: robot_drawTriangle(x1, y1, x2, y2, x3, y3)
def robot_drawTriangle(x1, y1, x2, y2, x3, y3):
        """
            Sends to the robot's server HTTP requests so as to draw a triangle using poitns (x1,y1) (x2,y2) (x3,y3)
            Parameters:  x1, y1, x2, y2, x3, y3 as integer numbers, based on device 2D landmark
            Displays a text and readable results of the command.
            Returns the results of the last executed command.
        """
        print "Sending draw triangle request..."
        payload = {'x1': x1, 'y1': y1, 'x2': x2,'y2': y2, 'x3': x3,'y3': y3}
        request = requests.post(config.ROBOT_URL + config.ROBOT_URL_DRAW_TRIANGLE, data=payload)
        print request.text
        return request.json()
# End of Function: robot_drawTriangle(x1, y1, x2, y2, x3, y3)

# Function: robot_drawCircle(x, y, r)
def robot_drawCircle(x, y, r):
        """
            Sends to the robot's server an HTTP requests so as to draw a circle centered on(x,y) with r radius
            Parameters:  x, y, r as integer numbers, based on device 2D landmark
            Displays a text and readable results of the command.
            Returns the results of the last executed command.
        """
        print "Sending draw circle request..."
        payload = {'x': x, 'y': y, 'r': r}
        request = requests.post(config.ROBOT_URL + config.ROBOT_URL_DRAW_CIRCLE, data=payload)
        print request.text
        return request.json()
# End of Function: robot_drawCircle(x, y, r)

# Function: robot_drawCross(x1, y1, x2, y2, x3, y3, x4, y4)
def robot_drawCross(x1, y1, x2, y2, x3, y3, x4, y4):
        """
            Sends to the robot's server an HTTP requests so as to draw a cross using 4 points
            Parameters:  x1, y1, x2, y2, x3, y3, x4, y4 as integer numbers, based on device 2D landmark
            Displays a text and readable results of the command.
            Returns the results of the last executed command.
        """
        print "Sending draw cross request..."
        payload = {'x1': x1, 'y1': y1, 'x2': x2, 'y2': y2, 'x3': x3, 'y3': y3, 'x4': x4, 'y4': y4}
        request = requests.post(config.ROBOT_URL + config.ROBOT_URL_DRAW_CROSS, data=payload)
        print request.text
        return request.json()
# End of Function: robot_drawCross(x1, y1, x2, y2, x3, y3, x4, y4)

# Function: robot_drawSpiral(x, y, n, r)
def robot_drawSpiral(x, y, n, r):
        """
            Sends to the robot's server an HTTP requests so as to draw a spiral starting from a points, with n rings and a radius r
            Parameters:  x, y, n ,r as integer numbers, based on device 2D landmark
            Displays a text and readable results of the command.
            Returns the results of the last executed command.
        """
        print "Sending draw spiral request..."
        payload = {'x': x, 'y': y, 'n': n, 'r': r}
        request = requests.post(config.ROBOT_URL + config.ROBOT_URL_DRAW_SPIRAL, data=payload)
        print request.text
        return request.json()
# End of Function: robot_drawSpiral(x, y, n, r)

# Function: robot_drawRandom(n, minWidth, minHeight, maxWidth, maxHeight)
def robot_drawRandom(n, minWidth, minHeight, maxWidth, maxHeight):
        """
            Sends to the robot's server an HTTP requests so as to draw a random pattern
            with (n-1) strokes in a defined area (points picked with [minWidth ; minHeight] and [maxWidth; maxHeight])
            Parameters:  n, minWidth, minHeight, maxWidth, maxHeight as integer numbers, based on device 2D landmark
            Displays a text and readable results of the command.
            Returns the results of the last executed command.
        """
        print "Sending draw random request..."
        payload = {'n': n, 'minWidth': minWidth, 'minHeight': minHeight, 'maxWidth': maxWidth, 'maxHeight': maxHeight}
        request = requests.post(config.ROBOT_URL + config.ROBOT_URL_DRAW_RANDOM, data=payload)
        print request.text
        return request.json()
# End of Function: robot_drawRandom(n, minWidth, minHeight, maxWidth, maxHeight)
