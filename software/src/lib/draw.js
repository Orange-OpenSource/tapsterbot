/*
  Copyright (c) 2011-2016, Tapster Committers
  Copyright (c) 2018, Orange
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

//Draws lines and shapes using if needed data.json file

/* ************
 * Useful tools
 * ************/

var fs = require('fs');
var motion = require("./motion");

/* ********* *
 * Variables *
 * ********* */

var objRef, defaultEaseType;
var calculated, spiralPts;

var baseHeight, baseWidth, canvasHeight, canvasWidth, heightRatio, widthRatio, halfway;

var DRAW_HEIGHT = -152;
var currentPoint = {x: 0, y: 0, z: -140};
var penHeight = DRAW_HEIGHT;

var defaultEaseType = "linear";
var timer = 0;
var current = [0, 0, DRAW_HEIGHT];
var steps = 5;
var delay = 200 / steps;

var robotReference;

/* **************************
 * Definition of super object
 * **************************/

function Draw(args, robot){

  // FIXME Hardcoded values
  this.baseWidth = 80;
  this.baseHeight = 95;
  this.drawHeight = DRAW_HEIGHT; // TODO Use calibration data instead!
  this.defaultEaseType = "linear";

  if (args){
    var keys = Object.keys(args);
    keys.forEach(function(key){
      this[key] = args[key];
    }, this)
  }

  penHeight = this.drawHeight;
  defaultEaseType = this.defaultEaseType;
  objRef = this;

  robotReference = robot;

}


/* ********************* *
 * Defintions of methods *
 * ********************* */

//Maps point from canvas to the Tapster coordinate plane
//The conversion is based on the canvas size and the size of the Tapster base
//These can be changed as needed
mapPoints = function(x, y){
  var newX = x;
  var newY = y;
  newX = (newX - halfway.x) / widthRatio;
  newY = (halfway.y - newY) / heightRatio;
  return {x:newX, y:newY};
};


//Set the penHeight from the command line
Draw.prototype.setPenHeight = function(height){
  penHeight = height;
}

//Draws a square in order to ensure that everything is working properly
//Optional args:
//sideLength: the length of each side (default: 20)
//n: draws every nth point (default: 2)
Draw.prototype.drawSquare = function(args){

  //Default values
  this.sideLength = 30;
  this.n = 2;

  if (args) {
    var keys = Object.keys(args)
    keys.forEach(function(key){
      this[key] = args[key]
    }, this)
  }

  objRef.resetTimer(); //Reset the timer so that there isn't unnecessary delay when calling the function multiple times

  var halfSide = this.sideLength / 2;
  var points = this.sideLength / this.n;

  objRef.doSetTimeout(-halfSide, halfSide, penHeight + 10, 0)
  objRef.doSetTimeout(-halfSide, halfSide, penHeight, 500); //Top left corner

  for (var i = 0; i < points; i++) { //To bottom left
    objRef.doSetTimeout(-halfSide, halfSide - (this.n * i), penHeight, i * 5);
  }

  for (var i = 0; i < points; i++) { //To bottom right
    objRef.doSetTimeout(-halfSide + (this.n * i), -halfSide, penHeight, i * 5);
  }

  for (var i = 0; i < points; i++) { //To top right
    objRef.doSetTimeout(halfSide, -halfSide + (this.n * i), penHeight, i * 5);
  }

  for (var i = 0; i < points; i++) { //To top left
    objRef.doSetTimeout(halfSide - (this.n * i), halfSide, penHeight, i * 5);
  }

  objRef.doSetTimeout(0, 0, -140, timer + 100);

};

//Draws a star to test that the Tapster bot is working properly
// Points are not in the 2D landmark of the device, but in the robot's landmark
// (= (0,0) at the center of the plate)
Draw.prototype.drawStar = function(){
  objRef.resetTimer();
  objRef.doSetTimeout(-20, -20, penHeight, 1000);
  objRef.doSetTimeout(0, 30, penHeight, 1000);
  objRef.doSetTimeout(20, -20, penHeight, 1000);
  objRef.doSetTimeout(-30, 10, penHeight, 1000);
  objRef.doSetTimeout(30, 10, penHeight, 1000);
  objRef.doSetTimeout(-20, -20, penHeight, 1000);
  objRef.doSetTimeout(0, 0, -140, timer + 100);
  //-20, -20, 0, 30, 20, -20
};

// Draws a triangle
// Points are not in the 2D landmark of the device, but in the robot's landmark
// (= (0,0) at the center of the plate)
Draw.prototype.drawTriangle = function(x, y, x1, y1, x2, y2){
  objRef.resetTimer();
  objRef.doSetTimeout(x, y, penHeight, 1000);
  objRef.doSetTimeout(x1, y1, penHeight, 1000);
  objRef.doSetTimeout(x2, y2, penHeight, 1000);
  objRef.doSetTimeout(x, y, penHeight, 1000);
  objRef.doSetTimeout(0, 0, -140, timer + 100);
}

