/*
Copyright (c) 2009-2018 by SVG-edit authors (see AUTHORS file)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

[This is the MIT License, https://opensource.org/licenses/MIT]
*/


// Draws stuff from SVG files
// See project on GitHub: https://github.com/SVG-Edit/svgedit
// Previsouly picked from "demo" folder, and adapter for these softwares
//
// > To test:
// > svgRead.drawSVG(filepath)


/* ************
 * Useful tools
 * ************/

 var parse = require('svg-path-parser');
 var fs = require('fs');
 var draw = require("./draw");
 var xml2jsParseString = require('xml2js').parseString;
 var motion = require("./motion");

/* ********* *
 * Variables *
 * ********* */

var firstPoint;

var objArr;
var pathArray;

var widthRatio;
var heightRatio;
var halfway;
var currentPoint;
var penHeight;
var delay, loaded, fontFile;
var transformX, transformY, objRef, connected, startTime, endTime, difference, clockTimer, firstMove, lastNum1, lastNum2, connect, baseWidth, baseHeight;

var robotReference;
var drawer;

/* **************************
 * Definition of super object
 * **************************/

 function SVGDraw(args, robot) {

 	this.baseWidth = 80;
 	this.baseHeight = 95;
 	this.drawHeight = -150;
 	this.delay = 150;
 	this.defaultEaseType = "linear";

 	if (args) {
 		var keys = Object.keys(args)
 		keys.forEach(function(key){
 			this[key] = args[key]
 		}, this)
 	}

 	objRef = this;
 	defaultEaseType = this.defaultEaseType;
	robotReference = robot;
	drawer = new draw.Draw(null, robotReference);

 }

/* ********************* *
 * Defintions of methods *
 * ********************* */

//Draws from an SVG image specified using its raw content
//Note: fconnect is a special flag that indicates that each path should be drawn connected to each other
//It is really only used for drawing in cursive and does not need to be specified otherwise
SVGDraw.prototype.drawSVG = function(content, connect) {

	drawer.resetTimer();
	var parsed;

	if (connect) connected = connect;
	else connected = null;

	objRef = this;

	//Create a JSON string out of the SVG image data
	//parseString strips away the XML data
	try {
		xml2jsParseString(content, function(err, result) {
			parsed = JSON.stringify(result, null, 1);
		});
	} catch (e) {
		console.error(e);
		throw e;
	}

	//Parse the JSON string into an array
	objArr = JSON.parse(parsed);

	//Extract width and height data from the drawing
	var svgDimensions = dimensionConversion(objArr.svg.$.width, objArr.svg.$.height);
	width = svgDimensions.width;
	height = svgDimensions.height; 

	var phoneWidth = this.baseWidth;
	var phoneHeight = this.baseHeight;
	penHeight = this.drawHeight;

	widthRatio = width / phoneWidth;
	heightRatio = height / phoneHeight;

	//Start at the center of the canvas, which corresponds to (0,0) on the Tapster
	halfway = {x:width / 2, y:height / 2};
	currentPoint = {x:halfway.x, y:halfway.y};

 	//If there are multiple groups. Additional check to make sure that there is actually path data
 	if (objArr.svg.g[0].g && objArr.svg.g[0].g[0].path) {
 		for (var i = 0; i < objArr.svg.g[0].g.length; i++) {
 			pathArray = objArr.svg.g[0].g[i].path;
 			drawImage(pathArray);
 		} 
 	}
 	//Depending on how the paths are grouped, it is possible that this value can be greater than zero
 	else if (objArr.svg.g.length > 0) {
		//If this is the case, loop through the array to get the path data
		for (var i = 0; i < objArr.svg.g.length; i++) { 
			pathArray = objArr.svg.g[i].path;
			drawImage(pathArray);
		}
	}
	//If there is only one group
	else if (objArr.svg.g[0].path) { 
		pathArray = objArr.svg.g[0].path;
		drawImage(pathArray);
	}

	drawer.doSetTimeout(0, 0, -130, delay);

}

drawImage = function(pathArray) {
	var d = "";
	//After a group is done being drawn, firstMove is reset as there has not yet been a first move made in the next group
	firstMove = null; 
	//When drawing multiple lines, there are multiple paths
	for (var i = 0; i < pathArray.length; i++) { 
		firstPoint = null;
		d = pathArray[i].$.d; 
		var commands = parse(d);
		objRef.interpretCommands(commands); 
	}
	drawer.doSetTimeout(mapX(currentPoint.x), mapY(currentPoint.y), penHeight + 10, delay);
}

