#! /usr/local/bin/node

/*
Copyright (c) 2011-2016, Tapster Committers
Copyright (c) 2018, Orange

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

[This is the BSD 2-Clause License, http://opensource.org/licenses/BSD-2-Clause]
*/


// **************************************
// Dependencies and parameters management
// **************************************

var prompt = require("prompt"),
  fs = require("fs"),
  eol = require('os').EOL,
  ArgumentParser = require('argparse').ArgumentParser,
  robot = require('./lib/server/robot_http_client').client("127.0.0.1","4242"),
  wd = require('wd');

var args = {},
  newCalibrationData = {};

var androidInUse = false;
var iOSInUse = false;

var androidCoordRegex = /text[^\(,]+\((\d+\.*\d*),\s+(\d+\.*\d*)\)/ ;
var iOSCoordRegex = /label[^\(,]+\((\d+\.*\d*),\s+(\d+\.*\d*)\)/ ;

function CalibrationManager(argv){
  args = argv;
  prompt.message = '';
  prompt.delimiter = '';
  prompt.start();
}

exports.CalibrationManager = CalibrationManager;

/**
 * Gets the arguments of the command lines
 */
var getCommandLineArgs = function(){
  var parser = new ArgumentParser({
    version: '0.0.1',
    addHelp:true,
    description: 'Tapster Calibration Script'
  });
  parser.addArgument(
    [ '-o', '--output' ], {
      defaultValue: "calibration.json"
      , help: 'file to save calibration data to'
    }
  );
  return parser.parseArgs();
};

/**
 * Runs the calibrate workflow.
 * Will ask to user if he or she wants yto claibrate the arms of the bot and the corddinates mapping with a dedicated device.
 */
CalibrationManager.prototype.calibrate = function(){
  robot.calibrationData(function (calibrationData) {
    console.log("Receiving existing calibration data.");
    newCalibrationData = calibrationData;
    console.log(JSON.stringify(newCalibrationData));
    return askToCalibrateRobot(function() {
      return askToCalibrateDevice(function() {
        saveCalibrationData(function() {
          console.log("Calibration Complete");
        });
      })
    });
  });
};

/**
 * Ask the user if he or she wants to calibrate the robot, here the arms of the bot
 */
var askToCalibrateRobot = function(cb){
  var schema = {
    name:"answer",
    description: 'Would you like to calibrate the robot arms?',
    type: 'string'
  };
  prompt.get(schema, function (err, result){
    if (result.answer.toLowerCase().substr(0,1) == "y") {
      return calibrateRobot(cb);
    } else {
      return cb();
    }
  });
};

/**
 * Ask the user if he or she wants to calibrate the robot with a dedicated device
 */
var askToCalibrateDevice = function(cb){
  var schema = {
    name:"answer",
    description: 'Would you like to calibrate the robot to a device? If so, plug the arms of the bot.',
    type: 'string'
  };
  prompt.get(schema, function (err, result){
    if (result.answer.toLowerCase().substr(0,1) == "y") {
      return calibrateDevice(cb);
    } else {
      return cb();
    }
  });
};

/**
 * Saves the calibration data in JSON format
 */
var saveCalibrationData = function(cb){
  console.log("New calibration data generated.");
  console.log(JSON.stringify(newCalibrationData));
  return robot.setCalibrationData(newCalibrationData, function () {
    console.log("Robot is now calibrated!");
    return fs.writeFile(args.output, JSON.stringify(newCalibrationData), function (err) {
      if (err) {
        console.log('Calibration data can not be saved: ' + err);
      } else {
        console.log('Calibration data saved to "' + args.output + '"');
      }
      return cb();
    });
  });
};

/**
 * Calibrates the robot.
 * Asks the user to remove the arms and to define good agngles for them.
 * Will then let the suer choose the good angles for each arm.
 */
var calibrateRobot = function(cb){

  var schema = {
    description: 'Please remove the arms from the robot and press any key to continue...',
    type: 'string'
  };

  return prompt.get(schema, function (){

    var calibrateServos = function(cb) {

      var calibrateServo = function(armIndex, isMin, cb){
        robot.angles(function (angles) {
          var description = 'Enter an adjustment for arm #' + (armIndex +1) + ', enter 0 when the arm is ' +
          (isMin ? 'parallel to the roof.' : 'perpendicular to the roof');

          var schema = {
            name: "delta",
            description: description,
            type: 'number'
          };

          return prompt.get(schema, function (err, result) {
            if (result.delta < 0.05 && result.delta > -0.05) {
              newCalibrationData["servo" + (armIndex+1)][(isMin ? "min" : "max" ) + "imumAngle"] = angles[armIndex];
              return cb();
            } else {
              console.log("Old angles: " + angles);
              angles[armIndex] = angles[armIndex] + result.delta;
              console.log("New angles: " + angles);
              robot.setAngles(angles[0], angles[1], angles[2], function() {
                return calibrateServo(armIndex, isMin, cb);
              });
            }
          });

        });
      }; // End of calibrateServo = function(armIndex, isMin, cb)

      var calibrateServoMinAndMax = function(armIndex, cb){
        return robot.reset(function () {
          return calibrateServo(armIndex, true, function () {
            return calibrateServo(armIndex, false, cb);
          });
        });
      };

      // calibrate the servos
      return calibrateServoMinAndMax(0, function() {
        return calibrateServoMinAndMax(1, function() {
          return calibrateServoMinAndMax(2, function() {
            return robot.reset(cb);
          });
        });
      });

    }; // End of var calibrateServos = function(cb)

    return calibrateServos(function () {
      return cb();
    });

  });

}; // End of var calibrateRobot = function(cb)

/**
 * Reads JSON file containing desired capabilities for iOS device so as to run the calibraiton app.
 *
 * @return {json} capabilities - The desired capabilities to use so as to deal with the good calibration app in the good device
 */
var readIosDesiredCapabilities = function(){
  return JSON.parse(fs.readFileSync('../../calibration/capabilities/ios-desired-capabilities.json', 'utf8'));
}

/**
 * Reads JSON file containing desired capabilities for Android device so as to run the calibraiton app.
 *
 * @return {json} capabilities - The desired capabilities to use so as to deal with the good calibration app in the good device
 */
var readAndroidDesiredCapabilities = function(){
  return JSON.parse(fs.readFileSync('../../calibration/capabilities/android-desired-capabilities.json', 'utf8'));
}

/**
 * Asks the user the OS of its device.
 * Indeed if there is an iPhone with iOS or an Android handset, the capabilities to use with Appium or the regex
 * in use to retrieve the coordinates will not be the same.
 *
 * @param {function} cb - An error clalback
 * @return {json} capabilities - The desired capabilities to use so as to deal with the good calibration app in the good device
 */
var askForTypeOfDeviceOs = function(cb){

  var schema = {
    name:"answer",
    description: 'What is the operating system of the device? Android (a) or iOS (i) or something else?',
    type: 'string'
  };

  prompt.get(schema, function (err, result){

    // Android handset
    if (result.answer.toLowerCase().substr(0,1) == "a") {

      console.log("Using desired capabilities for Android handset");
      androidInUse = true;
      iOSInUse = false;
      return readAndroidDesiredCapabilities();

    // iPhone
    } else if (result.answer.toLowerCase().substr(0,1) == "i") {

      console.log("Using desired capabilities for iPhone");
      androidInUse = false;
      iOSInUse = true;
      return readIosDesiredCapabilities();

    // Not supported OS (we are in 2017 guys... ;-D)
    } else {
      return cb();
    }

  });

}; // End of var askForTypeOfDeviceOs = function(cb)

/**
 * Caliibrates the robot for a dedicated device.
 * Will lower the arms of the bot so as ot have contact points.
 * Then will get coordinates displayed by a dedicated app in the device.
 * The task will be made for 3 points.
 */
var calibrateDevice = function(cb){

  newCalibrationData.device = {
    contactPoint: { position:{},screenCoordinates:{} },
    point1: { position:{},screenCoordinates:{} },
    point2: { position:{},screenCoordinates:{} }
  };

  var driver = wd.remote({port:4723});

  driver.on('http', function(meth, path, data) {
    console.log(' > 1' + meth.magenta, path, (data || '').grey);
  });

  var lowerAndCheckForContact = function(x,y,currentZ, cb) {

    return robot.setPosition(x,y,currentZ,function() {

      setTimeout(function() {
        var coordRegex = ( androidInUse ? androidCoordRegex : iOSCoordRegex );
        return driver.source(function(err, pageSource) {
          if (coordRegex.test(pageSource)) {
            var match = coordRegex.exec(pageSource);
            var screenX = parseFloat(match[1]);
            var screenY = parseFloat(match[2]);
            console.log("Found Point: (" + x + "," + y + ") => (" + screenX + "," + screenY + ")");
            return cb(x,y,screenX,screenY,currentZ);
          } else {
            if (currentZ < -150) {
              return robot.reset(function() {
                return cb(Error("Could not touch the screen."));
              });
            } else {
              return lowerAndCheckForContact(x, y, currentZ - 2, cb);
            }
          }
        });
      }, 2000);

    }); // End of return robot.setPosition(x,y,currentZ,function()

  }; // End of var lowerAndCheckForContact = function(x,y,currentZ, cb)

  var desiredCapabilities = askForTypeOfDeviceOs(function(){console.log("Not supported OS");});

  return driver.init(desiredCapabilities, function() {
    driver.setImplicitWaitTimeout(1000, function () {
      return lowerAndCheckForContact(0, 0, -145, function (x, y, screenX, screenY, robotZ) {
        newCalibrationData.device.contactPoint.position = {x: x, y: y, z:robotZ};
        newCalibrationData.device.contactPoint.screenCoordinates = {x: screenX, y: screenY};
        return lowerAndCheckForContact(0, 20, -145, function (x, y, screenX, screenY, robotZ) {
          newCalibrationData.device.point1.position = {x: x, y: y, z:robotZ};
          newCalibrationData.device.point1.screenCoordinates = {x: screenX, y: screenY};
          return lowerAndCheckForContact(20, 0, -145, function (x, y, screenX, screenY, robotZ) {
            newCalibrationData.device.point2.position = {x: x, y: y, z:robotZ};
            newCalibrationData.device.point2.screenCoordinates = {x: screenX, y: screenY};
            return robot.reset(cb);
          });
        });
      });
    });
  }); // End of return driver.init

}; // End of var calibrateDevice = function(cb)

if(require.main === module) {
  new CalibrationManager(getCommandLineArgs()).calibrate();
}
