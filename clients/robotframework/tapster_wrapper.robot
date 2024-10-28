# SPDX-FileCopyrightText: 2018 Orange SA
# SPDX-License-Identifier: BSD-2-Clause OR MIT

# File: tapster_wrapper.robot
# Brief: Robot Framework file providing feature to use so as to click on items with Tapster bot
# Version: 3.0.0
# Since: 29/05/2018

*** Settings ***

Documentation
...    Here are keywords so use to as to get widgets (through Appium) and click on them (with Tapster bot)

Library     AppiumLibrary

Resource    ./tapster_keywords.robot

*** Keywords ***

# ###############
# Useful keywords
# ###############

Tap To Point
    [Documentation]    Make a tap to a 2D point, using coodinates based on the 2D smartphone screen landmark.
    ...    Parameters:
    ...        x - the value in the X axis of the target point
    ...        y - the value in the Y axis of the target point
    ...        offset_x - optional, default valued to 0, an offset to apply to X axis for the contact
    ...        offset_y - optional, default valued to 0, an offset to apply to Y axis for the contact
    ...    Returns:
    ...        the results of the request send to the robot's server
    [Arguments]    ${x}    ${y}    ${offset_x}=0    ${offset_y}=0
    ${x} =    Evaluate    ${x}+${offset_x}
    ${y} =    Evaluate    ${y}+${offset_y}
    tapster_keywords.Create robot session    my_session
    ${response} =    tapster_keywords.Tap to point    my_session    ${x}    ${y}
    tapster_keywords.Delete robot session    my_session
    [Return]    ${response}

Tap To Element With Id
    [Documentation]    Make a tap to an element, in portrait mode, which has this id.
    ...    The contact point will be computed according to location and dimension of the widget.
    ...    Parameters:
    ...        id - the id of the target element
    ...        offset_x - optional, default valued to 0, an offset to apply to X axis for the contact
    ...        offset_y - optional, default valued to 0, an offset to apply to Y axis for the contact
    ...    Returns:
    ...        the results of the request send to the robot's server
    [Arguments]    ${id}    ${offset_x}=0    ${offset_y}=0
    ${x}    ${y} =    Get Suitable Contact Point For Widget With Id    ${id}
    ${x} =    Evaluate    ${x}+${offset_x}
    ${y} =    Evaluate    ${y}+${offset_y}
    tapster_keywords.Create robot session    my_session
    ${response} =    tapster_keywords.Tap to point    my_session    ${x}    ${y}
    tapster_keywords.Delete robot session    my_session
    [Return]    ${response}

Tap To Element With Text
    [Documentation]    Make a tap to an element, in portrait mode, which has this text.
    ...    The contact point will be computed according to location and dimension of the widget.
    ...    Parameters:
    ...        text - the text of the target element
    ...        offset_x - optional, default valued to 0, an offset to apply to X axis for the contact
    ...        offset_y - optional, default valued to 0, an offset to apply to Y axis for the contact
    ...    Returns:
    ...        the results of the request send to the robot's server
    [Arguments]    ${text}    ${offset_x}=0    ${offset_y}=0
    ${x}    ${y} =    Get Suitable Contact Point For Widget With Text    ${text}
    ${x} =    Evaluate    ${x}+${offset_x}
    ${y} =    Evaluate    ${y}+${offset_y}
    tapster_keywords.Create robot session    my_session
    ${response} =    tapster_keywords.Tap to point    my_session    ${x}    ${y}
    tapster_keywords.Delete robot session    my_session
    [Return]    ${response}

Tap To Element With Xpath
    [Documentation]    Make a tap to an element, in portrait mode, using this XPath locator.
    ...    The contact point will be computed according to location and dimension of the widget.
    ...    Parameters:
    ...        xpath_locator - the text of the target element
    ...        offset_x - optional, default valued to 0, an offset to apply to X axis for the contact
    ...        offset_y - optional, default valued to 0, an offset to apply to Y axis for the contact
    ...    Returns:
    ...        the results of the request send to the robot's server
    [Arguments]    ${xpath_locator}    ${offset_x}=0    ${offset_y}=0
    ${x}    ${y} =    Get Suitable Contact Point For Widget With Xpath    ${xpath_locator}
    ${x} =    Evaluate    ${x}+${offset_x}
    ${y} =    Evaluate    ${y}+${offset_y}
    tapster_keywords.Create robot session    my_session
    ${response} =    tapster_keywords.Tap to point    my_session    ${x}    ${y}
    tapster_keywords.Delete robot session    my_session
    [Return]    ${response}

Tap Somewhere To Element With Id
    [Documentation]    Tap somewhere onto the element with this id
    ...    The contact point will be computed according to location and dimension of the widget, using a random value.
    ...    If there are several widgets with this id, will keep the 1st.
    ...    Parameters:
    ...        id - the id of the target element
    ...        offset_x - optional, default valued to 0, an offset to apply to X axis for the contact
    ...        offset_y - optional, default valued to 0, an offset to apply to Y axis for the contact
    ...    Returns:
    ...        the results of the request send to the robot's server
    [Arguments]    ${id}    ${offset_x}=0    ${offset_y}=0
    ${x}    ${y} =    Get Random Contact Point For Widget With Id    ${id}
    ${x} =    Evaluate    ${x}+${offset_x}
    ${y} =    Evaluate    ${y}+${offset_y}
    tapster_keywords.Create robot session    my_session
    ${response} =    tapster_keywords.Tap to point    my_session    ${x}    ${y}
    tapster_keywords.Delete robot session    my_session
    [Return]    ${response}

Tap Somewhere To Element With Text
    [Documentation]    Tap somewhere onto the element with this text
    ...    The contact point will be computed according to location and dimension of the widget, using a random value.
    ...    If there are several widgets with this text, will keep the 1st.
    ...    Parameters:
    ...        text - the text of the target element
    ...        offset_x - optional, default valued to 0, an offset to apply to X axis for the contact
    ...        offset_y - optional, default valued to 0, an offset to apply to Y axis for the contact
    ...    Returns:
    ...        the results of the request send to the robot's server
    [Arguments]    ${text}    ${offset_x}=0    ${offset_y}=0
    ${x}    ${y} =    Get Random Contact Point For Widget With Text    ${text}
    ${x} =    Evaluate    ${x}+${offset_x}
    ${y} =    Evaluate    ${y}+${offset_y}
    tapster_keywords.Create robot session    my_session
    ${response} =    tapster_keywords.Tap to point    my_session    ${x}    ${y}
    tapster_keywords.Delete robot session    my_session
    [Return]    ${response}

Tap Somewhere To Element With Xpath
    [Documentation]    Tap somewhere onto the element using this XPath locator
    ...    The contact point will be computed according to location and dimension of the widget, using a random value.
    ...    If there are several widgets matching this XPath locator, will keep the 1st.
    ...    Parameters:
    ...        xpath_locator - the text of the target element
    ...        offset_x - optional, default valued to 0, an offset to apply to X axis for the contact
    ...        offset_y - optional, default valued to 0, an offset to apply to Y axis for the contact
    ...    Returns:
    ...        the results of the request send to the robot's server
    [Arguments]    ${xpath_locator}    ${offset_x}=0    ${offset_y}=0
    ${x}    ${y} =    Get Random Contact Point For Widget With Xpath    ${xpath_locator}
    ${x} =    Evaluate    ${x}+${offset_x}
    ${y} =    Evaluate    ${y}+${offset_y}
    tapster_keywords.Create robot session    my_session
    ${response} =    tapster_keywords.Tap to point    my_session    ${x}    ${y}
    tapster_keywords.Delete robot session    my_session
    [Return]    ${response}

