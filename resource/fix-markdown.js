/*
 *  This file is part of the DITA Validator project.
 *  See the accompanying LICENSE file for applicable licenses.
 */

//
//	Fix up Markdown and MDITA files so that they are processable by DITA-OT
//
//	@param fileset - list of files to fix
//	@param dir     - the input dir of the source files
//	@param level   - the location to output the fixed files
//

var pluginDir = project.getProperty("dita.plugin.com.here.validate.svrl.dir");
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
    var fixedText = Markdown.fixMarkup(text, analysis.headers, type);
    Markdown.writeMarkup(files[i], fixedText, toDir);
  }
}