//Move from one point to (x, y)
move = function(x, y) {
	var ptArray = [];
	//If the paths should not be connected, lift up the pen and move over so that a line is not drawn
	if (!connected) { 
		drawer.doSetTimeout(mapX(currentPoint.x), mapY(currentPoint.y), penHeight + 10, delay, "none");
		drawer.doSetTimeout(mapX(x), mapY(y), penHeight + 10, delay, "none");
		drawer.doSetTimeout(mapX(x), mapY(y), penHeight, delay, "none");
	}
	//If the paths should be connected and a move has not been made, lift up the pen and move to the first point
	else if (connected && !firstMove) {
		drawer.doSetTimeout(mapX(currentPoint.x), mapY(currentPoint.y), penHeight + 10, delay, "none");
		drawer.doSetTimeout(mapX(x), mapY(y), penHeight + 10, delay, "none");
		drawer.doSetTimeout(mapX(x), mapY(y), penHeight, delay, "none");
	}
	else //If the paths should be connected and a move has been made, just draw a line between the two paths
		drawer.doSetTimeout(mapX(x), mapY(y), penHeight, delay);

	currentPoint = {x:x, y:y}; //Update the current point (done every time an SVG command is called)

	if (!firstMove) //Keeps track of if a move has been made or not.
		firstMove = true;

	if (!firstPoint) //Keeps track of the first point, for use with the Z/z command
		firstPoint = {x:currentPoint.x, y:currentPoint.y}; //Since the first command of a path is always to Move, this check only occurs here

}

//Move from one point to that that point + x, y
relMove = function(x, y) {
	x = currentPoint.x + x;
	y = currentPoint.y + y;
	move(x, y);
}

//Draw a line from one point to (x, y)
line = function(x, y) {
	var ptArray = [];
	drawer.doSetTimeout(mapX(x), mapY(y), penHeight, delay, "linear");
	currentPoint = {x:x, y:y};
}

//Draw a line from one point to that point + x, y
relLine = function(x, y) {
	x = currentPoint.x + x;
	y = currentPoint.y + y;
	line(x, y);
}

//Draws a cubic Bezier curve.
//(x1,y1) is the first control point
//(x2, y2) is the second
//(x, y) is the end point
cubicCurve = function(x1, y1, x2, y2, x, y) {

	//Function for calculating the coordinates of points on the curve
	//Calculates t+1 points
	b = function(x1, y1, x2, y2, x, y, t) {
		var ptArray = new Array();
		for (var i = 0; i <= t; i++) {
			var newI = i/t; //Converts i to a decimal, to satisfy 0 <= i <= 1
			var ptX = (Math.pow((1-newI), 3) * currentPoint.x) + (3 * Math.pow((1-newI), 2) * newI * x1) //From https://en.wikipedia.org/wiki/B%C3%A9zier_curve#Cubic_B.C3.A9zier_curves
			+ (3 * (1-newI) * Math.pow(newI, 2) * x2) + (Math.pow(newI, 3) * x);
			var ptY = (Math.pow((1-newI), 3) * currentPoint.y) + (3 * Math.pow((1-newI), 2) * newI * y1)
			+ (3 * (1-newI) * Math.pow(newI, 2) * y2) + (Math.pow(newI, 3) * y);
			var newPt = {x:ptX, y:ptY, z:penHeight};
			ptArray.push(newPt); //Populates the array with points
		}
		currentPoint = {x:ptArray[t].x, y:ptArray[t].y};
		return ptArray;
	}
	
	var curvePts = new Array();
	curvePts = b(x1, y1, x2, y2, x, y, 5); //Arbitrarily-chosen value. It creates a smooth-looking curve without calculating too many points
	for (var i = 0;i < curvePts.length; i++) 
		drawer.doSetTimeout(mapX(curvePts[i].x), mapY(curvePts[i].y), penHeight, delay*2 / curvePts.length, "none"); //The cubic curve command takes 2*delay ms to complete so that an accurate curve is created
}

//Draws a relative cubic Bezier curve
relCubicCurve = function(x1, y1, x2, y2, x, y) {
	var tempX = currentPoint.x;
	var tempY = currentPoint.y;
	cubicCurve(tempX + x1, tempY + y1, tempX + x2, tempY + y2, tempX + x, tempY + y);	
}

