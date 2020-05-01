/*
 *  This file is part of the DITA-OT Validation Plug-in project.
 *  See the accompanying LICENSE file for applicable licenses.
 */

package com.here.validate.markdown;

public class Header {
  private int line;
  private String text;
  private int depth;
  private int expectedDepth;
  private int parent;

  public Header(
    int line,
    String text,
    int depth,
    int expectedDepth,
    int parent
  ) {
    this.line = line;
    this.text = text;
    this.depth = depth;
    this.expectedDepth = expectedDepth;
    this.parent = parent;
  }

  public int getLine() {
    return this.line;
  }

  public String getText() {
    return this.text;
  }

  public int getDepth() {
    return this.depth;
  }

  public int getExpectedDepth() {
    return this.expectedDepth;
  }

  public int getParent() {
    return this.parent;
  }

  public void setLine(int line) {
    this.line = line;
  }

  public void setText(String text) {
    this.text = text;
  }

  public void setDepth(int depth) {
    this.depth = depth;
  }

  public void setExpectedDepth(int expectedDepth) {
    this.expectedDepth = expectedDepth;
  }

  public void setParent(int parent) {
    this.parent = parent;
  }

  public boolean isInvalid() {
    return this.depth != this.expectedDepth;
  }

  public boolean isTooDeep() {
    return this.expectedDepth > 2;
  }

  @Override
  public String toString() {
    return (
      " line: " +
      String.valueOf(line) +
      " text: " +
      text +
      " depth: " +
      String.valueOf(depth) +
      " expectedDepth: " +
      String.valueOf(expectedDepth) +
      " parent: " +
      String.valueOf(parent)
    );
  }
}