// Draws a cross with two strokes : (x1, y1) -> (x3, y3) and (x2, y2) -> (x4, y4)
// Points are not in the 2D landmark of the device, but in the robot's landmark
// (= (0,0) at the center of the plate)
Draw.prototype.drawCross = function(x1, y1, x2, y2, x3, y3, x4, y4){
  objRef.resetTimer();
  objRef.doSetTimeout(x1, y1, penHeight, 1000);
  objRef.doSetTimeout(x3, y3, penHeight, 1000);
  objRef.doSetTimeout(0, 0, -140, 500);
  objRef.doSetTimeout(x2, y2, penHeight, 1000);
  objRef.doSetTimeout(x4, y4, penHeight, 1000);
  objRef.doSetTimeout(0, 0, -140, 500);
}

//Draws a circle
//Optional args:
//centerX: the x coordinate of the center (default: 0)
//centerY: the y coordinate of the center (default: 0)
//radius: the radius of the center (default: 20)
Draw.prototype.drawCircle = function(args){

  objRef.resetTimer();

  this.centerX = 0;
  this.centerY = 0;
  this.radius = 20;

  if (args) {
    var keys = Object.keys(args)
    keys.forEach(function(key){
      this[key] = args[key]
    }, this)
  }

  // an array to save your points
  var points = [];

  // populate array with points along a circle
  //Goes slightly over so that the circle is actually completed
  for (var degree=0; degree < 395; degree++) {
    var radians = (degree + 90) * Math.PI/180;
    var x = this.centerX + this.radius * Math.cos(radians);
    var y = this.centerY + this.radius * Math.sin(radians);
    points.push({x:x,y:y});
  }

  circle = function() {
    objRef.doSetTimeout(0, 0, -120, 50, "none");
    objRef.doSetTimeout(points[0].x, points[0].y, penHeight + 10, 150, "none");
    objRef.doSetTimeout(points[0].x, points[0].y, penHeight, 150, "none");
    for (var i=0; i<points.length; i+=1) {
      point = points[i];
      objRef.doSetTimeout(point.x, point.y, penHeight, 2, "none");
    }
  }

  circle();
  objRef.doSetTimeout(0, 0, -140, timer + 100, "none");

};

//Draws an arbitrary amount of spirals to test that the Tapster bot is working properly
//Optional args:
//startX: the x coordinate of the spiral's starting point (default: 0)
//startY: the y coordinate of the spiral's starting point (default: 0)
//spirals: amount of spirals to draw (default: 3)
//radius: radius of largest spiral (default: 30)
//zLevel: height at which to draw the spiral (default: penHeight)
//ptArray: an array of points to draw instead of calculating the spiral again (default: null)
Draw.prototype.drawSpiral = function(args){

  this.startX = 0;
  this.startY = 0;
  this.spirals = 3;
  this.radius = 30;
  this.zLevel = penHeight;
  this.ptArray = null;

  if (args) {
    var keys = Object.keys(args)
    keys.forEach(function(key){
      this[key] = args[key]
    }, this)
  }

  objRef.resetTimer();

  var x1 = 0;
  var y1 = 0;
  var points = [];

  if (this.ptArray) {
    points = this.ptArray;
  //Draws additional points, mainly for use with the erase function
  //The extra points allow the eraser to end up in its resting position
  } else {
    for (var degree = 0; degree < this.spirals * 360 + 95; degree++) {
      x1 = x1 + this.radius/(this.spirals * 360);
      y1 = y1 + this.radius/(this.spirals * 360);
      var radians = degree * Math.PI/180;
      var x = this.startX + x1 * Math.cos(radians);
      var y = this.startY + y1 * Math.sin(radians);
      points.push({x:x, y:y});
    }
    //doSetTimeout(points[0].x, points[0].y, penHeight + 10, 150);
    //doSetTimeout(points[0].x, points[0].y, penHeight, 150, "none");
  }

  spiral = function() {
    for (var z = 0; z < points.length; z++) {
      point = points[z];
      objRef.doSetTimeout(point.x, point.y, objRef.zLevel, 5, "none");
    }
  }

  spiral();
  objRef.doSetTimeout(0, 0, -140, timer + 100);

};