//Draws a quadratic Bezier curve
//(x1, y1) is the control point
//(x, y) is the end point
quadraticCurve = function(x1, y1, x, y) {

	//Helper function for generating the points
	q = function(x1, y1, x, y, t) {
		var ptArray = new Array();
		for (var i = 0; i <= t; i++) {
			var newI = i/t; //Converts i to a decimal, to satisfy 0 <= i <= 1
			var ptX = Math.pow((1-newI), 2)*currentPoint.x + (2 * (1-newI) * newI * x1) + (Math.pow(newI, 2) * x); //From https://en.wikipedia.org/wiki/B%C3%A9zier_curve#Quadratic_B.C3.A9zier_curves
			var ptY = Math.pow((1-newI), 2)*currentPoint.y + (2 * (1-newI) * newI * y1) + (Math.pow(newI, 2) * y);
			var newPt = {x:ptX, y:ptY, z:penHeight};
			ptArray.push(newPt);
		}
		currentPoint = {x:ptArray[t].x, y:ptArray[t].y};
		return ptArray;
	}

	var curvePts = new Array();
	curvePts = q(x1, y1, x, y, 5);
	for (var i = 0; i < curvePts.length; i++) 
		drawer.doSetTimeout(mapX(curvePts[i].x), mapY(curvePts[i].y), penHeight, delay*2 / curvePts.length, "none");

}

//Draws a relative quadratic Bezier curve
relQuadraticCurve = function(x1, y1, x, y) {
	var tempX = currentPoint.x;
	var tempY = currentPoint.y;
	quadraticCurve(tempX + x1, tempY + y1, tempX + x, tempY + y);
}

//Draws an elliptical arc
//rx and ry are the radii
//rotation is the angle (in degrees) between the rotated x-axis and the original x-axis
//largeArc is a flag that determines if the arc is greater than or less than or equal to 180 degrees
//sweep is a flag that determines if the arc is drawn in a positive direction or a negative direction
//(x, y) is the final point of the arc
//From: http://www.w3.org/TR/SVG/implnote.html#ArcImplementationNotes
arc = function(rx, ry, rotation, largeArc, sweep, x, y) {

	//Helper function for calculating the points
	a = function(rx, ry, largeArc, sweep, x, y, t) {
		var ptArray = new Array();

		for (var i = 0; i <= t; i++) {
			var newI = i / t;
			var angle = startAngle + sweepAngle * newI;
			var newPt = {x: cx + rx * cos(angle), y: cy + ry * sin(angle), z:penHeight};
			ptArray.push(newPt);
		}

		currentPoint = {x: ptArray[t].x, y: ptArray[t].y};
		return ptArray;
	}

	//Helper function for calculating the angle between two vectors
	angleBetween = function(v1, v2) {
		var p = v1.x*v2.x + v1.y*v2.y;
		var n = Math.sqrt((Math.pow(v1.x, 2)+Math.pow(v1.y, 2)) * (Math.pow(v2.x, 2)+Math.pow(v2.y, 2)));
		var sign = v1.x*v2.y - v1.y*v2.x < 0 ? -1 : 1;
		var angle = sign*Math.acos(p/n) * 180 / Math.PI;
		
		return angle;
	}

	tempX = currentPoint.x;
	tempY = currentPoint.y;

	var xPrime = (cos(rotation) * ((tempX - x) / 2)) + (sin(rotation) * ((tempY - y) / 2));
	var yPrime = (-sin(rotation) * ((tempX - x) / 2)) + (cos(rotation) * ((tempY - y) / 2));

	//Checks to ensure radii are as they should be
	rx = Math.abs(rx); //Ensures they are non-zero and positive
	ry = Math.abs(ry); 

	var lambda = (Math.pow(xPrime, 2) / Math.pow(rx, 2)) + (Math.pow(yPrime, 2) / Math.pow(ry, 2)); 

	if (lambda > 1) { //Ensures they are large enough
		rx = Math.sqrt(lambda) * rx;
		ry = Math.sqrt(lambda) * ry;
	}		

	var sign = 1;

	if (largeArc == sweep) //If they are equal, cPrime is negative
		sign = -1;

	//For some reason this would occasionally result in NaN
	//Implemented this check at the suggestion of:
	//http://users.ecs.soton.ac.uk/rfp07r/interactive-svg-examples/arc.html
	var cPrimeNumerator = ((Math.pow(rx, 2) * Math.pow(ry, 2)) - (Math.pow(rx, 2) * Math.pow(yPrime, 2)) - (Math.pow(ry, 2) * Math.pow(xPrime, 2)));
	var cPrimeDenom = ((Math.pow(rx, 2) * Math.pow(yPrime, 2)) + (Math.pow(ry, 2) * Math.pow(xPrime, 2)));

	if ((cPrimeNumerator / cPrimeDenom) < 1e-7) 
		cPrime = 0;
	else
		cPrime = Math.sqrt(cPrimeNumerator / cPrimeDenom);

	//Calculates the transformed center
	var cxPrime = sign * cPrime * ((rx * yPrime) / ry);
	var cyPrime = sign * cPrime * (-(ry * xPrime) / rx);

	//Calculates the original center
	var cx = ((cos(rotation) * cxPrime) + (-sin(rotation) * cyPrime)) + ((tempX + x) / 2);
	var cy = ((sin(rotation) * cxPrime) + (cos(rotation) * cyPrime)) + ((tempY + y) / 2);

	//Calculates the start angle of the arc and the total change in the angle
	var startVector = {x: (xPrime - cxPrime) / rx, y: (yPrime - cyPrime) / ry};
	var startAngle = angleBetween({x:1, y:0}, startVector);
	var endVector = {x: (-xPrime - cxPrime) / rx, y: (-yPrime - cyPrime) / ry};
	var sweepAngle = angleBetween(startVector, endVector);

	if (!sweep && sweepAngle > 0) {
		sweepAngle -= 360;
	}

	else if (sweep && sweepAngle < 0) {
		sweepAngle += 360;
	}

	sweepAngle %= 360;

	var ptArray = a(rx, ry, largeArc, sweep, x, y, 5);

	for (var i = 0; i < ptArray.length; i++) {
		drawer.doSetTimeout(mapX(ptArray[i].x), mapY(ptArray[i].y), penHeight, delay*2 / ptArray.length, "none");
	}

}

