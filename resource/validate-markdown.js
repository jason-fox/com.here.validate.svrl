/*
 *  This file is part of the DITA Validator project.
 *  See the accompanying LICENSE file for applicable licenses.
 */

//
//	Validate Markdown and MDITA files to ensure that they are processable by DITA-OT
//
//	@param fileset - list of files to validate
//	@param dir     - the input dir of the Markdown and MDITA files
//	@param todir   - the location to output the SVRL files
//

var pluginDir = project.getProperty("basedir");
var files = attributes.get("fileset").split(";");
var dir = attributes.get("dir");
var toDir = attributes.get("todir");

eval(
  "" +
    org.apache.tools.ant.util.FileUtils.readFully(
      new java.io.FileReader(pluginDir + "/resource/markdown.js")
    )
);

for (var i = 0; i < files.length; i++) {
  if (files[i] !== "") {
    var type = files[i].endsWith("md") ? "markdown" : "mdita";
    var text = org.apache.tools.ant.util.FileUtils.readFully(
      new java.io.FileReader(dir + "/" + files[i])
    );
    var analysis = Markdown.analyseMarkup(text);
    var svrl = Markdown.validateMarkup(files[i], analysis.headers, type);

    Markdown.writeSVRL(files[i], svrl, toDir);
  }
}