Tap To Landscape Element With Text
    [Documentation]    Unstable! Keyword "Get Window Width" missing in AppiumLibrary
    #  Tap to an element, in landscape mode, which has this text.
    # The contact point will be computed according to location and dimension of the widget.
    # If there are several widgets with this text, will keep the 1st.
    [Arguments]    ${text}    ${offset_x}=0    ${offset_y}=0
    # Coordinates in landscape mode!
    ${x}    ${y} =    Get Suitable Contact Point For Widget With Id    ${id}
    # Robot does not care of orientation, need to convert to fake portrait mode
    ${screen_width} =    Get Window width # Does not work O_o, unknown keyword in AppiumLibrary!
    ${y} =    Evaluate    ${x}
    ${x} =    Evaluate    ${screen_width}-${y}
    tapster_keywords.Create robot session    my_session
    ${response} =    tapster_keywords.Tap to point    my_session    ${y}    ${x}
    tapster_keywords.Delete robot session    my_session
    [Return]    ${response}

Tap To Landscape Element With Id
    [Documentation]    Unstable! Keyword "Get Window Width" missing in AppiumLibrary
    # Tap to an element, in landscape mode, which has this id.
    # The contact point will be computed according to location and dimension of the widget.
    # If there are several widgets with this id, will keep the 1st.
    [Arguments]    ${id}    ${offset_x}=0    ${offset_y}=0
    # Coordinates in landscape mode!
    ${x}    ${y} =    Get Suitable Contact Point For Widget With Id    ${id}
    # Robot does not care of orientation, need to convert to fake portrait mode
    ${screen_width} =    Get Window width # Does not work O_o, unknown keyword in AppiumLibrary!
    ${y} =    Evaluate    ${x}
    ${x} =    Evaluate    ${screen_width}-${y}
    tapster_keywords.Create robot session    my_session
    ${response} =    tapster_keywords.Tap to point    my_session    ${y}    ${x}
    tapster_keywords.Delete robot session    my_session
    [Return]    ${response}

Tap To Element N Times With Id
    [Documentation]    Tap n times to the element with this id
    ...    The contact point will be computed according to location and dimension of the widget.
    ...    If there are several widgets with this id, will keep the 1st.
    ...    Parameters:
    ...        N - the number of times the tpa will be made
    ...        id - the id of the target element
    ...        offset_x - optional, default valued to 0, an offset to apply to X axis for the contact
    ...        offset_y - optional, default valued to 0, an offset to apply to Y axis for the contact
    ...    Returns:
    ...        the results of the request send to the robot's server
    [Arguments]    ${N}    ${id}    ${offset_x}=0    ${offset_y}=0
    ${x}    ${y} =    Get Suitable Contact Point For Widget With Id    ${id}
    ${x} =    Evaluate    ${x}+${offset_x}
    ${y} =    Evaluate    ${y}+${offset_y}
    tapster_keywords.Create robot session    my_session
    ${response} =    tapster_keywords.Tap n times    my_session    ${N}    ${x}    ${y}
    tapster_keywords.Delete robot session    my_session
    [Return]    ${response}

Tap To Element N Times With Text
    [Documentation]    Tap n times to this element with this text
    ...    The contact point will be computed according to location and dimension of the widget.
    ...    If there are several widgets with this id, will keep the 1st.
    ...    Parameters:
    ...        N - the number of times the tpa will be made
    ...        text - the text of the target element
    ...        offset_x - optional, default valued to 0, an offset to apply to X axis for the contact
    ...        offset_y - optional, default valued to 0, an offset to apply to Y axis for the contact
    ...    Returns:
    ...        the results of the request send to the robot's server
    [Arguments]    ${N}    ${text}    ${offset_x}=0    ${offset_y}=0
    ${x}    ${y} =    Get Suitable Contact Point For Widget With Text    ${text}
    ${x} =    Evaluate    ${x}+${offset_x}
    ${y} =    Evaluate    ${y}+${offset_y}
    tapster_keywords.Create robot session    my_session
    ${response} =    tapster_keywords.Tap n times    my_session    ${N}    ${x}    ${y}
    tapster_keywords.Delete robot session    my_session
    [Return]    ${response}

Tap To Element N Times With XPath
    [Documentation]    Tap n times to this element with this XPath locator
    ...    The contact point will be computed according to location and dimension of the widget.
    ...    If there are several widgets with this id, will keep the 1st.
    ...    Parameters:
    ...        N - the number of times the tpa will be made
    ...        xpath_locator - the XPath lcoator to use to get and tap on the element
    ...        offset_x - optional, default valued to 0, an offset to apply to X axis for the contact
    ...        offset_y - optional, default valued to 0, an offset to apply to Y axis for the contact
    ...    Returns:
    ...        the results of the request send to the robot's server
    [Arguments]    ${N}    ${xpath_locator}    ${offset_x}=0    ${offset_y}=0
    ${x}    ${y} =    Get Suitable Contact Point For Widget With Xpath    ${xpath_locator}
    ${x} =    Evaluate    ${x}+${offset_x}
    ${y} =    Evaluate    ${y}+${offset_y}
    tapster_keywords.Create robot session    my_session
    ${response} =    tapster_keywords.Tap n times    my_session    ${N}    ${x}    ${y}
    tapster_keywords.Delete robot session    my_session
    [Return]    ${response}

Long Tap To Point
    [Documentation]    Make a long tap to a point
    ...    Use coordinates based on the 2D device screen landmark.
    ...    Parameters:
    ...        x - the value on the X axis of the target point
    ...        y - the value on the Y axis of the target point
    ...        duration - optional, default valued to DEFAULT_DURATION_LONG_TAP, duration of the contact
    ...        offset_x - optional, default valued to 0, an offset to apply to X axis for the contact
    ...        offset_y - optional, default valued to 0, an offset to apply to Y axis for the contact
    ...    Returns:
    ...        the results of the request send to the robot's server
    [Arguments]    ${x}    ${y}    ${duration}=${DEFAULT_DURATION_LONG_TAP}    ${offset_x}=0    ${offset_y}=0
    ${x} =    Evaluate    ${x}+${offset_x}
    ${y} =    Evaluate    ${y}+${offset_y}
    tapster_keywords.Create robot session    my_session
    ${response} =    tapster_keywords.Long tap to point    my_session    ${x}    ${y}    ${duration}
    tapster_keywords.Delete robot session    my_session
    [Return]    ${response}

