/**
 *  This file is part of the DITA-OT Validation Plug-in project.
 *  See the accompanying LICENSE file for applicable licenses.
 */

package com.here.validate.markdown;

public enum Diagnostic {
  TEXT_BEFORE_HEADER(
    "text-before-header",
    "Text was found before the first header",
    Role.WARNING.getText()
  ),
  HEADERS_NOT_FOUND("headers-not-found", 
    "No Headers found in file", 
    Role.ERROR.getText()),
  HEADER_DEPTH_INVALID(
    "header-depth-invalid",
    "Header depth invalid - expected %1 but was %2",
    Role.ERROR.getText()
  ),
  HEADER_DEPTH_TOO_DEEP(
    "header-depth-too-deep",
    "Header depth too deep - level %1 is not allowed in MDITA",
    Role.ERROR.getText()
  );

  private final String text;
  private final String role;
  private final String id;
 
  Diagnostic(String id, String text, String role) {
    this.id = id;
    this.text = text;
    this.role = role;
  }

  private String getErrorText(String arg1, String arg2) {
    return this.text.replace("%1", arg1).replace("%2", arg2);
  }

  public String failedAssert(Header header) {
    return this.failedAssert(
        header.getLine(),
        "h" + String.valueOf(header.getDepth()),
        String.valueOf(header.getExpectedDepth()),
        String.valueOf(header.getDepth())
      );
  }

  public String failedAssert(int line, String element) {
    return this.failedAssert(line, element, "", "");
  }

  private String failedAssert(
    int line,
    String element,
    String arg1,
    String arg2
  ) {
    String failure =
      "\t<failed-assert role=\"" + this.role + "\" location=\"\">\n";
    failure =
      failure + "\t\t<diagnostic-reference diagnostic=\"" + this.id + "\">";
    failure =
      failure + "Line " + line + ": " + element + " - [" + this.id + "]\n";
    failure = failure + this.getErrorText(arg1, arg2);
    failure = failure + "\t\t</diagnostic-reference>\n";
    failure = failure + "\t</failed-assert>\n";

    return failure;
  }
}
