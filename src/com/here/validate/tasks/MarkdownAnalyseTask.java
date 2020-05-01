/*
 *  This file is part of the DITA-OT Validation Plug-in project.
 *  See the accompanying LICENSE file for applicable licenses.
 */

package com.here.validate.tasks;

import com.here.validate.markdown.Analysis;
import com.here.validate.markdown.Header;
import com.here.validate.markdown.Xref;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;
import org.apache.tools.ant.Task;
import org.apache.tools.ant.types.FileSet;

//
//  Copy existing file to avoid running a real text-speech service
//

public class MarkdownAnalyseTask extends Task {
  protected Pattern regex;
  /**
   * Field files.
   */
  protected List<FileSet> filesets;
  /**
   * Field dir.
   */
  protected String dir;
  /**
   * Field dir.
   */
  protected String toDir;

  /**
   * Creates a new <code>MarkdownAnalyseTask</code> instance.
   */
  public MarkdownAnalyseTask() {
    super();
    this.filesets = new ArrayList<>();
    this.dir = null;
    this.toDir = null;
    this.regex = Pattern.compile("\\[.*\\]\\(.*\\)", Pattern.CASE_INSENSITIVE);
  }

  private void addXref(String line, List<Xref> xrefs) {
    String[] x = line.split("](");
    for (int j = 1; j < x.length; j = j + 2) {
      String href = x[j].split(")")[0];
      xrefs.add(new Xref(href, href.contains(":")));
    }
  }

  private void setParentLevel(List<Header> headers) {
    int current = (headers.size() - 1);
    for (int j = current; j > 0; j--) {
      if (headers.get(j).getDepth() < headers.get(current).getDepth()) {
        headers.get(current).setParent(j);
        break;
      }
    }
  }

  private void setExpectedLevel(List<Header> headers) {
    for (Header header : headers) {
      if (
        header.getExpectedDepth() >
        headers.get(header.getParent()).getExpectedDepth()
      ) {
        header.setExpectedDepth(
          headers.get(header.getParent()).getExpectedDepth() + 1
        );
      }
    }
  }

  private int getHeaderLevel(String string) {
    int level = 0;
    while (level < string.length()) {
      if (string.charAt(level) != 35) {
        break;
      }
      level++;
    }
    return level;
  }

  protected Analysis analyseMarkup(String markup) {
    boolean codeblock = false;
    List<Header> headers = new ArrayList<>();
    List<Xref> xrefs = new ArrayList<>();

    int i = 0;
    for (String line : markup.split("\n")) {
      if (line.startsWith("```")) {
        codeblock = !codeblock;
      } else if (!codeblock) {
        if (line.startsWith("#")) {
          headers.add(
            new Header(
              i,
              line,
              getHeaderLevel(line),
              i > 0 ? getHeaderLevel(line) : 1,
              0
            )
          );
          setParentLevel(headers);
        } else if (this.regex.matcher(line).matches()) {
          addXref(line, xrefs);
        }
      }
      i++;
    }

    setExpectedLevel(headers);

    return new Analysis(headers, xrefs);
  }

  /**
   * Method setFiles.
   *
   * @param set FileSet
   */
  public void addFileset(FileSet set) {
    this.filesets.add(set);
  }

  /**
   * Method setDir.
   *
   * @param dir String
   */
  public void setDir(String dir) {
    this.dir = dir;
  }

  /**
   * Method setToDir.
   *
   * @param toDir String
   */
  public void setToDir(String toDir) {
    this.toDir = toDir;
  }
}