Long Tap To Element With Id
    [Documentation]    Make a long tap to an element, in portrait mode, which has this id.
    ...    The contact point will be computed according to location and dimension of the widget.
    ...    If there are several widgets with this id, will keep the 1st.
    ...    The duration is by default ${DEFAULT_DURATION_LONG_TAP} (in ms)
    ...    Parameters:
    ...        id - the id of the element to tap on
    ...        duration - optional, default valued to DEFAULT_DURATION_LONG_TAP, duration of the contact
    ...        offset_x - optional, default valued to 0, an offset to apply to X axis for the contact
    ...        offset_y - optional, default valued to 0, an offset to apply to Y axis for the contact
    ...    Returns:
    ...        the results of the request send to the robot's server
    [Arguments]    ${id}    ${duration}=${DEFAULT_DURATION_LONG_TAP}    ${offset_x}=0    ${offset_y}=0
    ${x}    ${y} =    Get Suitable Contact Point For Widget With Id    ${id}
    ${x} =    Evaluate    ${x}+${offset_x}
    ${y} =    Evaluate    ${y}+${offset_y}
    tapster_keywords.Create robot session    my_session
    ${response} =    tapster_keywords.Long tap to point    my_session    ${x}    ${y}    ${duration}
    tapster_keywords.Delete robot session    my_session
    [Return]    ${response}

Long Tap To Element With Text
        [Documentation]    Make a long tap to an element, in portrait mode, which has this text.
    ...    The contact point will be computed according to location and dimension of the widget.
    ...    If there are several widgets with this text, will keep the 1st.
    ...    The duration is by default ${DEFAULT_DURATION_LONG_TAP} (in ms)
    ...    Parameters:
    ...        text - the text of the element to tap on
    ...        duration - optional, default valued to DEFAULT_DURATION_LONG_TAP, duration of the contact
    ...        offset_x - optional, default valued to 0, an offset to apply to X axis for the contact
    ...        offset_y - optional, default valued to 0, an offset to apply to Y axis for the contact
    ...    Returns:
    ...        the results of the request send to the robot's server
    [Arguments]    ${text}    ${duration}=${DEFAULT_DURATION_LONG_TAP}    ${offset_x}=0    ${offset_y}=0
    ${x}    ${y} =    Get Suitable Contact Point For Widget With Text    ${text}
    ${x} =    Evaluate    ${x}+${offset_x}
    ${y} =    Evaluate    ${y}+${offset_y}
    tapster_keywords.Create robot session    my_session
    ${response} =    tapster_keywords.Long tap to point    my_session    ${x}    ${y}    ${duration}
    tapster_keywords.Delete robot session    my_session
    [Return]    ${response}

Long Tap To Element With Xpath
    [Documentation]    Make a long tap to an element, in portrait mode, with this XPath locator
    ...    The contact point will be computed according to location and dimension of the widget.
    ...    If several widgets match with this locator, will keep the 1st.
    ...    The duration is by default ${DEFAULT_DURATION_LONG_TAP} (in ms)
    ...    Parameters:
    ...        xpath_locator - the XPath locator to use to select the item to tap on
    ...        duration - optional, default valued to DEFAULT_DURATION_LONG_TAP, duration of the contact
    ...        offset_x - optional, default valued to 0, an offset to apply to X axis for the contact
    ...        offset_y - optional, default valued to 0, an offset to apply to Y axis for the contact
    ...    Returns:
    ...        the results of the request send to the robot's server
    [Arguments]    ${xpath_locator}    ${duration}=${DEFAULT_DURATION_LONG_TAP}    ${offset_x}=0    ${offset_y}=0
    ${x}    ${y} =    Get Suitable Contact Point For Widget With Xpath    ${xpath_locator}
    ${x} =    Evaluate    ${x}+${offset_x}
    ${y} =    Evaluate    ${y}+${offset_y}
    tapster_keywords.Create robot session    my_session
    ${response} =    tapster_keywords.Long tap to point    my_session    ${x}    ${y}    ${duration}
    tapster_keywords.Delete robot session    my_session
    [Return]    ${response}

Double Tap To Point
    [Documentation]    Make a double tap to a point
    ...    Use coordinates based on the 2D device screen landmark.
    ...    Parameters:
    ...        x - the value on the X axis of the target point
    ...        y - the value on the Y axis of the target point
    ...        duration - optional, default valued to DEFAULT_DURATION_LONG_TAP, duration of the contact
    ...        offset_x - optional, default valued to 0, an offset to apply to X axis for the contact
    ...        offset_y - optional, default valued to 0, an offset to apply to Y axis for the contact
    ...    Returns:
    ...        the results of the request send to the robot's server
    [Arguments]    ${x}    ${y}    ${duration}=${DEFAULT_DURATION_LONG_TAP}    ${offset_x}=0    ${offset_y}=0
    ${x} =    Evaluate    ${x}+${offset_x}
    ${y} =    Evaluate    ${y}+${offset_y}
    tapster_keywords.Create robot session    my_session
    ${response} =    tapster_keywords.Double tap to point    my_session    ${x}    ${y}    ${duration}
    tapster_keywords.Delete robot session    my_session
    [Return]    ${response}

Double Tap To Element With Id
    [Documentation]    Make a double tap to an element, in portrait mode, which has this id.
    ...    The contact point will be computed according to location and dimension of the widget.
    ...    The duration is by default ${DEFAULT_DURATION_MULTI_TAP} (in ms)
    ...    Parameters:
    ...        id - the id of the target element
    ...        duration - optional, default valued to DEFAULT_DURATION_MULTI_TAP, duration of the contact
    ...        offset_x - optional, default valued to 0, an offset to apply to X axis for the contact
    ...        offset_y - optional, default valued to 0, an offset to apply to Y axis for the contact
    ...    Returns:
    ...        the results of the request send to the robot's server
    [Arguments]    ${id}    ${duration}=${DEFAULT_DURATION_MULTI_TAP}    ${offset_x}=0    ${offset_y}=0
    ${x}    ${y} =    Get Suitable Contact Point For Widget With Id    ${id}
    ${x} =    Evaluate    ${x}+${offset_x}
    ${y} =    Evaluate    ${y}+${offset_y}
    tapster_keywords.Create robot session    my_session
    ${response} =    tapster_keywords.Double tap to point    my_session    ${x}    ${y}    ${duration}
    tapster_keywords.Delete robot session    my_session
    [Return]    ${response}

Double Tap To Element With Text
    [Documentation]    Make a double tap to an element, in portrait mode, which has this text.
    ...    The contact point will be computed according to location and dimension of the widget.
    ...    The duration is by default ${DEFAULT_DURATION_MULTI_TAP} (in ms)
    ...    Parameters:
    ...        text - the text of the target element
    ...        duration - optional, default valued to DEFAULT_DURATION_MULTI_TAP, duration of the contact
    ...        offset_x - optional, default valued to 0, an offset to apply to X axis for the contact
    ...        offset_y - optional, default valued to 0, an offset to apply to Y axis for the contact
    ...    Returns:
    ...        the results of the request send to the robot's server
    [Arguments]    ${text}    ${duration}=${DEFAULT_DURATION_MULTI_TAP}    ${offset_x}=0    ${offset_y}=0
    ${x}    ${y} =    Get Suitable Contact Point For Widget With Text    ${text}
    ${x} =    Evaluate    ${x}+${offset_x}
    ${y} =    Evaluate    ${y}+${offset_y}
    tapster_keywords.Create robot session    my_session
    ${response} =    tapster_keywords.Double tap to point    my_session    ${x}    ${y}    ${duration}
    tapster_keywords.Delete robot session    my_session
    [Return]    ${response}

