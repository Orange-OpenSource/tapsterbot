# SPDX-FileCopyrightText: 2018 Orange SA
# SPDX-License-Identifier: BSD-2-Clause OR MIT

#
# File.......: tapster_keywords.robot
# Brief......: File contaning Robot Framework keywords to use to as to deal with the Tapster2 bot
# Version....: 2.0.0
# Since......: 17/01/2018


*** Settings ***

Documentation
...    Here are keywords you can use in your Robot Framework tests cases.
...    If you are in a TDD/BDD/ATDD method, you may need to test your mobile applications with a Tapster 2 robot.
...    You can find here kewyrods to integrate so as to deal with the robot's API.
...    The things you can do with another client can be done with these keywords.
...    Be aware that keywords send HTTP requests to robot's server, so cascaded operations might be a mess, feel free to add wait operation between them.

Library    RequestsLibrary
Library    json
Library    Collections

Resource    config.robot


*** Keywords ***

# #########
# Some glue
# #########

Create robot session
    [Documentation]    Creates a network session (using RequestsLibrary) with the robot with a dedicated alias and maybe a robot's server URL.
    ...    You must create a session before using the robot.
    ...    Parameters:
    ...        session_alias - the alias of the session
    ...        roboturl - optional, the URL of the server running the robot
    ...    Returns:
    ...        the created session.
    [Arguments]    ${session_alias}    ${roboturl}=${DEFAULT_ROBOT_URL}
    ${session} =    Create Session    ${session_alias}    ${roboturl}
    [Return]    ${session}

Delete robot session
    [Documentation]    Deletes an existing session which have this alias
    ...    Parameters:
    ...        session_alias - the alias of the session
    ...        roboturl - optional, the URL of the server running the robot
    ...    Returns:
    ...        the result of the deletion request
    [Arguments]    ${session_alias}    ${roboturl}=${DEFAULT_ROBOT_URL}
    ${results} =    Delete Request    ${session_alias}    ${roboturl}
    [Return]    ${results}

Wait
    [Documentation]    Waits during a time so as to let the robot's server process its last received request.
    ...    Indeed this server cannot temporise/cache request itself yet, here is a trick to temporise in the client side.
    ...    Parameters:
    ...         duration - the duration to wait, by default WAIT_BETWEEN_CASCADED_OPERATION
    [Arguments]    ${duration}=${WAIT_BETWEEN_CASCADED_OPERATION}
    Sleep    ${duration}

# ###########
# Robot's API
# ###########

Check connection of robot
    [Documentation]    Checks if the connection of the robot with the given session has been established.
    ...    Parameters:
    ...        session - the session for this robot
    ...    Returns:
    ...        the status code sent by the robot's server.
    [Arguments]    ${session}
    ${response} =    Head Request    ${session}    ${ROBOT_URL_STATUS}
    Should Be Equal As Strings    ${response.status_code}    200
    Wait
    [Return]    ${response.status_code}

Get angles of arms
    [Documentation]    Returns the angles the arms of the robot have using the given session.
    ...    Parameters:
    ...        session - the session for this robot
    ...    Returns:
    ...        the angles
    [Arguments]    ${session}
    ${response} =    Get Request    ${session}    ${ROBOT_URL_GET_ANGLES}
    Wait
    [Return]    ${response.text}

Set angles of arms
    [Documentation]    Defines the (theta1, theta2, theta3) angles of the arms the robot should have with the given session
    ...    Parameters:
    ...        session - the session for this robot
    ...    Returns:
    ...        the response of the robot's server
    [Arguments]    ${session}    ${theta1}    ${theta2}    ${theta3}
    &{angles_raw} =    Create Dictionary    theta1=${theta1}    theta2=${theta2}    theta3=${theta3}
    ${angles} =    json.dumps    ${angles_raw}
    ${response} =    Post Request    ${session}    ${ROBOT_URL_SET_ANGLES}    data=${angles}
    Wait
    [Return]    ${response.text}

