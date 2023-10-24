<%@page import="org.nanoboot.powerframework.time.moment.LocalDate"%>
<%@page import="org.nanoboot.octagon.jakarta.utils.OctagonJakartaUtils"%>
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

<%@ page session="false" %>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
    <head>
        <title>Update variant - Nanotask</title>
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
    %>

    <span class="nav"><a href="index.jsp">Home</a>
        >> <a href="variants.jsp">Variants</a>
        >> <a href="read_variant.jsp?number=<%=number%>">Read</a>
        <a href="update_variant.jsp?number=<%=number%>" class="nav_a_current">Update</a>
        <a href="upload_variant_screenshot.jsp?number=<%=number%>">Upload screenshot</a>
    </span>

    <%
        if (org.nanoboot.octagon.jakarta.utils.OctagonJakartaUtils.cannotUpdate(request)) {
            out.println("&nbsp;&nbsp;&nbsp;&nbsp;Access forbidden. <br><br> &nbsp;&nbsp;&nbsp;&nbsp;<a href=\"login.html\" target=\"_blank\">Log in</a>");
            throw new jakarta.servlet.jsp.SkipPageException();
        }
    %>
    <%
        ApplicationContext context = WebApplicationContextUtils.getWebApplicationContext(getServletContext());
        VariantRepo variantRepo = context.getBean("variantRepoImplSqlite", VariantRepo.class);
        Variant variant = variantRepo.read(Integer.valueOf(number));

        if (variant == null) {
    %><span style="font-weight:bold;color:red;" class="margin_left_and_big_font">Error: Variant with number <%=number%> was not found.</span>

    <%
            throw new jakarta.servlet.jsp.SkipPageException();
        }
        String param_name = request.getParameter("name");
        boolean formToBeProcessed = param_name != null && !param_name.isEmpty();
    %>

    <% if (!formToBeProcessed) {%>
    <form action="update_variant.jsp" method="get">
        <table>
            <tr>
                <td><label for="number">Number <b style="color:red;font-size:130%;">*</b>:</label></td>
                <td><input type="text" name="number" value="<%=number%>" readonly style="background:#dddddd;"></td>
            </tr>
            <tr>
                <td><label for="name">Name <b style="color:red;font-size:130%;">*</b>:</label></td>
                <td><input type="text" name="name" value="<%=variant.getName()%>"></td>
            </tr>
            <tr>
                <td><label for="note">Note:</label></td>
                <td><input type="text" name="note" value="<%=variant.getNote() == null ? "" : variant.getNote()%>"></td>
            </tr>
            <tr>
                <td><label for="name">Status:</label></td>
                <td><input type="text" name="status" value="<%=variant.getStatus() == null ? "" : variant.getStatus()%>"></td>
            </tr>
            <tr>
                <td><label for="author">Author</label></td>
                <td><input type="text" name="author" value="<%=variant.getAuthor() == null ? "" : variant.getAuthor()%>"></td>
            </tr>
            <tr>
                <td><label for="licence">Licence</label></td>
                <td><input type="text" name="licence" value="<%=variant.getLicence() == null ? "" : variant.getLicence()%>"></td>
            </tr>

            <tr>
                <td><label for="openSource">Open source</label></td>
                <td style="text-align:left;">
                    <input type="checkbox" name="openSource" value="1" <%=variant.getOpenSource().booleanValue() ? "checked" : ""%> >
                </td>
            </tr>

            <tr>
                <td><label for="userInterface">User interface</label></td>
                <td><input type="text" name="userInterface" value="<%=variant.getUserInterface() == null ? "" : variant.getUserInterface()%>"></td>
            </tr>
            <tr>
                <td><label for="programmingLanguage">Programming language</label></td>
                <td><input type="text" name="programmingLanguage" value="<%=variant.getProgrammingLanguage() == null ? "" : variant.getProgrammingLanguage()%>"></td>
            </tr>

            <tr>
                <td><label for="binariesAvailable">Binaries available</label></td>
                <td style="text-align:left;">
                    <input type="checkbox" name="binariesAvailable" value="1" <%=variant.getBinaries().booleanValue() ? "checked" : ""%> >
                </td>
            </tr>

            <tr>
                <td><label for="lastUpdate">Last update</label></td>
                <td><input type="text" name="lastUpdate" value="<%=variant.getLastUpdate() == null ? "" : variant.getLastUpdate().toString()%>"></td>
            </tr>
            <tr>
                <td><label for="lastVersion">Last version</label></td>
                <td><input type="text" name="lastVersion" value="<%=variant.getLastVersion() == null ? "" : variant.getLastVersion()%>"></td>
            </tr>


            <tr>
                <td><a href="variants.jsp" style="font-size:130%;background:#dddddd;border:2px solid #bbbbbb;padding:2px;text-decoration:none;">Cancel</a></td>
                <td style="text-align:right;"><input type="submit" value="Update"></td>
            </tr>
        </table>
        <b style="color:red;font-size:200%;margin-left:20px;">*</b> ...mandatory


    </form>

    <% } else { %>

    <%
        String param_note = request.getParameter("note");

        String param_status = request.getParameter("status");

        String param_author = request.getParameter("author");
        String param_licence = request.getParameter("licence");
        String param_openSource = request.getParameter("openSource");
        String param_userInterface = request.getParameter("userInterface");
        String param_programmingLanguage = request.getParameter("programmingLanguage");
        String param_binariesAvailable = request.getParameter("binariesAvailable");
        String param_lastUpdate = request.getParameter("lastUpdate");
        String param_lastVersion = request.getParameter("lastVersion");
        //
        if (param_status != null && param_status.isEmpty()) {
            param_status = null;
        }
        if (param_author != null && param_author.isEmpty()) {
            param_author = null;
        }
        if (param_licence != null && param_licence.isEmpty()) {
            param_licence = null;
        }
        if (param_userInterface != null && param_userInterface.isEmpty()) {
            param_userInterface = null;
        }
        if (param_programmingLanguage != null && param_programmingLanguage.isEmpty()) {
            param_programmingLanguage = null;
        }
        if (param_lastUpdate != null && param_lastUpdate.isEmpty()) {
            param_lastUpdate = null;
        }
        if (param_lastVersion != null && param_lastVersion.isEmpty()) {
            param_lastVersion = null;
        }
        //
        //
        Variant updatedVariant = new Variant(
                Integer.valueOf(number),
                param_name,
                param_note,
                param_status,
                param_author,
                param_licence,
                param_openSource == null ? null : Boolean.valueOf(param_openSource.equals("1")),
                param_userInterface,
                param_programmingLanguage,
                param_binariesAvailable == null ? false : param_binariesAvailable.equals("1"),
                param_lastUpdate == null || param_lastUpdate.isEmpty() ? null : new LocalDate(param_lastUpdate),
                param_lastVersion);

        variantRepo.update(updatedVariant);


    %>


    <script>
        function redirectToRead() {
            window.location.href = 'read_variant.jsp?number=<%=number%>'
        }
        redirectToRead();
    </script>
    <!--
        <p style="margin-left:20px;font-size:130%;">Updated variant with number <%=updatedVariant.getNumber()%>:<br><br>
            <a href="read_variant.jsp?number=<%=updatedVariant.getNumber()%>"><%=updatedVariant.getName()%></a>
    
        </p>
    -->




    <% }%>

    <div id="footer">Content available under a <a href="http://creativecommons.org/licenses/by-sa/4.0/" target="_blank" title="Content available under a Creative Commons Attribution-ShareAlike 4.0 International License.">Creative Commons Attribution-ShareAlike 4.0 International License</a> <a href="http://creativecommons.org/licenses/by-sa/4.0/" target="_blank" title="Content available under a Creative Commons Attribution-ShareAlike 4.0 International License."><img alt="Content available under a Creative Commons Attribution-ShareAlike 4.0 International License." style="border-width:0" src="images/creative_commons_attribution_share_alike_4.0_international_licence_88x31.png" /></a></div>
</body>
</html>