Double Tap To Element With Xpath
    [Documentation]    Make a double tap to an element, in portrait mode, using this XPath locator
    ...    The contact point will be computed according to location and dimension of the widget.
    ...    The duration is by default ${DEFAULT_DURATION_MULTI_TAP} (in ms)
    ...    Parameters:
    ...        xpath_locator - the XPath locator to find the element
    ...        duration - optional, default valued to DEFAULT_DURATION_MULTI_TAP, duration of the contact
    ...        offset_x - optional, default valued to 0, an offset to apply to X axis for the contact
    ...        offset_y - optional, default valued to 0, an offset to apply to Y axis for the contact
    ...    Returns:
    ...        the results of the request send to the robot's server
    [Arguments]    ${xpath_locator}    ${duration}=${DEFAULT_DURATION_MULTI_TAP}    ${offset_x}=0    ${offset_y}=0
    ${x}    ${y} =    Get Suitable Contact Point For Widget With Xpath    ${xpath_locator}
    ${x} =    Evaluate    ${x}+${offset_x}
    ${y} =    Evaluate    ${y}+${offset_y}
    tapster_keywords.Create robot session    my_session
    ${response} =    tapster_keywords.Double tap to point    my_session    ${x}    ${y}    ${duration}
    tapster_keywords.Delete robot session    my_session
    [Return]    ${response}

Triple Tap To Point
    [Documentation]    Make a triple tap to a point.
    ...    Coordinates in use are based on the 2D device screen landmark.
    ...    The duration is by default ${DEFAULT_DURATION_MULTI_TAP} (in ms)
    ...    Parameters:
    ...        x - the value on the X axis of the target point
    ...        y - the value on the Y axis of the target point
    ...        duration - optional, default valued to DEFAULT_DURATION_MULTI_TAP, duration of the contact
    ...        offset_x - optional, default valued to 0, an offset to apply to X axis for the contact
    ...        offset_y - optional, default valued to 0, an offset to apply to Y axis for the contact
    ...    Returns:
    ...        the results of the request send to the robot's server
    [Arguments]    ${x}    ${y}    ${duration}=${DEFAULT_DURATION_MULTI_TAP}    ${offset_x}=0    ${offset_y}=0
    ${x} =    Evaluate    ${x}+${offset_x}
    ${y} =    Evaluate    ${y}+${offset_y}
    tapster_keywords.Create robot session    my_session
    ${response} =    tapster_keywords.Triple tap to point    my_session    ${x}    ${y}    ${duration}
    tapster_keywords.Delete robot session    my_session
    [Return]    ${response}

Triple Tap To Element With Id
    [Documentation]    Make a triple tap to an element, in portrait mode, which has this id.
    ...    The contact point will be computed according to location and dimension of the widget.
    ...    The duration is by default ${DEFAULT_DURATION_MULTI_TAP} (in ms)
    ...    Parameters:
    ...        id - the id of the target element
    ...        duration - optional, default valued to DEFAULT_DURATION_MULTI_TAP, duration of the contact
    ...        offset_x - optional, default valued to 0, an offset to apply to X axis for the contact
    ...        offset_y - optional, default valued to 0, an offset to apply to Y axis for the contact
    ...    Returns:
    ...        the results of the request send to the robot's server
    [Arguments]    ${id}    ${duration}=${DEFAULT_DURATION_MULTI_TAP}    ${offset_x}=0    ${offset_y}=0
    ${x}    ${y} =    Get Suitable Contact Point For Widget With Id    ${id}
    ${x} =    Evaluate    ${x}+${offset_x}
    ${y} =    Evaluate    ${y}+${offset_y}
    tapster_keywords.Create robot session    my_session
    ${response} =    tapster_keywords.Triple tap to point    my_session    ${x}    ${y}    ${duration}
    tapster_keywords.Delete robot session    my_session
    [Return]    ${response}

Triple Tap To Element With Text
    [Documentation]    Make a triple tap to an element, in portrait mode, which has this text.
    ...    The contact point will be computed according to location and dimension of the widget.
    ...    The duration is by default ${DEFAULT_DURATION_MULTI_TAP} (in ms)
    ...    Parameters:
    ...        xpath_locator - the XPath lcoator tor each the element and tap on it
    ...        duration - optional, default valued to DEFAULT_DURATION_MULTI_TAP, duration of the contact
    ...        offset_x - optional, default valued to 0, an offset to apply to X axis for the contact
    ...        offset_y - optional, default valued to 0, an offset to apply to Y axis for the contact
    ...    Returns:
    ...        the results of the request send to the robot's server
    [Arguments]    ${xpath_locator}    ${duration}=${DEFAULT_DURATION_MULTI_TAP}    ${offset_x}=0    ${offset_y}=0
    ${x}    ${y} =    Get Suitable Contact Point For Widget With Text    ${text}
    ${x} =    Evaluate    ${x}+${offset_x}
    ${y} =    Evaluate    ${y}+${offset_y}
    tapster_keywords.Create robot session    my_session
    ${response} =    tapster_keywords.Triple tap to point    my_session    ${x}    ${y}    ${duration}
    tapster_keywords.Delete robot session    my_session
    [Return]    ${response}

Triple Tap To Element With Xpath
    [Documentation]    Make a triple tap to an element, in portrait mode, using this XPath locator
    ...    The contact point will be computed according to location and dimension of the widget.
    ...    The duration is by default ${DEFAULT_DURATION_MULTI_TAP} (in ms)
    ...    Parameters:
    ...        xpath_locator - the locator to use to get the target element
    ...        duration - optional, default valued to DEFAULT_DURATION_MULTI_TAP, duration of the contact
    ...        offset_x - optional, default valued to 0, an offset to apply to X axis for the contact
    ...        offset_y - optional, default valued to 0, an offset to apply to Y axis for the contact
    ...    Returns:
    ...        the results of the request send to the robot's server
    [Arguments]    ${xpath_locator}    ${duration}=${DEFAULT_DURATION_MULTI_TAP}    ${offset_x}=0    ${offset_y}=0
    ${x}    ${y} =    Get Suitable Contact Point For Widget With Xpath    ${xpath_locator}
    ${x} =    Evaluate    ${x}+${offset_x}
    ${y} =    Evaluate    ${y}+${offset_y}
    tapster_keywords.Create robot session    my_session
    ${response} =    tapster_keywords.Triple tap to point    my_session    ${x}    ${y}    ${duration}
    tapster_keywords.Delete robot session    my_session
    [Return]    ${response}

Stresstap To Element With Id
    [Documentation]    Tap n times very quickly to this element with this id
    ...    The contact point will be computed according to location and dimension of the widget.
    ...    If there are several widgets with this id, will keep the 1st.
    ...    Parameters:
    ...        N - the number of times the tap will be made
    ...        id - the id of the target element
    ...        offset_x - optional, default valued to 0, an offset to apply to X axis for the contact
    ...        offset_y - optional, default valued to 0, an offset to apply to Y axis for the contact
    ...    Returns:
    ...        the results of the request send to the robot's server
    [Arguments]    ${N}    ${id}    ${offset_x}=0    ${offset_y}=0
    ${x}    ${y} =    Get Suitable Contact Point For Widget With Id    ${id}
    ${x} =    Evaluate    ${x}+${offset_x}
    ${y} =    Evaluate    ${y}+${offset_y}
    tapster_keywords.Create robot session    my_session
    ${response} =    tapster_keywords.Stress taps    my_session    ${N}    ${x}    ${y}
    tapster_keywords.Delete robot session    my_session
    [Return]    ${response}