//Function for drawing a relative elliptical arc
relArc = function(rx, ry, rotation, largeArc, sweep, x, y) {
	x = currentPoint.x + x;
	y = currentPoint.y + y;
	arc(rx, ry, rotation, largeArc, sweep, x, y);
}

//A function for setting the penHeight from the command line
setPenHeight = function(penHeight) {
	penHeight = penHeight;
}

//Reflects the point (x,y) across the point (x1, y1)
//For use with smooth curves
reflect = function(x, y, x1, y1) {
	var tempX = x;
	var tempY = y;

	tempX = x1 - (tempX - x1);
	tempY = y1 - (tempY - y1);

	var point = {x:tempX, y:tempY};

	return point;
}

//Convert points pixel coordinates to Tapster coordinates
//Done in two methods for ease of use
mapX = function(x) {
	var newX = x;
	newX = (newX - halfway.x) / widthRatio; //The center of the canvas corresponds to (0, 0) on the Tapster
	return newX;
};

mapY = function(y) {
	var newY = y;
	newY = (halfway.y - newY) / heightRatio;
	return newY;
}

// A sine function for working with degrees, not radians
sin = function(degree) {
	return Math.sin(Math.PI * (degree/180));
}

// A cosine function for working with degrees, not radians
cos = function(degree) {
	return Math.cos(Math.PI * (degree/180));
}

//Function for converting Inkscape dimensions into Tapster-friendly pixels
//Should switch to switch statements
dimensionConversion = function(width, height) {
	width = String(width);
	if (width.search("mm") != -1) {
		var dimension = {width: parseInt(width) * 3.779527559, height: parseInt(height) * 3.779527559}; //The px:mm ratio is ~ 3.8:1
	}
	else if (width.search("in") != -1) {
		var dimension = {width: parseInt(width) * 96, height: parseInt(height) * 96}; //The px:in ratio is 96:1
	}
	else if (width.search("ft") != -1) {
		var dimension = {width: parseInt(width) * 96 * 12, height: parseInt(height) * 96 * 12}; //The px:ft ratio is 96*12:1
	}
	else if (width.search("m") != -1) {
		var dimension = {width: parseInt(width) * 3.779527559 * 1000, height: parseInt(height) * 3.779527559 * 1000}; //The px:m ratio is ~3.8*1000:1
	}
	else if (width.search("cm") != -1) {
		var dimension = {width: parseInt(width) * 3.779527559 * 100, height: parseInt(height) * 3.779527559 * 100}; //The px:cm ratio is ~3.8*100:1
	}
	else if (width.search("pt") != -1) {
		var dimension = {width: parseInt(width) * 1.3333, height: parseInt(height) * 1.3333}; //The px:pt ratio is ~1.3:1
	}
	else if (width.search("pc") != -1) {
		var dimension = {width: parseInt(width) * 16, height: parseInt(height) * 16}; //The px:pc ratio is 16:1
	}
	else //No unit specified == pixels
		var dimension = {width: width, height: height};

	return dimension;
}

