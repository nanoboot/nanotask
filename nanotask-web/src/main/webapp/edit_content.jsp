<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page session="false" %>
<%@page import="java.io.FileWriter"%>
<%@page import="java.io.BufferedWriter"%>
<!DOCTYPE html>

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

    <%@page import="java.util.Scanner"%>
    <%@page import="java.io.File"%>
    <%@page import="org.nanoboot.octagon.jakarta.utils.OctagonJakartaUtils"%>
    <%@page import="org.nanoboot.nanotask.persistence.api.WebsiteRepo"%>
    <%@page import="org.nanoboot.nanotask.entity.Website"%>
    <%@page import="org.springframework.web.context.support.WebApplicationContextUtils"%>
    <%@page import="org.springframework.context.ApplicationContext"%>

    <head>
        <title>Edit content - Nanotask</title>
        <link rel="stylesheet" type="text/css" href="styles/nanotask.css">
        <link rel="stylesheet" type="text/css" href="styles/website.css">
        <link rel="icon" type="image/x-icon" href="favicon.ico" sizes="32x32">
        <style>
            form {
                margin:10px;
                margin-right:20px;
            }
        </style>
    </head>

    <body>

        <a href="index.jsp" id="main_title">Nanotask</a>
        <%
            String number = request.getParameter("number");

            if (number == null || number.isEmpty()) {
        %><span style="font-weight:bold;color:red;" class="margin_left_and_big_font">Error: Parameter "number" is required </span>

        <%
                throw new jakarta.servlet.jsp.SkipPageException();
            }
        %>
        <%
            try {
                Integer.valueOf(number);
            } catch (Exception e) {
                out.println(e.getMessage());
            }
        %>
        <span class="nav"><a href="index.jsp">Home</a>
            >> <a href="websites.jsp">Websites</a>
            >> <a href="read_website.jsp?number=<%=number%>">Read</a>

            <a href="update_website.jsp?number=<%=number%>">Update</a>


            <a href="show_content.jsp?number=<%=number%>">Show</a>
            <a href="edit_content.jsp?number=<%=number%>" class="nav_a_current">Edit</a>
            <a href="list_files.jsp?number=<%=number%>">List</a>
            <a href="upload_file.jsp?number=<%=number%>">Upload</a>
        <a href="add_archive.jsp?number=<%=number%>">Add archive</a>

        </span>

        <%
            if (org.nanoboot.octagon.jakarta.utils.OctagonJakartaUtils.cannotUpdate(request)) {
                out.println("&nbsp;&nbsp;&nbsp;&nbsp;Access forbidden. <br><br> &nbsp;&nbsp;&nbsp;&nbsp;<a href=\"login.html\" target=\"_blank\">Log in</a>");
                throw new jakarta.servlet.jsp.SkipPageException();
            }
        %>

        <%
            String submit_button_save_changes = request.getParameter("submit_button_save_changes");
            String submit_button_preview = request.getParameter("submit_button_preview");
            String submit_button_cancel = request.getParameter("submit_button_cancel");

            if (submit_button_cancel != null) {%><script>function redirectToShow() {
                    window.location.href = 'show_content.jsp?number=<%=number%>'
                }
                redirectToShow();</script><% }
            %>

        <%
            String contentString = null;

            if (submit_button_save_changes == null && submit_button_preview == null) {

                String filePath = System.getProperty("nanotask.confpath") + "/" + "websitesFormatted/" + number;
                File dir = new File(filePath);
                if (!dir.exists()) {
                    dir.mkdir();
                }

                File content = new File(dir, "website.html");
                if (content.exists()) {

                    Scanner sc = new Scanner(content);

                    // we just need to use \\Z as delimiter
                    sc.useDelimiter("\\Z");

                    contentString = sc.next();
                } else {
                    contentString = "";
                }
            } else {
                String contentParameter = request.getParameter("content");
                contentString = contentParameter;
            }
        %>

        <% //if(submit_button_save_changes == null) { %>
        <form action="edit_content.jsp" method="post">
            <input type="submit" name="submit_button_save_changes" value="Save Changes">&nbsp;&nbsp;
            <input type="submit" name="submit_button_preview" value="Preview">&nbsp;&nbsp;
            <input type="submit" name="submit_button_cancel" value="Cancel">&nbsp;&nbsp;
            <input type="hidden" name="number" value="<%=number%>">
            <br>
            <textarea id="content" name="content" lang="en" dir="ltr" rows="20"
                      onChange="flgChange = true;" onKeyPress="flgChange = true;" style="width:100%;font-family:monospace;font-size:150%;margin-top:10px;"><%=contentString%></textarea>
        </form>
        <% //} %>

        <% if (submit_button_preview != null) {
            boolean isAdoc = false;
            isAdoc = contentString.startsWith("_adoc_");
            if(isAdoc) {out.println("<style>" + org.nanoboot.nanotask.web.misc.utils.Constants.ASCIIDOC_CSS + "</style>");}
                out.println("<div>" + OctagonJakartaUtils.convertToAsciidocIfNeeded(contentString.replace("[[FILE]]", "FileServlet/" + number + "/")) + "</div>");
            }
        %>
        <% if (submit_button_save_changes

            
                != null) {

                String filePath = System.getProperty("nanotask.confpath") + "/" + "websitesFormatted/" + number;
                File dir = new File(filePath);
                if (!dir.exists()) {
                    dir.mkdir();
                }

                File content = new File(dir, "website.html");

                if (content.exists()) {

                    Scanner sc = new Scanner(content);

                    // we just need to use \\Z as delimiter
                    sc.useDelimiter("\\Z");

                    String contentString2 = sc.next();
                    SimpleDateFormat dt = new SimpleDateFormat("yyyyMMdd.hhmmss");
                    Date currentDate = new Date();
                    File contentBackupDir = new File(content.getParentFile().getAbsolutePath() + "/content_backup/");
                    if (!contentBackupDir.exists()) {
                        contentBackupDir.mkdir();
                    }
                    String backupFileName = content.getName() + "." + dt.format(currentDate) + ".backup";
                    File backupFile = new File(contentBackupDir, backupFileName);
                    BufferedWriter writer = new BufferedWriter(new FileWriter(backupFile));
                    writer.write(contentString2);

                    writer.close();

                }

                String str = contentString;
                BufferedWriter writer = new BufferedWriter(new FileWriter(content));
                writer.write(str);

                writer.close();

        %>
        <script>
            function redirectToRead() {
                window.location.href = 'show_content.jsp?number=<%=number%>'
            }
            redirectToRead();
        </script>


        <%
            }

        %>


    </body>
</html>