Stresstap To Element With Text
    [Documentation]    Tap n times very quickly to this element with this text
    ...    The contact point will be computed according to location and dimension of the widget.
    ...    If there are several widgets with this id, will keep the 1st.
    ...    Parameters:
    ...        N - the number of times the tap will be made
    ...        text - the text of the target element
    ...        offset_x - optional, default valued to 0, an offset to apply to X axis for the contact
    ...        offset_y - optional, default valued to 0, an offset to apply to Y axis for the contact
    ...    Returns:
    ...        the results of the request send to the robot's server
    [Arguments]    ${N}    ${text}    ${offset_x}=0    ${offset_y}=0
    ${x}    ${y} =    Get Suitable Contact Point For Widget With Text    ${text}
    ${x} =    Evaluate    ${x}+${offset_x}
    ${y} =    Evaluate    ${y}+${offset_y}
    tapster_keywords.Create robot session    my_session
    ${response} =    tapster_keywords.Stress taps    my_session    ${N}    ${x}    ${y}
    tapster_keywords.Delete robot session    my_session
    [Return]    ${response}

Stresstap To Element With XPath
    [Documentation]    Tap n times very quickly to this element with this XPath locator
    ...    The contact point will be computed according to location and dimension of the widget.
    ...    If there are several widgets with this id, will keep the 1st.
    ...    Parameters:
    ...        N - the number of times the tap will be made
    ...        xpath_locator - the XPath lcoator to use to reach the element and tap on it
    ...        offset_x - optional, default valued to 0, an offset to apply to X axis for the contact
    ...        offset_y - optional, default valued to 0, an offset to apply to Y axis for the contact
    ...    Returns:
    ...        the results of the request send to the robot's server
    [Arguments]    ${N}    ${xpath_locator}    ${offset_x}=0    ${offset_y}=0
    ${x}    ${y} =    Get Suitable Contact Point For Widget With Xpath    ${xpath_locator}
    ${x} =    Evaluate    ${x}+${offset_x}
    ${y} =    Evaluate    ${y}+${offset_y}
    tapster_keywords.Create robot session    my_session
    ${response} =    tapster_keywords.Stress taps    my_session    ${N}    ${x}    ${y}
    tapster_keywords.Delete robot session    my_session
    [Return]    ${response}

Swipe
    [Documentation]    Swipe one time from (a,b) to (c,d) points
    ...    Parameters:
    ...        a - the X value of the start point
    ...        b - the Y value of the start point
    ...        c - the X value of the end point
    ...        d - the Y value of the end point
    ...        offset_x - optional, default valued to 0, an offset to apply to X axis for the contact
    ...        offset_y - optional, default valued to 0, an offset to apply to Y axis for the contact
    ...    Returns:
    ...        the results of the request send to the robot's server
    [Arguments]    ${a}    ${b}    ${c}    ${d}    ${offset_x}=0    ${offset_y}=0
    ${new_a} =    Evaluate    ${a}+${offset_x}
    ${new_b} =    Evaluate    ${b}+${offset_y}
    ${new_c} =    Evaluate    ${c}+${offset_x}
    ${new_d} =    Evaluate    ${d}+${offset_y}
    tapster_keywords.Create robot session    my_session
    ${response} =    tapster_keywords.Swipe    my_session    ${new_a}    ${new_b}    ${new_c}    ${new_d}
    tapster_keywords.Delete robot session    my_session
    [Return]    ${response}

Swipe Using Elements Id
    [Documentation]    Swipe from an element to another using their id
    ...    Parameters:
    ...        source_id - id of the start element
    ...        destination_id - id of the end element
    ...        offset_x - optional, default valued to 0, an offset to apply to X axis for the contact
    ...        offset_y - optional, default valued to 0, an offset to apply to Y axis for the contact
    ...    Returns:
    ...        the results of the request send to the robot's server
    [Arguments]    ${source_id}    ${destination_id}    ${offset_x}=0    ${offset_y}=0
    ${source_x}    ${source_y} =    Get Suitable Contact Point For Widget With Id    ${source_id}
    ${source_x} =    Evaluate    ${source_x}+${offset_x}
    ${source_y} =    Evaluate    ${source_y}+${offset_y}
    ${destination_x}    ${destination_y} =    Get Suitable Contact Point For Widget With Id    ${destination_id}
    ${destination_x} =    Evaluate    ${destination_x}+${offset_x}
    ${destination_y} =    Evaluate    ${destination_y}+${offset_y}
    tapster_keywords.Create robot session    my_session
    ${response} =    tapster_keywords.Swipe    my_session    ${source_x}    ${source_y}    ${destination_x}    ${destination_y}
    tapster_keywords.Delete robot session    my_session
    [Return]    ${response}

Swipe Using Elements Text
    [Documentation]    Swipe from an element to another using their texts
    ...    Parameters:
    ...        source_text - text of the start element
    ...        destination_text - text of the end element
    ...        offset_x - optional, default valued to 0, an offset to apply to X axis for the contact
    ...        offset_y - optional, default valued to 0, an offset to apply to Y axis for the contact
    ...    Returns:
    ...        the results of the request send to the robot's server
    [Arguments]    ${source_text}    ${destination_text}    ${offset_x}=0    ${offset_y}=0
    ${source_x}    ${source_y} =    Get Suitable Contact Point For Widget With Text    ${source_text}
    ${source_x} =    Evaluate    ${source_x}+${offset_x}
    ${source_y} =    Evaluate    ${source_y}+${offset_y}
    ${destination_x}    ${destination_y} =    Get Suitable Contact Point For Widget With Text    ${destination_text}
    ${destination_x} =    Evaluate    ${destination_x}+${offset_x}
    ${destination_y} =    Evaluate    ${destination_y}+${offset_y}
    tapster_keywords.Create robot session    my_session
    ${response} =    tapster_keywords.Swipe    my_session    ${source_x}    ${source_y}    ${destination_x}    ${destination_y}
    tapster_keywords.Delete robot session    my_session
    [Return]    ${response}

Swipe Using Elements Xpath
     [Documentation]    Swipe from an element to another using XPath locators
    ...    Parameters:
    ...        source_xpath - XPath locator to find the start element
    ...        destination_xpath - XPath lcoator to find the end element
    ...        offset_x - optional, default valued to 0, an offset to apply to X axis for the contact
    ...        offset_y - optional, default valued to 0, an offset to apply to Y axis for the contact
    ...    Returns:
    ...        the results of the request send to the robot's server
    [Arguments]    ${source_xpath}    ${destination_xpath}    ${offset_x}=0    ${offset_y}=0
    ${source_x}    ${source_y} =    Get Suitable Contact Point For Widget With Xpath    ${source_xpath}
    ${source_x} =    Evaluate    ${source_x}+${offset_x}
    ${source_y} =    Evaluate    ${source_y}+${offset_y}
    ${destination_x}    ${destination_y} =    Get Suitable Contact Point For Widget With Xpath    ${destination_xpath}
    ${destination_x} =    Evaluate    ${destination_x}+${offset_x}
    ${destination_y} =    Evaluate    ${destination_y}+${offset_y}
    tapster_keywords.Create robot session    my_session
    ${response} =    tapster_keywords.Swipe    my_session    ${source_x}    ${source_y}    ${destination_x}    ${destination_y}
    tapster_keywords.Delete robot session    my_session
    [Return]    ${response}

