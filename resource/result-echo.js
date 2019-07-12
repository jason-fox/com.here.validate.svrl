/*
 *  This file is part of the DITA Validator project.
 *  See the accompanying LICENSE file for applicable licenses.
 */

//
// Add ansi color tags to output if requested.
//
//	@param message - The string to colorize

var escapeCode = String.fromCharCode(27);
var lf = String.fromCharCode(10);
var input = attributes.get("message");

var colorize = project.getProperty("cli.color");

if (colorize) {
  input = input.replaceAll("\\[FATAL", escapeCode + "[31m[FATAL");
  input = input.replaceAll("\\[ERROR", escapeCode + "[31m[ERROR");
  input = input.replaceAll("\\[WARN", escapeCode + "[33m[WARN");
  input = input.replaceAll("\\[INFO", escapeCode + "[34m[INFO");
  input = input.replaceAll("\\n", escapeCode + "[0m" + lf);
}

project.log(input, 1);
