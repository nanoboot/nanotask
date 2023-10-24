<%@ page session="false" %>
<%@page import="org.nanoboot.powerframework.time.moment.LocalDate"%>
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

<%@page import="org.nanoboot.nanotask.persistence.api.VariantRepo"%>
<%@page import="org.nanoboot.nanotask.entity.Variant"%>
<%@page import="org.springframework.web.context.support.WebApplicationContextUtils"%>
<%@page import="org.springframework.context.ApplicationContext"%>
<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="org.apache.commons.fileupload.FileUploadException"%>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@page import="org.apache.commons.io.output.*"%>

<!DOCTYPE>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
    <head>
        <title>Nanotask - Add variant</title>
        <link rel="stylesheet" type="text/css" href="styles/nanotask.css">
        <link rel="icon" type="image/x-icon" href="favicon.ico" sizes="32x32">
    </head>

    <body>

        <a href="index.jsp" id="main_title">Nanotask</a></span>

    <span class="nav"><a href="index.jsp">Home</a>
        >> <a href="variants.jsp">Variants</a>
        >> <a href="create_variant.jsp" class="nav_a_current">Add Variant</a></span>

    <%
        if (org.nanoboot.octagon.jakarta.utils.OctagonJakartaUtils.cannotUpdate(request)) {
            out.println("&nbsp;&nbsp;&nbsp;&nbsp;Access forbidden. <br><br> &nbsp;&nbsp;&nbsp;&nbsp;<a href=\"login.html\" target=\"_blank\">Log in</a>");
            throw new jakarta.servlet.jsp.SkipPageException();
        }
    %>
    
    <%
        ApplicationContext context = WebApplicationContextUtils.getWebApplicationContext(getServletContext());
        VariantRepo variantRepo = context.getBean("variantRepoImplSqlite", VariantRepo.class);
    %>


    <%
        String param_name = request.getParameter("name");
        boolean formToBeProcessed = param_name != null && !param_name.isEmpty();
    %>

    <% if (!formToBeProcessed) { %>
    <form action="create_variant.jsp" method="get">
        <table>

            <tr>
                <td><label for="name">Name <b style="color:red;font-size:130%;">*</b>:</label></td>
                <td><input type="text" name="name" value=""></td>
            </tr>
            <tr>
                <td><label for="note">Note:</label></td>
                <td><input type="text" name="note" value=""></td>
            </tr>
            <tr>
                <td><label for="status">Status</label></td>
                <td style="text-align:left;"><input type="text" name="status" value="" ></td>
            </tr>
            <tr>
                <td><label for="author">Author</label></td>
                <td style="text-align:left;"><input type="text" name="author" value="" ></td>
            </tr>
            <tr>
                <td><label for="licence">Licence</label></td>
                <td style="text-align:left;"><input type="text" name="licence" value="" ></td>
            </tr>
            <tr>
                <td><label for="openSource">Open source</label></td>
                <td style="text-align:left;"><input type="checkbox" name="openSource" value="1" ></td>
            </tr>
            <tr>
                <td><label for="userInterface">User interface</label></td>
                <td style="text-align:left;"><input type="text" name="userInterface" value="" ></td>
            </tr>
            <tr>
                <td><label for="programmingLanguage">Programming language</label></td>
                <td style="text-align:left;"><input type="text" name="programmingLanguage" value="" size="5" ></td>
            </tr>
            <tr>
                <td><label for="binariesAvailable">Binaries</label></td>
                <td style="text-align:left;"><input type="checkbox" name="binaries" value="1" ></td>
            </tr>

            <tr>
                <td><label for="lastUpdate">Last update</label></td>
                <td style="text-align:left;"><input type="text" name="lastUpdate" value="" size="10" ></td>
            </tr>
            <tr>
                <td><label for="lastVersion">Last version</label></td>
                <td style="text-align:left;"><input type="text" name="lastVersion" value="" ></td>
            </tr>

            <tr>
                <td><a href="variants.jsp" style="font-size:130%;background:#dddddd;border:2px solid #bbbbbb;padding:2px;text-decoration:none;">Cancel</a></td>
                <td style="text-align:right;"><input type="submit" value="Add"></td>
            </tr>
        </table>
        <b style="color:red;font-size:200%;margin-left:20px;">*</b> ...mandatory


    </form>

    <% } else { %>







    <%
        String param_note = request.getParameter("note");

        String param_status = request.getParameter("status"
                + "");

        String param_author = request.getParameter("author");
        String param_licence = request.getParameter("licence");
        String param_openSource = request.getParameter("openSource");
        String param_userInterface = request.getParameter("userInterface");
        String param_programmingLanguage = request.getParameter("programmingLanguage");
        String param_binaries = request.getParameter("binaries");
        String param_lastUpdate = request.getParameter("lastUpdate");
        String param_lastVersion = request.getParameter("lastVersion");
        //

        //
        Variant newVariant = new Variant(
                0,
                param_name,
                param_note,
                param_status,
                param_author,
                param_licence,
                param_openSource == null ? null : Boolean.valueOf(param_openSource.equals("1")),
                param_userInterface,
                param_programmingLanguage,
                param_binaries == null ? false : param_binaries.equals("1"),
                param_lastUpdate == null || param_lastUpdate.isEmpty() ? null : new LocalDate(param_lastUpdate),
                param_lastVersion);

        int numberOfNewVariant = variantRepo.create(newVariant);

        newVariant.setNumber(numberOfNewVariant);

    %>


    <p style="margin-left:20px;font-size:130%;">Created new variant with number <%=newVariant.getNumber()%>:<br><br>
        <a href="read_variant.jsp?number=<%=newVariant.getNumber()%>"><%=newVariant.getName()%></a>

    </p>






    <% }%>

    <div id="footer">Content available under a <a href="http://creativecommons.org/licenses/by-sa/4.0/" target="_blank" title="Content available under a Creative Commons Attribution-ShareAlike 4.0 International License.">Creative Commons Attribution-ShareAlike 4.0 International License</a> <a href="http://creativecommons.org/licenses/by-sa/4.0/" target="_blank" title="Content available under a Creative Commons Attribution-ShareAlike 4.0 International License."><img alt="Content available under a Creative Commons Attribution-ShareAlike 4.0 International License." style="border-width:0" src="images/creative_commons_attribution_share_alike_4.0_international_licence_88x31.png" /></a></div>
    
</body>
</html>
