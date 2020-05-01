/*
 *  This file is part of the DITA-OT Validation Plug-in project.
 *  See the accompanying LICENSE file for applicable licenses.
 */

package com.here.validate.tasks;

import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.Task;

//
// Add ansi color tags to output if requested.
//

public class ResultEchoTask extends Task {
  /**
   * Field message.
   */
  private String message;

  /**
   * Creates a new <code>ResultEchoTask</code> instance.
   */
  public ResultEchoTask() {
    super();
    this.message = null;
  }

  /**
   * Method setmessage.
   *
   * @param message String
   */
  public void setMessage(String message) {
    String escapeCode = Character.toString((char) 27);
    boolean colorize = "true".equals(getProject().getProperty("cli.color"));

    if (colorize) {
      message = message.replace("[FATAL", escapeCode + "[31m[FATAL");
      message = message.replace("[ERROR", escapeCode + "[31m[ERROR");
      message = message.replace("[WARN", escapeCode + "[33m[WARN");
      message = message.replace("[INFO", escapeCode + "[34m[INFO");
      message = message.replace("\n", escapeCode + "[0m\n");
    }
    this.message = message;
  }

  /**
   * Method execute.
   *
   * @throws BuildException if something goes wrong
   */
  @Override
  public void execute() {
    //  @param message - The string to colorize
    if (message == null) {
      throw new BuildException("You must supply a message to display");
    }

    getProject().log("", 1);
    getProject().log(message, 1);
  }
}
