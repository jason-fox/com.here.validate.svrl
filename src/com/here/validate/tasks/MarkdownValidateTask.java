/*
 *  This file is part of the DITA-OT Validation Plug-in project(.
 *  See the accompanying LICENSE file for applicable licenses.
 */

package com.here.validate.tasks;

import com.here.validate.markdown.Diagnostic;
import com.here.validate.markdown.Header;
import java.io.IOException;
import java.util.List;
import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.DirectoryScanner;
import org.apache.tools.ant.taskdefs.Echo;
import org.apache.tools.ant.types.FileSet;
import org.apache.tools.ant.util.FileUtils;

// Validate Markdown and MDITA files to ensure that they are processable by DITA-OT

public class MarkdownValidateTask extends MarkdownAnalyseTask {

  /**
   * Creates a new <code>MarkdownValidateTask</code> instance.
   */
  public MarkdownValidateTask() {
    super();
  }

  private String validateMarkup(
    String file,
    List<Header> headers,
    String type
  ) {
    String svrl =
      "<?xml version=\"1.0\" encoding=\"utf-8\" standalone=\"yes\"?>\n" +
      "<schematron-output xmlns:svrl=\"http://purl.oclc.org/dsdl/svrl\">\n" +
      "\t<active-pattern role=\"" +
      type +
      "\" name=\"/" +
      file +
      "\"/>\n" +
      "\t<fired-rule context=\"common\" role=\"structure\"/>\n";

    if (headers.isEmpty()) {
      svrl += Diagnostic.HEADERS_NOT_FOUND.failedAssert(1, "p");
    } else if (headers.get(0).getLine() > 0) {
      svrl += Diagnostic.TEXT_BEFORE_HEADER.failedAssert(1, "p");
    }

    if ("markdown".equals(type)) {
      for (Header header : headers) {
        //getProject().log(header.toString(), 0);

        if (header.isInvalid()) {
          svrl += Diagnostic.HEADER_DEPTH_INVALID.failedAssert(header);
        }
      }
    } else if ("mdita".equals(type)) {
      for (Header header : headers) {
        if (header.isTooDeep()) {
          svrl += Diagnostic.HEADER_DEPTH_TOO_DEEP.failedAssert(header);
        } else if (header.isInvalid()) {
          svrl += Diagnostic.HEADER_DEPTH_INVALID.failedAssert(header);
        }
      }
    }

    svrl = svrl + "</schematron-output>\n";
    return svrl;
  }

  /**
   * Method execute.
   *
   * @throws BuildException if something goes wrong
   */
  @Override
  public void execute() {
    //    @param toDir - The output location of the files
    //    @param dir  - The location of the files to process
    //    @param files - A set of files
    if (this.dir == null) {
      throw new BuildException("You must supply a source directory");
    }
    if (this.toDir == null) {
      throw new BuildException("You must supply a destination directory");
    }

    try {
      for (FileSet fileset : this.filesets) {
        DirectoryScanner scanner = fileset.getDirectoryScanner(getProject());
        scanner.scan();
        for (String file : scanner.getIncludedFiles()) {
          String type = file.endsWith("md") ? "markdown" : "mdita";
          String text = FileUtils.readFully(
            new java.io.FileReader(dir + "/" + file)
          );
          Echo task = (Echo) project.createTask("echo");
          task.setFile(
            new java.io.File(
              toDir +
              "/" +
              file.substring(0, file.lastIndexOf('.')) +
              ".svrl.xml"
            )
          );
          task.setMessage(
            validateMarkup(file, analyseMarkup(text).getHeaders(), type)
          );
          task.perform();
        }
      }
    } catch (IOException e) {
      throw new BuildException("Unable to read file", e);
    } catch (Exception e) {
      getProject().log(e.toString(), 0);
      throw e;
    }
  }
}
