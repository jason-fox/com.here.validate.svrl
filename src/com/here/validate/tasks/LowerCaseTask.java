/*
 *  This file is part of the DITA-OT Validation Plug-in project.
 *  See the accompanying LICENSE file for applicable licenses.
 */

package com.here.validate.tasks;

import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.Task;

//
//  Copy existing file to avoid running a real text-speech service
//

public class LowerCaseTask extends Task {
  /**
   * Field string.
   */
  private String string;

  /**
   * Field to.
   */
  private String to;

  /**
   * Creates a new <code>LowerCaseTask</code> instance.
   */
  public LowerCaseTask() {
    super();
    this.string = null;
    this.to = null;
  }

  /**
   * Method setString.
   *
   * @param string String
   */
  public void setString(String string) {
    this.string = string;
  }

  /**
   * Method setTo.
   *
   * @param to String
   */
  public void setTo(String to) {
    this.to = to;
  }

  /**
   * Method execute.
   *
   * @throws BuildException if something goes wrong
   */
  @Override
  public void execute() {
    //  @param  string -   The value to convert
    //  @param  to -  The property to set
    //
    if (this.to == null) {
      throw new BuildException("You must supply a property to set");
    }
    if (this.string == null) {
      throw new BuildException("You must supply a value to convert");
    }
    getProject().setProperty(this.to, this.string.toLowerCase());
  }
}
