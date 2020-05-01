/*
 *  This file is part of the DITA-OT Validation Plug-in project.
 *  See the accompanying LICENSE file for applicable licenses.
 */

package com.here.validate.markdown;

import com.here.validate.markdown.Header;
import com.here.validate.markdown.Xref;
import java.util.ArrayList;
import java.util.List;

public class Analysis {
  private List<Header> headers;
  private List<Xref> xrefs;

  public Analysis(List<Header> headers, List<Xref> xrefs) {
    this.headers = headers;
    this.xrefs = xrefs;
  }

  public List<Header> getHeaders() {
    return this.headers;
  }

  public List<Xref> getXrefs() {
    return this.xrefs;
  }
}
