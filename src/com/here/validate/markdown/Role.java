/**
 *  This file is part of the DITA-OT Validation Plug-in project.
 *  See the accompanying LICENSE file for applicable licenses.
 */

package com.here.validate.markdown;

public enum Role {
  FATAL ("fatal"),
  ERROR ("error"),
  WARNING ("warning");
   Role(String text) {
    this.text = text;
  }

   private final String text;

   public String getText() {
     return this.text;
   }
}