// Draws a random pattern with n points withing an area defined by the minimum and maximum
// width and height. The values for minimum and maximum width must match the robot's
// 3D landmark, i.e. with height in [-30, +30] and width in [-40, +40]
Draw.prototype.drawRandom = function(n=5, minWidth=-35, minHeight=-30, maxWidth=35, maxHeight=30){

  // Will contain the points: [x1, y1, x2, y2, ..., xN, yN]
  var points = [];

  // Step 1: Get the n points
  for (var i = 0; i < n; i++){
    var firstValueForWidth = Math.ceil(minWidth);
    var lastValueForWidth = Math.floor(maxWidth);
    var randomWidth = Math.floor(Math.random() * (lastValueForWidth - firstValueForWidth + 1)) + firstValueForWidth;
    points.push(randomWidth);
    var firstValueForHeight = Math.ceil(minHeight);
    var lastValueForHeight = Math.floor(maxHeight);
    var randomHeight =  Math.floor(Math.random() * (lastValueForHeight - firstValueForHeight + 1)) + firstValueForHeight;
    points.push(randomHeight);
  }

  // Step 2: Draw!
  objRef.resetTimer();
  for (var p = 0; p < points.length; p+=2){
    objRef.doSetTimeout(points[p], points[p+1], penHeight, 1000);
  }
  objRef.doSetTimeout(0, 0, -140, 500);

}

// Tap on n random points withing an area defined by the minimum and maximum
// width and height. The values for minimum and maximum width must match the robot's
// 3D landmark, i.e. around with height in [-30, +30] and width in [-40, +40]
Draw.prototype.tapRandom = function(n, minWidth, minHeight, maxWidth, maxHeight){

  // Will contain the points: [x1, y1, x2, y2, ..., xN, yN]
  var points = [];

  // Step 1: Get the n points
  for (var i = 0; i < n; i++){
    var firstValueForWidth = Math.ceil(minWidth);
    var lastValueForWidth = Math.floor(maxWidth);
    var randomWidth = Math.floor(Math.random() * (lastValueForWidth - firstValueForWidth + 1)) + firstValueForWidth;
    points.push(randomWidth);
    var firstValueForHeight = Math.ceil(minHeight);
    var lastValueForHeight = Math.floor(maxHeight);
    var randomHeight =  Math.floor(Math.random() * (lastValueForHeight - firstValueForHeight + 1)) + firstValueForHeight;
    points.push(randomHeight);
  }

  // Step 2: Draw!
  objRef.resetTimer();
  var cleanDelay = 250;
  objRef.doSetTimeout(points[0], points[1], -140, 500); // Prevent from noisy strokes
  for (var p = 0; p < points.length; p+=2){
    objRef.doSetTimeout(points[p], points[p+1], -140, 500);
    objRef.doSetTimeout(points[p], points[p+1], penHeight, 500 + cleanDelay);
    objRef.doSetTimeout(points[p], points[p+1], -140, 500 + cleanDelay*2);
  }
  objRef.doSetTimeout(0, 0, -140, 500);

}

//Draws n strokes from a (startX, startY) point to (endX, endY) point
Draw.prototype.drawStrokes = function(n, startX, startY, endX, endY){
  objRef.resetTimer();
  for (var i = 1; i <= n; i++){
    objRef.doSetTimeout(startX, startY, penHeight, 250);
    objRef.doSetTimeout(endX, endY, penHeight, 250);
    objRef.doSetTimeout(startX, startY, -140, 250);
  }
  objRef.doSetTimeout(0, 0, -140, 500);
}

//Draws n points on (x, y)
Draw.prototype.drawPoints = function(n, x, y){
  objRef.resetTimer();
  for (var i = 1; i <= n; i++){
    objRef.doSetTimeout(x, y, -140, 250);
    objRef.doSetTimeout(x, y, penHeight, 300);
  }
  objRef.doSetTimeout(0, 0, -140, 500);
}

//A separate setTimeout method so that delays work properly
Draw.prototype.doSetTimeout = function(x, y, z, timeDelay, easing){
  if (!easing) easing = defaultEaseType;
  setTimeout(function() { objRef.go(x, y, z, easing) }, timer);
  timer = timer + timeDelay;
};

// Makes a moves with an ease to this point
Draw.prototype.go = function(x, y, z, easeType){

  var pointB = [x, y, z];

  if (easeType == "none") {
    current = [pointB[0], pointB[1], pointB[2]];
    robotReference.setPosition(pointB[0], pointB[1], pointB[2]);
    return; //Ensures that it doesn't move twice
  } else if (!easeType) {
    easeType = defaultEaseType; 
  }

  var points = motion.getPoints(current, pointB, steps, easeType);

  for (var i = 0; i < points.length; i++) {
    setTimeout(
      function(point){
        current = [point[0], point[1], point[2]];
        robotReference.setPosition(point[0], point[1], point[2])
      },
      i * delay,
      points[i]
    );
    //setTimeout( function(point) { moveServosTo(point[0], point[1], point[2]) }, i * delay, points[i]);
  }

}

Draw.prototype.resetTimer = function(){
  timer = 0;
}

module.exports.Draw = Draw;
