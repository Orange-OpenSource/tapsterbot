/*
Copyright (c) 2011-2016, Tapster Committers
Copyright © 2018 Orange

All rights reserved.

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

// TODO Make a massive refactoring to make sources compliant to ES6 and strict mode

var kinematics = require("./../kinematics");
require("sylvester");
var keyboards = require("./keyboards");

var method = Robot.prototype;

function Robot(servo1, servo2, servo3, calibration){
  this._servo1 = servo1;
  this._servo2 = servo2;
  this._servo3 = servo3;
  this._calibration = calibration;
  this._dancer_interval = null;
}

var generateTranslationMatrix = function(calibration){

  var r1x = calibration.device.contactPoint.position.x;
  var r1y = calibration.device.contactPoint.position.y;
  var r2x = calibration.device.point1.position.x;
  var r2y = calibration.device.point1.position.y;
  var r3x = calibration.device.point2.position.x;
  var r3y = calibration.device.point2.position.y;

  var d1x = calibration.device.contactPoint.screenCoordinates.x;
  var d1y = calibration.device.contactPoint.screenCoordinates.y;
  var d2x = calibration.device.point1.screenCoordinates.x;
  var d2y = calibration.device.point1.screenCoordinates.y;
  var d3x = calibration.device.point2.screenCoordinates.x;
  var d3y = calibration.device.point2.screenCoordinates.y;

  var deviceXVector = $M([[(d3x-d1x) / (r3x-r1x)], [(d3y-d1y) / (r3x-r1x) ]]);
  var deviceYVector = $M([[(d2x-d1x) / (r2y-r1y)], [(d2y-d1y) / (r2y-r1y) ]]);
  var offset = $M([d1x-r1x, d1y-r1y]);
  var r2dMatrix = $M([[deviceXVector.elements[0], deviceYVector.elements[0]], [deviceXVector.elements[1], deviceYVector.elements[1]]]);
  return {offset: offset, matrix: r2dMatrix};

};

var sin = function(degree){
  return Math.sin(Math.PI * (degree/180));
};

var cos = function(degree){
  return Math.cos(Math.PI * (degree/180));
};

var mapNumber = function (num,  in_min , in_max , out_min , out_max ){
  return ( num - in_min ) * ( out_max - out_min ) / ( in_max - in_min ) + out_min;
};

var rotate = function(x,y){
  var theta = -60;
  var x1 = x * cos(theta) - y * sin(theta);
  var y1 = y * cos(theta) + x * sin(theta);
  return [x1,y1]
};

var reflect = function(x,y){
  var theta = 0;
  var x1 = x;
  var y1 = x * sin(2*theta) - y * cos(2*theta);
  return [x1,y1]
};


method.getAngles = function(){
  return [this._servo1.last.degrees, this._servo2.last.degrees, this._servo3.last.degrees];
};

method.setAngles = function(t1,t2,t3){
  console.log("Setting Angles:" + [t1,t2,t3]);
  t1 = isNaN(t1) ? this._calibration.servo1.minimumAngle : t1;
  t2 = isNaN(t2) ? this._calibration.servo1.minimumAngle : t2;
  t3 = isNaN(t3) ? this._calibration.servo1.minimumAngle : t3;
  this._servo1.to(t1);
  this._servo2.to(t2);
  this._servo3.to(t3);
};

method.getPosition = function(){
  var angles = this.getAngles();
  return kinematics.forward(angles[0], angles[1], angles[2]);
};

method.setPosition = function(x, y, z){
  console.log("Setting Position:" + [x,y,z]);
  var reflected = reflect(x,y);
  var rotated = rotate(reflected[0],reflected[1]);
  var angles = kinematics.inverse(rotated[0], rotated[1], z);
  var t1 = mapNumber(angles[1], 0 , 90 , this._calibration.servo1.minimumAngle ,  this._calibration.servo1.maximumAngle);
  var t2 = mapNumber(angles[2], 0 , 90 , this._calibration.servo2.minimumAngle ,  this._calibration.servo2.maximumAngle);
  var t3 = mapNumber(angles[3], 0 , 90 , this._calibration.servo3.minimumAngle ,  this._calibration.servo3.maximumAngle);
  this.setAngles(t1,t2,t3);
};

method.resetPosition = function(){
  this.setPosition(this._calibration.restPoint.x, this._calibration.restPoint.y, this._calibration.restPoint.z);
};

method.getPositionForAngles = function(t1,t2,t3){
  var points = kinematics.forward(t1,t2,t3);
  return [points[1], points[2], points[3]];
};

method.getAnglesForPosition = function(x,y,z){
  var angles = kinematics.inverse(x,y,z);
  return [angles[1], angles[2], angles[3]];
};

method.getPositionForScreenCoordinates = function(x,y){
  var calData = generateTranslationMatrix(this._calibration);
  var matrix = calData.matrix;
  var offset = calData.offset;
  var vector = $M([ [x-offset.elements[0]],[y-offset.elements[1]] ]);
  var converted = matrix.inverse().multiply(vector);
  var newX = converted.elements[0];
  var newY = converted.elements[1];
  return {x:newX, y:newY};
};

method.getContactZ = function(){
  return  1.01 * Math.min(
    this._calibration.device.contactPoint.position.z,
    this._calibration.device.point1.position.z,
    this._calibration.device.point2.position.z
  );
};

method.tap = function(screenX, screenY, cb){
  var position = this.getPositionForScreenCoordinates(screenX, screenY);
  var touchZ = this.getContactZ();
  this.setPosition(position.x, position.y, touchZ * 0.9);
  return setTimeout(function() {
    this.setPosition(position.x, position.y, touchZ);
    return setTimeout(function() {
      this.setPosition(position.x, position.y, touchZ * 0.9);
      return setTimeout(cb, 400);
    }.bind(this), 400);
  }.bind(this), 400);
};

method.doubleTap = function(screenX, screenY, duration, cb){
  // Duration and temporization in ms
  var minimalDuration = 100;
  var tempo = 100;
  duration = (duration < minimalDuration ? minimalDuration : duration);
  var position = this.getPositionForScreenCoordinates(screenX, screenY);
  var touchZ = this.getContactZ();
  // Be ready to tap
  this.setPosition(position.x, position.y, touchZ * 0.9);
  return setTimeout(function() {
     // Tap
    this.setPosition(position.x, position.y, touchZ);
    return setTimeout(function() {
      // Go to initial state
      this.setPosition(position.x, position.y, touchZ * 0.9);
      return setTimeout(function() {
        // Tap again
        this.setPosition(position.x, position.y, touchZ);
        return setTimeout(function() {
          // Go to initial state
          this.setPosition(position.x, position.y, touchZ * 0.9);
          return setTimeout(cb, tempo);
        }.bind(this), tempo);    
      }.bind(this), duration);
    }.bind(this), tempo);
  }.bind(this), tempo);
};

method.tripleTap = function(screenX, screenY, duration, cb){
  // Duration and temporization in ms
  var minimalDuration = 100;
  var tempo = 100;
  duration = (duration < minimalDuration ? minimalDuration : duration);
  var position = this.getPositionForScreenCoordinates(screenX, screenY);
  var touchZ = this.getContactZ();
  // Be ready to tap
  this.setPosition(position.x, position.y, touchZ * 0.9);
  return setTimeout(function() {
     // Tap
    this.setPosition(position.x, position.y, touchZ);
    return setTimeout(function() {
      // Go to initial state
      this.setPosition(position.x, position.y, touchZ * 0.9);
      return setTimeout(function() {
        // Tap again
        this.setPosition(position.x, position.y, touchZ);
        return setTimeout(function() {
          // Go to initial state
          this.setPosition(position.x, position.y, touchZ * 0.9);
          return setTimeout(function() {
            // Tap again
            this.setPosition(position.x, position.y, touchZ);
            return setTimeout(function() {
              // Go to initial state
              this.setPosition(position.x, position.y, touchZ * 0.9);
              return setTimeout(cb, tempo);
            }.bind(this), tempo);    
          }.bind(this), duration);
        }.bind(this), tempo);    
      }.bind(this), duration);
    }.bind(this), tempo);
  }.bind(this), tempo);
};

method.longTap = function(screenX, screenY, duration, cb){
  // Duration and temporization in ms
  var minimalDuration = 1000;
  var tempo = 400;
  duration = (duration < minimalDuration ? minimalDuration : duration);
  var position = this.getPositionForScreenCoordinates(screenX, screenY);
  var touchZ = this.getContactZ();
  // Be ready to tap
  this.setPosition(position.x, position.y, touchZ * 0.9);
  return setTimeout(function() {
     // Tap
    this.setPosition(position.x, position.y, touchZ);
    return setTimeout(function() {
      // Go to initial state
      this.setPosition(position.x, position.y, touchZ * 0.9);
      return setTimeout(cb, tempo);
    }.bind(this), duration);
  }.bind(this), tempo);
};

method.swipe = function(startX, startY, endX, endY, cb){
  var startPosition = this.getPositionForScreenCoordinates(startX, startY);
  var endPosition = this.getPositionForScreenCoordinates(endX, endY);
  var touchZ = this.getContactZ();
  this.setPosition(startPosition.x, startPosition.y, touchZ * 0.9);
  return setTimeout(function() {
    this.setPosition(startPosition.x, startPosition.y, touchZ);
    return setTimeout(function() {
      this.setPosition(endPosition.x, endPosition.y, touchZ);
      return setTimeout(function() {
        this.setPosition(endPosition.x, endPosition.y, touchZ * 0.9);
        return setTimeout(cb, 100);
      }.bind(this), 400);
    }.bind(this), 400);
  }.bind(this), 400);
};

method.sendKeys = function(keys, cb){
  var keyboard = keyboards.getKeyboard("iPhone 6"/*this._calibration.device.name*/);
  var keystrokeSequence = [];
  for (var keyIndex=0; keyIndex < keys.length; keyIndex++) {
    keystrokeSequence = keystrokeSequence.concat(keyboard.getKeySequence(keys[keyIndex]));
  }
  var tapKey = function(keystrokes, cb) {
    if (keystrokes.length == 0) {
      return cb();
    } else {
      var currentKeyPosition = keystrokes.shift();
      this.tap(currentKeyPosition.x, currentKeyPosition.y, function() {
        return tapKey(keystrokes, cb);
      });
    }
  }.bind(this);
  return tapKey(keystrokeSequence, cb);
};

method.startDancing = function(){
  var _dance = function() {
    var minAngle = 10;
    var maxAngle = 20;
    var range = maxAngle - minAngle;
    var t1 = parseInt((Math.random() * range) + minAngle, 10);
    var t2 = parseInt((Math.random() * range) + minAngle, 10);
    var t3 = parseInt((Math.random() * range) + minAngle, 10);
    this.setAngles(t1,t2,t3);
  }.bind(this);

  if (!this._dancer_interval) {
    this._dancer_interval = setInterval(_dance, 250);
  }

};

method.stopDancing = function(){
  if (this._dancer_interval) {
    clearInterval(this._dancer_interval);
    this._dancer_interval = null;
  }
};

method.getCalibrationData = function(){
  return this._calibration;
};

method.setCalibrationData = function(newData){
  this._calibration = newData;
};

module.exports = {};
module.exports.Robot = Robot;
