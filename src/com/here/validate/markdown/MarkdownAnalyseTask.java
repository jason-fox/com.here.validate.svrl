/*
 *  This file is part of the DITA-OT Validation Plug-in project.
 *  See the accompanying LICENSE file for applicable licenses.
 */

package com.here.validate.markdown;

import com.here.validate.markdown.Analysis;
import com.here.validate.markdown.Header;
import com.here.validate.markdown.Xref;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;
import org.apache.tools.ant.Task;

//
//  Copy existing file to avoid running a real text-speech service
//

public class MarkdownAnalyseTask extends Task {
  protected Pattern regex;
  /**
   * Field files.
   */
  protected String[] files;
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
    this.files = null;
    this.dir = null;
    this.toDir = null;
    this.regex = Pattern.compile("\\[.*\\]\\(.*\\)", Pattern.CASE_INSENSITIVE);
  }

  private int headerLevel(String string) {
    int level = 0;
    while (level < string.length()) {
      if (!"#".equals(string.charAt(level))) {
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
              headerLevel(line),
              i > 0 ? headerLevel(line) : 1,
              0
            )
          );

          int current = (headers.size() - 1);
          for (int j = current; j > 0; j--) {
            if (headers.get(j).getDepth() < headers.get(current).getDepth()) {
              headers.get(current).setParent(j);
              break;
            }
          }
        } else if (this.regex.matcher(line).matches()) {
          String[] x = line.split("](");
          for (int j = 1; j < x.length; j = j + 2) {
            String href = x[j].split(")")[0];
            xrefs.add(new Xref(href, href.contains(":")));
          }
        }
      }
      i++;
    }

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

    return new Analysis(headers, xrefs);
  }

  /**
   * Method setFiles.
   *
   * @param files String
   */
  public void setfiles(String files) {
    this.files = files.split(";");
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
