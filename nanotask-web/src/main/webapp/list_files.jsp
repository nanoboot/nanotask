<%@page import="java.util.Comparator"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="java.util.List"%>
<%@page import="java.io.File"%>
<%@page import="org.nanoboot.octagon.jakarta.utils.OctagonJakartaUtils"%>
<%@page import="org.nanoboot.nanotask.persistence.api.WebsiteRepo"%>
<%@page import="org.nanoboot.nanotask.entity.Website"%>
<%@page import="org.springframework.web.context.support.WebApplicationContextUtils"%>
<%@page import="org.springframework.context.ApplicationContext"%>
<!DOCTYPE>
<%@ page session="false" %>

<!--
 Nanotask.
 Copyright (C) 2023-2023 the original author or authors.

 This program is free software; you can redistribute it and/or
 modify it under the terms of the GNU General Public License
 as published by the Free Software Foundation; version 2
 of the License only.
 
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with this program; if not, write to the Free Software
 Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
-->


<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
    <head>
        <title>List files - Nanotask</title>
        <link rel="stylesheet" type="text/css" href="styles/nanotask.css">
        <link rel="icon" type="image/x-icon" href="favicon.ico" sizes="32x32">
    </head>

    <body>

        <a href="index.jsp" id="main_title">Nanotask</a></span>
        <%
            String number = request.getParameter("number");
            
            if (number == null || number.isEmpty()) {
        %><span style="font-weight:bold;color:red;" class="margin_left_and_big_font">Error: Parameter "number" is required</span>

    <%
            throw new jakarta.servlet.jsp.SkipPageException();
        }
            Integer.valueOf(number);
    %>
    <span class="nav"><a href="index.jsp">Home</a>
        >> <a href="websites.jsp">Websites</a>
        >> <a href="read_website.jsp?number=<%=number%>">Read</a>

        <a href="update_website.jsp?number=<%=number%>">Update</a>


        <a href="show_content.jsp?number=<%=number%>">Show</a>
        <a href="edit_content.jsp?number=<%=number%>">Edit</a>
        <a href="list_files.jsp?number=<%=number%>" class="nav_a_current">List</a>
        <a href="upload_file.jsp?number=<%=number%>">Upload</a>

    </span>

    <%
        if (org.nanoboot.octagon.jakarta.utils.OctagonJakartaUtils.cannotUpdate(request)) {
            out.println("&nbsp;&nbsp;&nbsp;&nbsp;Access forbidden. <br><br> &nbsp;&nbsp;&nbsp;&nbsp;<a href=\"login.html\" target=\"_blank\">Log in</a>");
            throw new jakarta.servlet.jsp.SkipPageException();
        }
    %>


    <%
        String filePath = System.getProperty("nanotask.confpath") + "/" + "websitesFormatted/" + number;
        File dir = new File(filePath);
        if (!dir.exists()) {
            dir.mkdir();
        }
    %>
    <ul style="font-size:120%;line-height:160%;">
        <%
            File[] files = dir.listFiles();
            List<File> filesList = Arrays.asList(files);
            class FileComparator implements Comparator<File> {

                @Override
                public int compare(File file1, File file2) {
                    String file1Name = removeExtension(file1);
                    String file2Name = removeExtension(file2);
                    boolean file1IsNumber = isNumber(file1Name);
                    boolean file2IsNumber = isNumber(file2Name);
                    Integer file1AsNumber = file1IsNumber ? Integer.valueOf(file1Name) : 0;
                    Integer file2AsNumber = file2IsNumber ? Integer.valueOf(file2Name) : 0;
                    if (file1IsNumber && file2IsNumber) {
                        return file1AsNumber.compareTo(file2AsNumber);
                    }
                    if (file1IsNumber && !file2IsNumber) {
                        return -1;
                    }
                    if (!file1IsNumber && file2IsNumber) {
                        return 1;
                    }
                    return file1Name.compareTo(file2Name);
                }

                private boolean isNumber(String string) {
                    try {
                        Integer.valueOf(string);
                        System.err.println("isNumber("+string+")=true");
                        return true;
                    } catch (Exception e) {
                    System.err.println("isNumber("+string+")=false");
                        return false;
                    }

                }

                private String removeExtension(File file) {
                    String fileName = file.getName();
                    if (!fileName.contains(".")) {
                        return fileName;
                    }
                    String[] array = fileName.split("\\.");
                    if (array.length != 2) {
                        return fileName;
                    } else {
                        return array[0];
                    }
                }
            }

            Collections.sort(filesList,
                    new FileComparator());

            for (File f : filesList) {
                if (f.getName().endsWith(".sha512")) {
                    continue;
                }
                
                if (f.isDirectory()) {
                    continue;
                }
        %>
        <li><a href="FileServlet/<%=number%>/<%=f.getName()%>" class="button"><%=f.getName()%></a> <%=(f.isDirectory() ? "(directory)" : ("(file " + f.length() / 1024 ))%> kB )</li>

        <%
            }
            if (files.length
                    == 0) {
                out.println("<p>No files found.</p>");
            }
        %>


    </ul>
</body>
</html>