Get 3D position
    [Documentation]    Returns the position in 3D landmark of the robot with the given session
    ...    Parameters:
    ...        session - the session for this robot
    ...    Returns:
    ...        the 3D position in robot's landmark
    [Arguments]    ${session}
    ${response} =    Get Request    ${session}    ${ROBOT_URL_GET_POSITION}
    Wait
    [Return]    ${response.text}

Set 3D position
    [Documentation]    Defines the (x, y, z) position the robot must have with the given session
    ...    Parameters:
    ...        session - the session for this robot
    ...        x - The x value
    ...        y - The y value
    ...        z - The z value, where around -155 is the value where the baseplate is reached
    ...    Returns:
    ...        Returns the response of the robot's server.
    [Arguments]    ${session}    ${x}    ${y}    ${z}
    &{position_raw} =    Create Dictionary    x=${x}    y=${y}    z=${z}
    ${position} =    json.dumps    ${position_raw}
    ${response} =    Post Request    ${session}    ${ROBOT_URL_SET_POSITION}    data=${position}
    Wait
    [Return]    ${response.text}

Tap to point
    [Documentation]    Makes the robot with the given session tap to the point at (x, y)
    ...    Parameters:
    ...        session - the session for this robot
    ...        x - The x value of the point to tap
    ...        y - The y value of the point to tap
    ...    Returns:
    ...        Returns the response of the robot's server.
    [Arguments]    ${session}    ${x}    ${y}
    &{tap_raw} =    Create Dictionary    x=${x}    y=${y}
    ${tap} =    json.dumps    ${tap_raw}
    ${response} =    Post Request    ${session}    ${ROBOT_URL_TAP}    data=${tap}
    Wait
    [Return]    ${response.text}

Long tap to point
    [Documentation]    Makes the robot with the given session tap to the point at (x, y) during duration in ms
    ...    Parameters:
    ...        session - the session for this robot
    ...        x - The x value of the point to tap
    ...        y - The y value of the point to tap
    ...        duration - The duration for the contact (optional, default valued to DEFAULT_DURATION_LONG_TAP)
    ...    Returns:
    ...        Returns the response of the robot's server.
    [Arguments]    ${session}    ${x}    ${y}    ${duration}=${DEFAULT_DURATION_LONG_TAP}
    &{long_tap_raw} =    Create Dictionary    x=${x}    y=${y}    duration=${duration}
    ${long_tap} =    json.dumps    ${long_tap_raw}
    ${response} =    Post Request    ${session}    ${ROBOT_URL_LONG_TAP}    data=${long_tap}
    ${duration_in_seconds} =    Evaluate    ${duration}/1000
    Wait    ${duration_in_seconds}
    [Return]    ${response.text}

Double tap to point
    [Documentation]    Makes the robot with the given session tap twice to the point at (x, y) during duration in ms
    ...    Parameters:
    ...        session - the session for this robot
    ...        x - The x value of the point to tap
    ...        y - The y value of the point to tap
    ...        duration - The duration to wait between two contact (optional, default valued to DEFAULT_DURATION_MULTI_TAP)
    ...    Returns:
    ...        Returns the response of the robot's server.
    [Arguments]    ${session}    ${x}    ${y}    ${duration}=${DEFAULT_DURATION_MULTI_TAP}
    &{double_tap_raw} =    Create Dictionary    x=${x}    y=${y}    duration=${duration}
    ${double_tap} =    json.dumps    ${double_tap_raw}
    ${response} =    Post Request    ${session}    ${ROBOT_URL_DOUBLE_TAP}    data=${double_tap}
    Wait
    [Return]    ${response.text}

