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
    <%@ page session="false" %>

    <%@page import="java.util.Scanner"%>
    <%@page import="java.io.File"%>
    <%@page import="org.nanoboot.octagon.jakarta.utils.OctagonJakartaUtils"%>
    <%@page import="org.nanoboot.nanotask.persistence.api.WebsiteRepo"%>
    <%@page import="org.nanoboot.nanotask.entity.Website"%>
    <%@page import="org.springframework.web.context.support.WebApplicationContextUtils"%>
    <%@page import="org.springframework.context.ApplicationContext"%>

    <head>
        <title>Show content - Nanotask</title>
        <link rel="stylesheet" type="text/css" href="styles/nanotask.css">
        <link rel="stylesheet" type="text/css" href="styles/website.css">
        <link rel="icon" type="image/x-icon" href="favicon.ico" sizes="32x32">
    </head>

    <body>

        <a href="index.jsp" id="main_title">Nanotask</a>
        <%
            String number = request.getParameter("number");
            Integer numberInteger = Integer.valueOf(number);
            if (number == null || number.isEmpty()) {
        %><span style="font-weight:bold;color:red;" class="margin_left_and_big_font">Error: Parameter "number" is required </span>

        <%
                throw new jakarta.servlet.jsp.SkipPageException();
            }
        %>
        <span class="nav" style="margin-bottom:0;"><a href="index.jsp">Home</a>
            >> <a href="websites.jsp">Websites</a>
            >> <a href="read_website.jsp?number=<%=number%>">Read</a>

            <a href="update_website.jsp?number=<%=number%>">Update</a>


            <a href="show_content.jsp?number=<%=number%>" class="nav_a_current">Show</a>
            <a href="edit_content.jsp?number=<%=number%>">Edit</a>
            <a href="list_files.jsp?number=<%=number%>">List</a>
            <a href="upload_file.jsp?number=<%=number%>">Upload</a>


        </span>
        <script>
            function redirectToEdit() {
                window.location.href = 'edit_content.jsp?number=<%=number%>'

            }

        </script>  

        <%
            if (org.nanoboot.octagon.jakarta.utils.OctagonJakartaUtils.cannotUpdate(request)) {
                out.println("&nbsp;&nbsp;&nbsp;&nbsp;Access forbidden. <br><br> &nbsp;&nbsp;&nbsp;&nbsp;<a href=\"login.html\" target=\"_blank\">Log in</a>");
                throw new jakarta.servlet.jsp.SkipPageException();
            }
        %>

        <p class="margin_left_and_big_font" style="background:white;margin:0;padding-top:20px;">
            <a href="show_content.jsp?number=<%=numberInteger - 1%>" class="button">Previous</a> 
            <a href="show_content.jsp?number=<%=numberInteger + 1%>" class="button">Next</a>
        </p>
        
        <%
            String filePath = System.getProperty("nanotask.confpath") + "/" + "websitesFormatted/" + number;
            File dir = new File(filePath);
            if (!dir.exists()) {
                dir.mkdir();
            }

            File content = new File(dir, "website.html");
            boolean isAdoc = false;
            if (content.exists()) {

                Scanner sc = new Scanner(content);

                // we just need to use \\Z as delimiter
                sc.useDelimiter("\\Z");

                String contentString = sc.next();
                isAdoc = contentString.startsWith("_adoc_");
                contentString = OctagonJakartaUtils.convertToAsciidocIfNeeded(contentString.replace("[[FILE]]", "FileServlet/" + number + "/"));
            
                if(isAdoc) {out.println("<style>" + org.nanoboot.nanotask.web.misc.utils.Constants.ASCIIDOC_CSS + "</style>");}
                out.println("<div id=\"content\" ondblclick = \"redirectToEdit()\" style=\"padding-left:20px;padding-right:20px;\">" + contentString + "</div>");
            } else {
                out.println("<p>No content found</p>");
            }
        %>


    </body>
</html>
