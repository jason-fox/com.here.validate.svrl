/*
 *  This file is part of the DITA-OT Validation Plug-in project.
 *  See the accompanying LICENSE file for applicable licenses.
 */

package com.here.validate.markdown;

public class Xref {
  private String href;
  private boolean external;

  public Xref(String href, boolean external) {
    this.href = href;
    this.external = external;
  }
}