Swipe N Times
    [Documentation]    Swipe N times from (a,b) to (c,d) points
    ...    Parameters:
    ...        N - the number of swipes wich will be made
    ...        a - the X value of the start point
    ...        b - the Y value of the start point
    ...        c - the X value of the end point
    ...        d - the Y value of the end point
    ...        offset_x - optional, default valued to 0, an offset to apply to X axis for the contact
    ...        offset_y - optional, default valued to 0, an offset to apply to Y axis for the contact
    ...    Returns:
    ...        the results of the request send to the robot's server
    [Arguments]    ${N}    ${a}    ${b}    ${c}    ${d}    ${offset_x}=0    ${offset_y}=0
    ${new_a} =    Evaluate    ${a}+${offset_x}
    ${new_b} =    Evaluate    ${b}+${offset_y}
    ${new_c} =    Evaluate    ${c}+${offset_x}
    ${new_d} =    Evaluate    ${d}+${offset_y}
    tapster_keywords.Create robot session    my_session
    ${response} =    tapster_keywords.Swipe n times    my_session    ${N}    ${new_a}    ${new_b}    ${new_c}    ${new_d}
    tapster_keywords.Delete robot session    my_session
    [Return]    ${response}

Swipe N Times Using Elements Id
    [Documentation]    Swipe from an element to another using their id, n times
    ...    Parameters:
    ...        N - the number of times the swipes will be made
    ...        source_id - id of the start element
    ...        destination_id - id of the end element
    ...        offset_x - optional, default valued to 0, an offset to apply to X axis for the contact
    ...        offset_y - optional, default valued to 0, an offset to apply to Y axis for the contact
    ...    Returns:
    ...        the results of the request send to the robot's server
    [Arguments]    ${N}    ${source_id}    ${destination_id}    ${offset_x}=0    ${offset_y}=0
    ${source_x}    ${source_y} =    Get Suitable Contact Point For Widget With Id    ${source_id}
    ${source_x} =    Evaluate    ${source_x}+${offset_x}
    ${source_y} =    Evaluate    ${source_y}+${offset_y}
    ${destination_x}    ${destination_y} =    Get Suitable Contact Point For Widget With Id    ${destination_id}
    ${destination_x} =    Evaluate    ${destination_x}+${offset_x}
    ${destination_y} =    Evaluate    ${destination_y}+${offset_y}
    tapster_keywords.Create robot session    my_session
    ${response} =    tapster_keywords.Swipe n times    my_session    ${N}    ${source_x}    ${source_y}    ${destination_x}    ${destination_y}
    tapster_keywords.Delete robot session    my_session
    [Return]    ${response}

Swipe N Times Using Elements Text
    [Documentation]    Swipe from an element to another using their text contents, n times
    ...    Parameters:
    ...        N - the number of times the swipes will be made
    ...        source_text - text of the start element
    ...        destination_text - text of the end element
    ...        offset_x - optional, default valued to 0, an offset to apply to X axis for the contact
    ...        offset_y - optional, default valued to 0, an offset to apply to Y axis for the contact
    ...    Returns:
    ...        the results of the request send to the robot's server
    [Arguments]    ${N}    ${source_text}    ${destination_text}    ${offset_x}=0    ${offset_y}=0
    ${source_x}    ${source_y} =    Get Suitable Contact Point For Widget With Text    ${source_text}
    ${source_x} =    Evaluate    ${source_x}+${offset_x}
    ${source_y} =    Evaluate    ${source_y}+${offset_y}
    ${destination_x}    ${destination_y} =    Get Suitable Contact Point For Widget With Text    ${destination_text}
    ${destination_x} =    Evaluate    ${destination_x}+${offset_x}
    ${destination_y} =    Evaluate    ${destination_y}+${offset_y}
    tapster_keywords.Create robot session    my_session
    ${response} =    tapster_keywords.Swipe n times    my_session    ${N}    ${source_x}    ${source_y}    ${destination_x}    ${destination_y}
    tapster_keywords.Delete robot session    my_session
    [Return]    ${response}

Swipe N Times Using Elements Xpath
    [Documentation]    Swipe from an element to another using XPath locators, n times
    ...    Parameters:
    ...        N - the number of times the swipes will be made
    ...        source_xpath - XPath locator to get the start element
    ...        destination_xpath - XPath locator to get the end element
    ...        offset_x - optional, default valued to 0, an offset to apply to X axis for the contact
    ...        offset_y - optional, default valued to 0, an offset to apply to Y axis for the contact
    ...    Returns:
    ...        the results of the request send to the robot's server
    [Arguments]    ${N}    ${source_xpath}    ${destination_xpath}    ${offset_x}=0    ${offset_y}=0
    ${source_x}    ${source_y} =    Get Suitable Contact Point For Widget With Xpath    ${source_xpath}
    ${source_x} =    Evaluate    ${source_x}+${offset_x}
    ${source_y} =    Evaluate    ${source_y}+${offset_y}
    ${destination_x}    ${destination_y} =    Get Suitable Contact Point For Widget With Xpath    ${destination_xpath}
    ${destination_x} =    Evaluate    ${destination_x}+${offset_x}
    ${destination_y} =    Evaluate    ${destination_y}+${offset_y}
    tapster_keywords.Create robot session    my_session
    ${response} =    tapster_keywords.Swipe n times    my_session    ${N}    ${source_x}    ${source_y}    ${destination_x}    ${destination_y}
    tapster_keywords.Delete robot session    my_session
    [Return]    ${response}

Stress Swipes
    [Documentation]    Swipe N times from (a,b) to (c,d) points very quickly
    ...    Parameters:
    ...        N - the number of swipes wich will be made
    ...        a - the X value of the start point
    ...        b - the Y value of the start point
    ...        c - the X value of the end point
    ...        d - the Y value of the end point
    ...        offset_x - optional, default valued to 0, an offset to apply to X axis for the contact
    ...        offset_y - optional, default valued to 0, an offset to apply to Y axis for the contact
    ...    Returns:
    ...        the results of the request send to the robot's server
    [Arguments]    ${N}    ${a}    ${b}    ${c}    ${d}    ${offset_x}=0    ${offset_y}=0
    ${new_a} =    Evaluate    ${a}+${offset_x}
    ${new_b} =    Evaluate    ${b}+${offset_y}
    ${new_c} =    Evaluate    ${c}+${offset_x}
    ${new_d} =    Evaluate    ${d}+${offset_y}
    tapster_keywords.Create robot session    my_session
    ${response} =    tapster_keywords.Stress swipes    my_session    ${N}    ${new_a}    ${new_b}    ${new_c}    ${new_d}
    tapster_keywords.Delete robot session    my_session
    [Return]    ${response}