Triple tap to point
    [Documentation]    Makes the robot with the given session tap three times to the point at (x, y) during duration in ms
    ...    Parameters:
    ...        session - the session for this robot
    ...        x - The x value of the point to tap
    ...        y - The y value of the point to tap
    ...        duration - The duration to wait between each contact (optional, default valued to DEFAULT_DURATION_MULTI_TAP)
    ...    Returns:
    ...        Returns the response of the robot's server.
    [Arguments]    ${session}    ${x}    ${y}    ${duration}=${DEFAULT_DURATION_MULTI_TAP}
    &{triple_tap_raw} =    Create Dictionary    x=${x}    y=${y}    duration=${duration}
    ${triple_tap} =    json.dumps    ${triple_tap_raw}
    ${response} =    Post Request    ${session}    ${ROBOT_URL_TRIPLE_TAP}    data=${triple_tap}
    Wait
    [Return]    ${response.text}

Reset
    [Documentation]    Resets the position / arms of the robot to their default values with the given session
    ...    Parameters:
    ...        session - the session for this robot
    ...    Returns:
    ...        Returns the response of the robot's server.
    [Arguments]    ${session}
    &{empty_payload_raw} =    Create Dictionary
    ${empty_payload} =    json.dumps    ${empty_payload_raw}
    ${response} =    Post Request    ${session}    ${ROBOT_URL_RESET}    data=${empty_payload}
    Wait
    [Return]    ${response.text}

Get calibration data
    [Documentation]    Returns the calibration data of the robot with the given session
    ...    Parameters:
    ...        session - the session for this robot
    ...    Returns:
    ...        Returns the response of the robot's server.
    [Arguments]    ${session}
    ${response} =    Get Request    ${session}    ${ROBOT_URL_GET_CALIBRATION}
    Wait
    [Return]    ${response.text}

Set calibration data
    [Documentation]    Defines the calibation data in JSON format to apply to the robot with the given session.
    ...    Parameters:
    ...        session - the session for this robot
    ...        calibraiton_data - The JSON object, stringigied, contaniing calibration elements
    ...    Returns:
    ...        Returns the response of the robot's server.
    [Arguments]    ${session}    ${calibration_data}
    ${response} =    Post Request    ${session}    ${ROBOT_URL_SET_CALIBRATION}    data=${calibration_data}
    Wait
    [Return]    ${response.text}

Get status
    [Documentation]    Returns the status of the robot's server with the given session
    ...    Parameters:
    ...        session - the session for this robot
    ...    Returns:
    ...        Returns the response of the robot's server.
    [Arguments]    ${session}
    ${response} =    Get Request    ${session}    ${ROBOT_URL_STATUS}
    Wait
    [Return]    ${response.text}

Dance
    [Documentation]    Make the robot dance with the given session!
    ...    Parameters:
    ...        session - the session for this robot
    ...    Returns:
    ...        Returns the response of the robot's server.
    [Arguments]    ${session}
    &{empty_payload_raw} =    Create Dictionary
    ${empty_payload} =    json.dumps    ${empty_payload_raw}
    ${response} =    Post Request    ${session}    ${ROBOT_URL_DANCE}    data=${empty_payload}
    Wait
    [Return]    ${response.text}

