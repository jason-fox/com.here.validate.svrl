/*
 *  This file is part of the DITA-OT Validation Plug-in project(.
 *  See the accompanying LICENSE file for applicable licenses.
 */

package com.here.validate.tasks;

import com.here.validate.markdown.Analysis;
import com.here.validate.markdown.Header;
import com.here.validate.markdown.MarkdownAnalyseTask;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.taskdefs.Echo;
import org.apache.tools.ant.util.FileUtils;

// Fix up Markdown and MDITA files so that they are processable by DITA-OT

public class MarkdownFixTask extends MarkdownAnalyseTask {

  /**
   * Creates a new <code>MarkdownFixTask</code> instance.
   */
  public MarkdownFixTask() {
    super();
  }

  private String correctMDITA(Header header) {
    switch (header.getExpectedDepth()) {
      case 1:
        return "#" + header.getText().substring(header.getDepth());
      case 2:
        return "##" + header.getText().substring(header.getDepth());
      default:
        return (
          "**" + header.getText().substring(header.getDepth()).trim() + "**"
        );
    }
  }

  private String correctMarkdown(Header header) {
    String prefix = null;
    switch (header.getExpectedDepth()) {
      case 1:
        prefix = "#";
        break;
      case 2:
        prefix = "##";
        break;
      case 3:
        prefix = "###";
        break;
      case 4:
        prefix = "####";
        break;
      case 5:
        prefix = "#####";
        break;
      default:
        prefix = "######";
    }
    return prefix + header.getText().substring(header.getDepth());
  }

  private String fixMarkup(String markup, List<Header> headers, String type) {
    int count = 0;
    List<String> output = new ArrayList<>();

    for (String line : markup.split("\n")) {
      if (count < headers.size() && line.equals(headers.get(count).getText())) {
        if ("markdown".equals(type)) {
          line = correctMarkdown(headers.get(count));
        } else if ("mdita".equals(type)) {
          line = correctMDITA(headers.get(count));
        }
        count++;
      }
      if (count > 0) {
        output.add(line);
      }
    }

    return String.join("\n", output);
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
    if (this.files == null) {
      throw new BuildException("You must supply a set of files");
    }

    try {
      for (String file : files) {
        if (!"".equals(file)) {
          String type = file.endsWith("md") ? "markdown" : "mdita";
          String text = FileUtils.readFully(
            new java.io.FileReader(dir + "/" + file)
          );
          Analysis analysis = analyseMarkup(text);
          Echo task = (Echo) getProject().createTask("echo");
          task.setFile(new java.io.File(toDir + "/" + file));
          task.setMessage(fixMarkup(text, analysis.getHeaders(), type));
          task.perform();
        }
      }
    } catch (IOException e) {
      throw new BuildException("Unable to read file", e);
    }
  }
}