Stress Swipes Using Elements Id
    [Documentation]    Swipe from an element to another using their id several times very quickly
    ...    Parameters:
    ...        N - the number of swipes to process
    ...        source_id - id of the start element
    ...        destination_id - id of the end element
    ...        offset_x - optional, default valued to 0, an offset to apply to X axis for the contact
    ...        offset_y - optional, default valued to 0, an offset to apply to Y axis for the contact
    ...    Returns:
    ...        the results of the request send to the robot's server
    [Arguments]    ${N}    ${source_id}    ${destination_id}    ${offset_x}=0    ${offset_y}=0
    ${source_x}    ${source_y} =    Get Suitable Contact Point For Widget With Id    ${source_id}
    ${source_x} =    Evaluate    ${source_x}+${offset_x}
    ${source_y} =    Evaluate    ${source_y}+${offset_y}
    ${destination_x}    ${destination_y} =    Get Suitable Contact Point For Widget With Id    ${destination_id}
    ${destination_x} =    Evaluate    ${destination_x}+${offset_x}
    ${destination_y} =    Evaluate    ${destination_y}+${offset_y}
    tapster_keywords.Create robot session    my_session
    ${response} =    tapster_keywords.Stress swipes    my_session    ${N}    ${source_x}    ${source_y}    ${destination_x}    ${destination_y}
    tapster_keywords.Delete robot session    my_session
    [Return]    ${response}

Stress Swipes Using Elements Text
    [Documentation]    Swipe from an element to another using their texts values several times very quickly
    ...    Parameters:
    ...        N - the number of swipes to process
    ...        source_text - text of the start element
    ...        destination_text - text of the end element
    ...        offset_x - optional, default valued to 0, an offset to apply to X axis for the contact
    ...        offset_y - optional, default valued to 0, an offset to apply to Y axis for the contact
    ...    Returns:
    ...        the results of the request send to the robot's server
    [Arguments]    ${N}    ${source_text}    ${destination_text}    ${offset_x}=0    ${offset_y}=0
    ${source_x}    ${source_y} =    Get Suitable Contact Point For Widget With Text    ${source_text}
    ${source_x} =    Evaluate    ${source_x}+${offset_x}
    ${source_y} =    Evaluate    ${source_y}+${offset_y}
    ${destination_x}    ${destination_y} =    Get Suitable Contact Point For Widget With Id    ${destination_text}
    ${destination_x} =    Evaluate    ${destination_x}+${offset_x}
    ${destination_y} =    Evaluate    ${destination_y}+${offset_y}
    tapster_keywords.Create robot session    my_session
    ${response} =    tapster_keywords.Stress swipes    my_session    ${N}    ${source_x}    ${source_y}    ${destination_x}    ${destination_y}
    tapster_keywords.Delete robot session    my_session
    [Return]    ${response}

Stress Swipes Using Elements Xpath
    [Documentation]    Swipe from an element to another several times very quickly using XPath locators to find the elements to use
    ...    Parameters:
    ...        N - the number of swipes to process
    ...        source_xpath - XPath lcoator of the start element
    ...        destination_xpath - XPath lcoator of the end element
    ...        offset_x - optional, default valued to 0, an offset to apply to X axis for the contact
    ...        offset_y - optional, default valued to 0, an offset to apply to Y axis for the contact
    ...    Returns:
    ...        the results of the request send to the robot's server
    [Arguments]    ${N}    ${source_xpath}    ${destination_xpath}    ${offset_x}=0    ${offset_y}=0
    ${source_x}    ${source_y} =    Get Suitable Contact Point For Widget With Text    ${source_xpath}
    ${source_x} =    Evaluate    ${source_x}+${offset_x}
    ${source_y} =    Evaluate    ${source_y}+${offset_y}
    ${destination_x}    ${destination_y} =    Get Suitable Contact Point For Widget With Id    ${destination_xpath}
    ${destination_x} =    Evaluate    ${destination_x}+${offset_x}
    ${destination_y} =    Evaluate    ${destination_y}+${offset_y}
    tapster_keywords.Create robot session    my_session
    ${response} =    tapster_keywords.Stress swipes    my_session    ${N}    ${source_x}    ${source_y}    ${destination_x}    ${destination_y}
    tapster_keywords.Delete robot session    my_session
    [Return]    ${response}

Draw Random Pattern
    [Documentation]    Draws a random pattern on the screen, using strokes
    ...    Parameters:
    ...        n - the number of anchor points, definition positions of the (n-1) strokes
    ...        startX - the minimal value for width, in X axis
    ...        startY - the minimal value for height, in Y axis
    ...        endX - the maximal value for width, in X axis
    ...        endY - the maximal value for height, in Y axis
    ...    Returns:
    ...        the results of the request send to the robot's server
    [Arguments]    ${n}    ${startX}    ${startY}    ${endX}    ${endY}
    tapster_keywords.Create robot session    my_session
    ${response} =    tapster_keywords.Draw random pattern    my_session    ${n}    ${startX}    ${startY}    ${endX}    ${endY}
    tapster_keywords.Delete robot session    my_session
    [Return]    ${response}

Draw Star
    [Documentation]    Draws a simple and lovely star
    ...    Returns:
    ...        the results of the request send to the robot's server
    tapster_keywords.Create robot session    my_session
    ${response} =    tapster_keywords.Draw star    my_session
    tapster_keywords.Delete robot session    my_session
    [Return]    ${response}

Draw Circle
    [Documentation]    Draws a circle with a defined center point on (x,y) and a radius r
    ...    Parameters:
    ...        x - the X value of the center point
    ...        y - the Y value of the center point
    ...        r - the radius of the circle
    ...    Returns:
    ...        the results of the request send to the robot's server
    [Arguments]    ${x}    ${y}    ${r}
    tapster_keywords.Create robot session    my_session
    ${response} =    tapster_keywords.Draw circle    my_session    ${x}    ${y}    ${r}
    tapster_keywords.Delete robot session    my_session
    [Return]    ${response}

Draw Cross
    [Documentation]    Draws a cross using 4 points: two strokes will be made (points 1 to 4, and 2 to 3)
    ...    Parameters:
    ...        x1 - the X value of the 1st point
    ...        y1 - the Y value of the 1st point
    ...        x2 - the X value of the 2nd point
    ...        y2 - the Y value of the 2nd point
    ...        x3 - the X value of the 3rd point
    ...        y3 - the Y value of the 3rd point
    ...        x4 - the X value of the 4th point
    ...        y4 - the Y value of the 4th point
    ...    Returns:
    ...        the results of the request send to the robot's server
    [Arguments]    ${x1}    ${y1}    ${x2}    ${y2}    ${x3}    ${y3}    ${x4}    ${y4}
    tapster_keywords.Create robot session    my_session
    ${response} =    tapster_keywords.Draw cross    my_session    ${x1}    ${y1}    ${x2}    ${y2}    ${x3}    ${y3}    ${x4}    ${y4}
    tapster_keywords.Delete robot session    my_session
    [Return]    ${response}

Draw Square
    [Documentation]    Draws a square with a defined length
    ...    The draw will be made each nth point (e.g. n=2), the smaller n is, the more precise the square will be.
    ...    Parameters:
    ...        n - optionnal, default valued to 2
    ...        length - optional, default valued to 30,
    ...    Returns:
    ...        the results of the request send to the robot's server
    [Arguments]    ${n}=2    ${length}=30
    tapster_keywords.Create robot session    my_session
    ${response} =    tapster_keywords.Draw square    my_session    ${n}    ${length}
    tapster_keywords.Delete robot session    my_session
    [Return]    ${response}