Stop dance
    [Documentation]    Make the robot stop dancing with the given session :-(
    ...    Parameters:
    ...        session - the session for this robot
    ...    Returns:
    ...        Returns the response of the robot's server.
    [Arguments]    ${session}
    &{empty_payload_raw} =    Create Dictionary
    ${empty_payload} =    json.dumps    ${empty_payload_raw}
    ${response} =    Post Request    ${session}    ${ROBOT_URL_STOP_DANCE}    data=${empty_payload}
    Wait
    [Return]    ${response.text}

Swipe
    [Documentation]    Makes the robot with the given session swipe from (a,b) to (c,d)
    ...    Parameters:
    ...        session - the session for this robot
    ...        a - the x value of the start point
    ...        b - the y value of the start point
    ...        c - the x value of the end point
    ...        d - the y value of the end point
    ...    Returns:
    ...        Returns the response of the robot's server.
    [Arguments]    ${session}    ${a}    ${b}    ${c}    ${d}
    &{swipe_raw} =    Create Dictionary    startX=${a}    startY=${b}    endX=${c}    endY=${d}
    ${swipe} =    json.dumps    ${swipe_raw}
    ${response} =    Post Request    ${session}    ${ROBOT_URL_SWIPE}    data=${swipe}
    Wait
    [Return]    ${response.text}

Tap n times
    [Documentation]    Makes the robot with the given session tap n times on (x,y)
    ...    Parameters:
    ...        session - the session for this robot
    ...        n - the number of taps to process
    ...        x - the x value of the point to tap on
    ...        y - the y value of the point to tap on
    ...    Returns:
    ...        Returns the response of the robot's server.
    [Arguments]    ${session}    ${n}    ${x}    ${y}
    &{tap_raw} =    Create Dictionary    x=${x}    y=${y}
    ${tap} =    json.dumps    ${tap_raw}
    : FOR    ${INDEX}    IN RANGE    0    ${n}
    \        ${response} =    Post Request    ${session}    ${ROBOT_URL_TAP}    data=${tap}
    \        Wait    ${WAIT_TIME_BETWEEN_TAP}
    [Return]    ${response.text}

Swipe n times
    [Documentation]     Makes the robot with the given session swipes n times from (a,b) to (c,d)
    ...    Parameters:
    ...        session - the session for this robot
    ...        n - the number of swipes to do
    ...        a - the x value of the start point
    ...        b - the y value of the start point
    ...        c - the x value of the end point
    ...        d - the y value of the end point
    ...    Returns:
    ...        Returns the response of the robot's server.
    [Arguments]    ${session}    ${n}    ${a}    ${b}    ${c}    ${d}
    &{swipe_raw} =    Create Dictionary    startX=${a}    startY=${b}    endX=${c}    endY=${d}
    ${swipe} =    json.dumps    ${swipe_raw}
    : FOR    ${INDEX}    IN RANGE    0    ${n}
    \        ${response} =    Post Request    ${session}    ${ROBOT_URL_SWIPE}    data=${swipe}
    \        Wait    ${WAIT_TIME_BETWEEN_SWIPE}
    [Return]    ${response.text}

Position for screen
    [Documentation]    Gets the position of the robot (using the given session) according to an (x,y) 2D device landmark point
    ...    Parameters:
    ...        session - the session for this robot
    ...        x - the x value of the point
    ...        y - the y value of the point
    ...    Returns:
    ...        Returns the response of the robot's server.
    [Arguments]    ${session}    ${x}    ${y}
    ${url} =    Catenate    SEPARATOR=  ${ROBOT_URL_POSITION_FOR_SCREEN_COORD}    /x/    ${x}    /y/    ${y}
    ${response} =    Get Request    ${session}    ${url}
    Wait
    [Return]    ${response.text}

Angles for position
    [Documentation]    Gets the angles of the robot's arms for the (x, y, z) 3D point
    ...    Parameters:
    ...        session - the session for this robot
    ...        x - the x value of the point
    ...        y - the y value of the point
    ...        z - the z value of the point
    ...    Returns:
    ...        Returns the response of the robot's server.
    [Arguments]    ${session}    ${x}    ${y}    ${z}
    ${url} =    Catenate    SEPARATOR=  ${ROBOT_URL_ANGLES_FOR_POSITION}    /x/    ${x}    /y/    ${y}    /z/    ${z}
    ${response} =    Get Request    ${session}    ${url}
    Wait
    [Return]    ${response.text}

Get contact Z
    [Documentation]    Gets the Z-axis value of the contact point the robot has (using the given session)
    ...    Parameters:
    ...        session - the session for this robot
    ...    Returns:
    ...        Returns the response of the robot's server.
    [Arguments]    ${session}
    ${response} =    Get Request    ${session}    ${ROBOT_URL_CONTACT_Z}
    Wait
    [Return]    ${response.text}

Stress taps
    [Documentation]    Stresses the app under the robot with n quick taps on (x,y) 2D point using a session
    ...    Parameters:
    ...        session - the session for this robot
    ...        n - the number of very quick taps to process
    ...        x - the x value of the impact point
    ...        y - the y value of the impact point
    ...    Returns:
    ...        Returns the response of the robot's server.
    [Arguments]    ${session}    ${n}    ${x}    ${y}
    &{tap_raw} =    Create Dictionary    x=${x}    y=${y}
    ${tap} =    json.dumps    ${tap_raw}
    : FOR    ${INDEX}    IN RANGE    0    ${n}
    \        ${response} =    Post Request    ${session}    ${ROBOT_URL_TAP}    data=${tap}
    \        Wait    ${WAIT_TIME_STRESS_TAP}
    [Return]    ${response.text}

Stress swipes
    [Documentation]    Stresses the app under the robot with n quick swipes from (a,b) to (c,d) using a session
    ...    Parameters:
    ...        session - the session for this robot
    ...        n - the number of very quick swipes to process
    ...        a - the x value of the start point
    ...        b - the y value of the start point
    ...        c - the x value of the end point
    ...        d - the y value of the end point
    ...    Returns:
    ...        Returns the response of the robot's server.
    [Arguments]    ${session}    ${n}    ${a}    ${b}    ${c}    ${d}
    &{swipe_raw} =    Create Dictionary    startX=${a}    startY=${b}    endX=${c}    endY=${d}
    ${swipe} =    json.dumps    ${swipe_raw}
    : FOR    ${INDEX}    IN RANGE    0    ${n}
    \        ${response} =    Post Request    ${session}    ${ROBOT_URL_SWIPE}    data=${swipe}
    \        Wait    ${WAIT_TIME_STRESS_SWIPE}
    [Return]    ${response.text}

Draw random pattern
    [Documentation]    Draws a random pattern with strokes usgin n points in a defined area
    ...    Parameters:
    ...        session - the session for this robot
    ...        n - the number points where their x and y are picked from [minWidth, maxWidth] for and [minHeight, maxHeight] for y
    ...        minWidth - the x value of the start point
    ...        minHeight - the y value of the start point
    ...        maxWidth - the x value of the end point
    ...        maxHeight - the y value of the end point
    ...    Returns:
    ...        Returns the response of the robot's server.
    [Arguments]    ${session}    ${n}    ${minWidth}    ${minHeight}    ${maxWidth}    ${maxHeight}
    &{draw_raw} =    Create Dictionary    n=${n}    minWidth=${minWidth}    minHeight=${minHeight}    maxWidth=${maxWidth}    maxHeight=${maxHeight}
    ${draw} =    json.dumps    ${draw_raw}
    ${response} =    Post Request    ${session}    ${ROBOT_URL_DRAW_RANDOM}    data=${draw}
    Wait    ${WAIT_TIME_BETWEEN_TAP}
    [Return]    ${response.text}

Draw star
    [Documentation]    Draws a simple star
    ...    Parameters:
    ...        session - the session for this robot
    ...    Returns:
    ...        Returns the response of the robot's server.
    [Arguments]    ${session}
    &{draw_raw} =    Create Dictionary
    ${draw} =    json.dumps    ${draw_raw}
    ${response} =    Post Request    ${session}    ${ROBOT_URL_DRAW_STAR}    data=${draw}
    Wait    ${WAIT_TIME_BETWEEN_TAP}
    [Return]    ${response.text}

Draw circle
    [Documentation]    Draws a circle centered on (x,y) with r radius
    ...    Parameters:
    ...        session - the session for this robot
    ...        x - the x value of the center point
    ...        y - the y value of the center point
    ...        r - the radius of the circle
    ...    Returns:
    ...        Returns the response of the robot's server.
    [Arguments]    ${session}    ${x}    ${y}    ${r}
    &{draw_raw} =    Create Dictionary    x=${x}    y=${y}    r=${r}
    ${draw} =    json.dumps    ${draw_raw}
    ${response} =    Post Request    ${session}    ${ROBOT_URL_DRAW_CIRCLE}    data=${draw}
    Wait    ${WAIT_TIME_BETWEEN_TAP}
    [Return]    ${response.text}

Draw cross
    [Documentation]    Draws a cross using 4 corner points (1, 2, 3, 4) and two storkes (1 -> 3 and 2 -> 4)
    ...    Parameters:
    ...        session - the session for this robot
    ...        x1 - the x value of the corner point 1
    ...        y1 - the y value of the corner point 1
    ...        x2 - the x value of the corner point 2
    ...        y2 - the y value of the corner point 2
    ...        x3 - the x value of the corner point 3
    ...        y3 - the y value of the corner point 3
    ...        x4 - the x value of the corner point 4
    ...        y4 - the y value of the corner point 4
    ...    Returns:
    ...        Returns the response of the robot's server.
    [Arguments]    ${session}    ${x1}    ${y1}    ${x2}    ${y2}    ${x3}    ${y3}    ${x4}    ${y4}
    &{draw_raw} =    Create Dictionary    x1=${x1}    y1=${y1}    x2=${x2}    y2=${y2}    x3=${x3}    y3=${y3}    x4=${x4}    y4=${y4}
    ${draw} =    json.dumps    ${draw_raw}
    ${response} =    Post Request    ${session}    ${ROBOT_URL_DRAW_CROSS}    data=${draw}
    Wait    ${WAIT_TIME_BETWEEN_TAP}
    [Return]    ${response.text}

Draw square
    [Documentation]    Draws a square
    ...    Parameters:
    ...        session - the session for this robot
    ...        n - draw ech nth point
    ...        length - the length of the square
    ...    Returns:
    ...        Returns the response of the robot's server.
    [Arguments]    ${session}    ${n}    ${length}
    &{draw_raw} =    Create Dictionary    n=${n}    length=${length}
    ${draw} =    json.dumps    ${draw_raw}
    ${response} =    Post Request    ${session}    ${ROBOT_URL_DRAW_SQUARE}    data=${draw}
    Wait    ${WAIT_TIME_BETWEEN_TAP}
    [Return]    ${response.text}

Draw triangle
    [Documentation]    Draws a triangle using three points
    ...    Parameters:
    ...        session - the session for this robot
    ...        x1 - the X axis value of the 1st point
    ...        y1 - the Y axis value of the 1st point
    ...        x2 - the X axis value of the 2nd point
    ...        y2 - the Y axis value of the 2nd point
    ...        x3 - the X axis value of the 3rd point
    ...        y3 - the Y axis value of the 3rd point
    ...    Returns:
    ...        Returns the response of the robot's server.
    [Arguments]    ${session}    ${x1}    ${y1}    ${x2}    ${y2}    ${x3}    ${y3}
    &{draw_raw} =    Create Dictionary    x1=${x1}    y1=${y1}    x2=${x2}    y2=${y2}    x3=${x3}    y3=${y3}
    ${draw} =    json.dumps    ${draw_raw}
    ${response} =    Post Request    ${session}    ${ROBOT_URL_DRAW_TRIANGLE}    data=${draw}
    Wait    ${WAIT_TIME_BETWEEN_TAP}
    [Return]    ${response.text}

Draw spiral
    [Documentation]    Draws a spiral using a center point (x,y), n loops and an r radius
    ...    Parameters:
    ...        session - the session for this robot
    ...        x - the X axis value of the center point
    ...        y - the Y axis value of the center point
    ...        n - the number of loops to draw
    ...        r - the radius of the spiral
    ...    Returns:
    ...        Returns the response of the robot's server.
    [Arguments]    ${session}    ${x}    ${y}    ${n}    ${r}
    &{draw_raw} =    Create Dictionary    x=${x}    y=${y}    n=${n}    r=${r}
    ${draw} =    json.dumps    ${draw_raw}
    ${response} =    Post Request    ${session}    ${ROBOT_URL_DRAW_SPIRAL}    data=${draw}
    Wait    ${WAIT_TIME_BETWEEN_TAP}
    [Return]    ${response.text}