//Goes through the list of commands an generated by the SVG-Path-Parser and calls the corresponding functions
//Should switch to switch statements
SVGDraw.prototype.interpretCommands = function(commands) {
	delay = this.delay;
	for (var i = 0; i < commands.length; i++) {
		var cmdCode = commands[i].code;
		switch (cmdCode) {
			case 'M':	
			move(commands[i].x, commands[i].y);
			break;

			case 'm':
			relMove(commands[i].x, commands[i].y);
			break;

			case 'L': 
			line(commands[i].x, commands[i].y);
			break;

			case 'l':
			relLine(commands[i].x, commands[i].y);
			break;

			case 'V':
			line(currentPoint.x, commands[i].y);
			break;

			case 'v':
			relLine(currentPoint.x, commands[i].y);
			break;

			case 'H':
			line(commands[i].x, currentPoint.y);
			break;

			case 'h':
			relLine(commands[i].x, currentPoint.y);
			break;

			case 'C':
			cubicCurve(commands[i].x1, commands[i].y1, commands[i].x2, commands[i].y2, commands[i].x, commands[i].y);
			break;

			case 'c':
			relCubicCurve(commands[i].x1, commands[i].y1, commands[i].x2, commands[i].y2, commands[i].x, commands[i].y);
			break;

			//Smooth cubic curve
			case 'S':
			if (i > 1 && (commands[i-1].code == 's' || commands[i-1].code == 'c' || commands[i-1].code == 'C' || commands[i-1].code == 'S')) {
				var reflected = reflect(commands[i].x, commands[i].y, commands[i-1].x, commands[i-1].y);
				var ctrl = {x:reflected.x, y:reflected.y};
			}
			else
				var ctrl = {x:currentPoint.x, y:currentPoint.y};

			cubicCurve(ctrl.x, ctrl.y, commands[i].x2, commands[i].y2, commands[i].x, commands[i].y);
			break;

			//Smooth relative cubic curve
			case 's':
			if (i > 1 && (commands[i-1].code == 's' || commands[i-1].code == 'c' || commands[i-1].code == 'C' || commands[i-1].code == 'S')) {
				var reflected = reflect(commands[i].x, commands[i].y, commands[i-1].x, commands[i-1].y);
				var ctrl = {x:reflect(commands[i-1].x2).x, y:reflect(commands[i-1].y2).y};
			}
			else
				var ctrl = {x:currentPoint.x, y:currentPoint.y};

			relCubicCurve(ctrl.x, ctrl.y, commands[i].x2, commands[i].y2, commands[i].x, commands[i].y);
			break;

			case 'Q':
			quadraticCurve(commands[i].x1, commands[i].y1, commands[i].x, commands[i].y);
			break;

			case 'q':
			relQuadraticCurve(commands[i].x1, commands[i].y1, commands[i].x, commands[i].y);
			break;

			//Smooth quadratic curve
			case 'T':
			if (i > 1 && (commands[i-1].code == 't' || commands[i-1].code == 'q' || commands[i-1].code == 'Q' || commands[i-1].code == 'T')) {
				var reflected = reflect(commands[i].x, commands[i].y, commands[i-1].x, commands[i-1].y);
				var ctrl = {x:reflect(commands[i-1].x1).x, y:reflect(commands[i-1].y1).y};
			}
			else
				var ctrl = {x:currentPoint.x, y:currentPoint.y};

			quadraticCurve(ctrl.x, ctrl.y, commands[i].x, commands[i].y);
			break;

			//Smooth relative quadratic curve
			case 't':
			if (i > 1 && (commands[i-1].code == 't' || commands[i-1].code == 'q' || commands[i-1].code == 'Q' || commands[i-1].code == 'T')) {
				var reflected = reflect(commands[i].x, commands[i].y, commands[i-1].x, commands[i-1].y);
				var ctrl = {x:reflect(commands[i-1].x1).x, y:reflect(commands[i-1].y1).y};
			}
			else
				var ctrl = {x:currentPoint.x, y:currentPoint.y};

			relQuadraticCurve(ctrl.x, ctrl.y, commands[i].x, commands[i].y);
			break;

			case 'A':
			arc(commands[i].rx, commands[i].ry, commands[i].xAxisRotation, commands[i].largeArc, commands[i].sweep, commands[i].x, commands[i].y);
			break;

			case 'a':
			relArc(commands[i].rx, commands[i].ry, commands[i].xAxisRotation, commands[i].largeArc, commands[i].sweep, commands[i].x, commands[i].y);
			break;

			case 'Z': 
			line(firstPoint.x, firstPoint.y);
			firstPoint = null;
			break;
			
			case 'z':
			line(firstPoint.x, firstPoint.y);
			firstPoint = null;
			break;
		}
	}
}

module.exports.SVGDraw = SVGDraw;