Draw Triangle
    [Documentation]    Draws a triangle using 3 points
    ...    Parameters:
    ...        x1 - the X axis value of the 1st point
    ...        y1 - the Y axis value of the 1st point
    ...        x2 - the X axis value of the 2nd point
    ...        y2 - the Y axis value of the 2nd point
    ...        x3 - the X axis value of the 3rd point
    ...        y3 - the Y axis value of the 3rd point
    ...    Returns:
    ...        the results of the request send to the robot's server
    [Arguments]    ${x1}    ${y1}    ${x2}    ${y2}    ${x3}    ${y3}
    tapster_keywords.Create robot session    my_session
    ${response} =    tapster_keywords.Draw triangle    my_session    ${x1}    ${y1}    ${x2}    ${y2}    ${x3}    ${y3}
    tapster_keywords.Delete robot session    my_session
    [Return]    ${response}

Draw Spiral
    [Documentation]    Draws a spiral using a center point (x,y), n loops and an r radius
    ...    Parameters:
    ...        x - the X axis value of the center point
    ...        y - the Y axis value of the center point
    ...        n - the number of loops to draw
    ...        r - the radius of the spiral
    ...    Returns:
    ...        Returns the response of the robot's server.
    [Arguments]    ${x}    ${y}    ${n}    ${r}
    tapster_keywords.Create robot session    my_session
    ${response} =    tapster_keywords.Draw spiral    my_session    ${x}    ${y}    ${n}    ${r}
    tapster_keywords.Delete robot session    my_session
    [Return]    ${response}

Reset
    [Documentation]    Resets the position of the robot's finger
    ...    Returns:
    ...        the results of the request send to the robot's server
    tapster_keywords.Create robot session    my_session
    ${response} =    tapster_keywords.Reset    my_session
    tapster_keywords.Delete robot session    my_session
    [Return]    ${response}

# #########
# Some glue
# #########

Get Suitable Contact Point For Widget With Text
    [Documentation]    According to the location and the dimension of an element, returns a point to click on
    ...    Parameters:
    ...        text - the text of the object
    ...    Returns:
    ...        x, y - coordinates to use of the targeted element
    [Arguments]    ${text}
    ${location} =    Get Element Location     xpath=//*[@text=${text}]
    ${size} =    Get Element Size     xpath=//*[@text=${text}]
    ${contact_x} =    Evaluate    ${location['x']}+${size['width']}/2
    ${contact_y} =    Evaluate    ${location['y']}+${size['height']}/2
    [Return]    ${contact_x}    ${contact_y}

Get Suitable Contact Point For Widget With Id
    [Documentation]    According to the location and the dimension of an element, returns a point to click on
    ...    Parameters:
    ...        id - the id of the object
    ...    Returns:
    ...        x, y - coordinates to use of the targeted element
    [Arguments]    ${id}
    ${location} =    Get Element Location     xpath=//*[@resource-id=${id}]
    ${size} =    Get Element Size     xpath=//*[@resource-id=${id}]
    ${contact_x} =    Evaluate    ${location['x']}+${size['width']}/2
    ${contact_y} =    Evaluate    ${location['y']}+${size['height']}/2
    [Return]    ${contact_x}    ${contact_y}

Get Suitable Contact Point For Widget With Xpath
    [Documentation]    According to the location and the dimension of an element, returns a point to click on
    ...    Parameters:
    ...        xpath_lcoator - the XPath locator to use to find the object
    ...    Returns:
    ...        x, y - coordinates to use of the targeted element
    [Arguments]    ${xpath_locator}
    ${location} =    Get Element Location     xpath=${xpath_locator}
    ${size} =    Get Element Size     xpath=${xpath_locator}
    ${contact_x} =    Evaluate    ${location['x']}+${size['width']}/2
    ${contact_y} =    Evaluate    ${location['y']}+${size['height']}/2
    [Return]    ${contact_x}    ${contact_y}

Get Random Contact Point For Widget With Id
    [Documentation]    According to the location and the dimension of an element, returns a point to click on
    ...    Parameters:
    ...        id - the id of the object
    ...    Returns:
    ...        x, y - coordinates to use of the selected random point
    [Arguments]    ${id}
    ${location} =    Get Element Location     xpath=//*[@resource-id=${id}]
    ${size} =    Get Element Size     xpath=//*[@resource-id=${id}]
    ${min_x} =    Convert To Integer    ${location['x']}
    ${max_x} =    Evaluate    ${location['x']}+${size['width']}
    ${max_x} =    Convert To Integer    ${max_x}
    ${min_y} =    Convert To Integer    ${location['y']}
    ${max_y} =    Evaluate    ${location['y']}+${size['height']}
    ${max_y} =    Convert To Integer    ${max_y}
    ${contact_x} =    Evaluate   random.sample(range(${min_x},${max_x}), 1)    random
    ${contact_y} =    Evaluate   random.sample(range(${min_y},${max_y}), 1)    random
    [Return]    ${contact_x}[0]    ${contact_y}[0]

Get Random Contact Point For Widget With Text
    [Documentation]    According to the location and the dimension of an element, returns a point to click on
    ...    Parameters:
    ...        text - the text of the object
    ...    Returns:
    ...        x, y - coordinates to use of the selected random point
    [Arguments]    ${text}
    ${location} =    Get Element Location     xpath=//*[@text=${text}]
    ${size} =    Get Element Size     xpath=//*[@text=${text}]
    ${min_x} =    Convert To Integer    ${location['x']}
    ${max_x} =    Evaluate    ${location['x']}+${size['width']}
    ${max_x} =    Convert To Integer    ${max_x}
    ${min_y} =    Convert To Integer    ${location['y']}
    ${max_y} =    Evaluate    ${location['y']}+${size['height']}
    ${max_y} =    Convert To Integer    ${max_y}
    ${contact_x} =    Evaluate   random.sample(range(${min_x},${max_x}), 1)    random
    ${contact_y} =    Evaluate   random.sample(range(${min_y},${max_y}), 1)    random
    [Return]    ${contact_x}[0]    ${contact_y}[0]

Get Random Contact Point For Widget With Xpath
    [Documentation]    According to the location and the dimension of an element, returns a point to click on
    ...    Parameters:
    ...        xpath_locator - the XPath lcoator to use to find the object
    ...    Returns:
    ...        x, y - coordinates to use of the selected random point
    [Arguments]    ${xpath_locator}
    ${location} =    Get Element Location     xpath=${xpath_locator}
    ${size} =    Get Element Size     xpath=${xpath_locator}
    ${min_x} =    Convert To Integer    ${location['x']}
    ${max_x} =    Evaluate    ${location['x']}+${size['width']}
    ${max_x} =    Convert To Integer    ${max_x}
    ${min_y} =    Convert To Integer    ${location['y']}
    ${max_y} =    Evaluate    ${location['y']}+${size['height']}
    ${max_y} =    Convert To Integer    ${max_y}
    ${contact_x} =    Evaluate   random.sample(range(${min_x},${max_x}), 1)    random
    ${contact_y} =    Evaluate   random.sample(range(${min_y},${max_y}), 1)    random
    [Return]    ${contact_x}[0]    ${contact_y}[0]
