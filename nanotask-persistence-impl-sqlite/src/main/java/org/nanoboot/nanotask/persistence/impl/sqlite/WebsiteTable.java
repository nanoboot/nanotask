///////////////////////////////////////////////////////////////////////////////////////////////
// Nanotask.
// Copyright (C) 2023-2023 the original author or authors.
//
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; version 2
// of the License only.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
///////////////////////////////////////////////////////////////////////////////////////////////
package org.nanoboot.nanotask.persistence.impl.sqlite;

/**
 *
 * @author robertvokac
 */
public class WebsiteTable {
    public static final String TABLE_NAME = "WEBSITE";
    
    public static final String NUMBER = "NUMBER";
    public static final String URL = "URL";
    public static final String ARCHIVES = "ARCHIVES";
    public static final String WEB_ARCHIVE_SNAPSHOT = "WEB_ARCHIVE_SNAPSHOT";
    public static final String LANGUAGE = "LANGUAGE";
    //
    public static final String CONTENT_VERIFIED = "CONTENT_VERIFIED";
    public static final String ARCHIVE_VERIFIED = "ARCHIVE_VERIFIED";
    //
    public static final String VARIANT_NUMBER = "VARIANT_NUMBER";
    public static final String COMMENT = "COMMENT";
    public static final String RECORDING_ID = "RECORDING_ID";
    public static final String RECORDING_COMMENT = "RECORDING_COMMENT";
    
    
    private WebsiteTable() {
        //Not meant to be instantiated.
    }
    
}
