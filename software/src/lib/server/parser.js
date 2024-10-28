/*
Copyright (c) 2011-2016, Tapster Committers
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

var ArgumentParser = require('argparse').ArgumentParser;

// parse arguments
var parser =  new ArgumentParser({
  version: '0.0.1',
  addHelp:true,
  description: 'Tapster Server'
});

parser.addArgument(
  [ '-c', '--calibration'], {
    help: 'file to load calibration data from'
  });

parser.addArgument(
  ['-p', '--port'] , {
    defaultValue: 4242
    , required: false
    , type: 'int'
    , example: "4242"
    , help: 'port to listen on'
  });

parser.addArgument(
  ['-a', '--address'], {
    defaultValue: '127.0.0.1'
    , required: false
    , example: "127.0.0.1"
    , help: 'IP address to listen on'
  });

module.exports = parser;
