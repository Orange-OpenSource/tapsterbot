# Important notice

This GitHub repository is a fork of the original [Jason Huggin's tapsterbot](https://github.com/hugs/tapsterbot) project.
It contains also improvements (direct or not) from [Dan Cuellar's fork](https://github.com/penguinho/tapsterbot).
Some parts of this project have been implemented or reviewed internaly at Orange in 2018 and were expected to be sumbmitted in open source.
This project has been finaly released so as to not prevent community to use it, and because forks on personal spaces was not appropriate.
**You should not consider this proejct as active nor maintained since 2018**.

# Tapster - Mobile Automation Robot

## Why using such bot?
- Bring fun in your office
- Bring automation for your tests
- Extend your software-based instrumented tests (using UI Automator, Espresso, Kakao, Appium or whatever) with hardware-based tests
- Improve quality of your products
- Deal with secured elements on which no software can click
- Be as close as possible of the ideal use case (users use their fingers to click :3)
- Get a new tool for software development and mobile app tests: robots!

## Projects files

### Clients
Contains Python and *Roboto Framwork* client to send request to *Taspter* bot

### Calibration
Contains Android and iOS app to claibrate the robot

### Hardware
This part contains all the assets to build the Tapster robots. As far as we remember, we did not change them.
The model we worked on where *Taspter 2*.

### Licenses
Contains some license files for information.

### Softwares
Contains source code to calibrate the bot, receive commands and process them.

## How it works
1. Calibrate the robot: you will have to run a claibration app from *Appium*, run the *calibrate* script of the robot and wait for capabilities after the calibration ;
2. The calibration process is quite simple: the robot tap on the screen, the app displays coordinates and *Appium* get it and process ;
3. The robot then must be used with the capabilities ;
4. It exposes a REST HTTP server which receives requests you can send with *Python* code or *Robot Framework*.
5. The brian of the robot is an *Arduino* board you must flash *Firmata* on
6. The project is quite cool and only few iPhones models were manage with conversion tables between keypads and coordinates

## Some references and things to see
- http://www.tapster.io (the creator of the Tapster bots)
- https://twitter.com/tapsterbot
- https://www.tindie.com/products/hugs/tapster/
- https://github.com/hugs/tapsterbot
- https://github.com/tapsterbot/tapsterbot
- https://github.com/appium/appium
- https://github.com/appium/robots
- https://github.com/penguinho/tapsterbot
- https://github.com/jackskalitzky/tapsterbot
- https://github.com/pylapp/tapsterbot
- https://speakerdeck.com/pylapp/why-not-tapster
