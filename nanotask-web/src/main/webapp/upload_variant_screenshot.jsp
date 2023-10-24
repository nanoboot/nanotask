<%@page import="java.util.Iterator"%>
<%@page import="java.util.List"%>
<%@page import="java.io.File"%>
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
        <title>Upload Variant screenshot - Nanotask</title>
        <link rel="stylesheet" type="text/css" href="styles/nanotask.css">
        <link rel="icon" type="image/x-icon" href="favicon.ico" sizes="32x32">
    </head>

    <body>

        <a href="index.jsp" id="main_title">Nanotask</a></span>

        <%
        String number = request.getParameter("number");
        boolean formToBeProcessed = request.getContentType() != null && request.getContentType().indexOf("multipart/form-data") >= 0;
        if (!formToBeProcessed && (number == null || number.isEmpty())) {
    %><span style="font-weight:bold;color:red;" class="margin_left_and_big_font">Error: Parameter "number" is required</span>

    <%
            throw new jakarta.servlet.jsp.SkipPageException();
        }
%>

<% if(number != null) {%>
    <span class="nav"><a href="index.jsp">Home</a>
        >> <a href="variants.jsp">Variants</a>
        >> 
        <a href="read_variant.jsp?number=<%=number%>">Read</a>
        <a href="update_variant.jsp?number=<%=number%>">Update</a>
        <a href="upload_variant_screenshot.jsp?number=<%=number%>" class="nav_a_current">Upload screenshot</a>
    </span>
<% } %>

    <%
        if (org.nanoboot.octagon.jakarta.utils.OctagonJakartaUtils.cannotUpdate(request)) {
            out.println("&nbsp;&nbsp;&nbsp;&nbsp;Access forbidden. <br><br> &nbsp;&nbsp;&nbsp;&nbsp;<a href=\"login.html\" target=\"_blank\">Log in</a>");
            throw new jakarta.servlet.jsp.SkipPageException();
        }
    %>
    
<%
        String param_variant_screenshot = request.getParameter("variant_screenshot");

//param_variant_screenshot != null && !param_variant_screenshot.isEmpty();
    %>

    <% if (!formToBeProcessed) {%>
    <form action="upload_variant_screenshot.jsp"  method = "post" enctype = "multipart/form-data">
        Select a file to upload: <br />

        <input type = "file" name = "variant_screenshot" size = "50" />
        <br /><br />
        <input type = "submit" value = "Upload screenshot" />
        <input type="hidden" name="number" value="<%=number%>" />
    </form>

    <% } else { %>

    <%

        File file;
        int maxFileSize = 5000 * 1024;
        int maxMemSize = 5000 * 1024;
        ServletContext context = pageContext.getServletContext();
        String filePath = System.getProperty("nanotask.confpath") + "/" + "variantsScreenshots/";

        // Verify the content type
        String contentType = request.getContentType();

        if ((contentType.indexOf("multipart/form-data") >= 0)) {
            DiskFileItemFactory factory = new DiskFileItemFactory();
            // maximum size that will be stored in memory
            factory.setSizeThreshold(maxMemSize);

            // Location to save data that is larger than maxMemSize.
            factory.setRepository(new File("c:\\temp"));

            // Create a new file upload handler
            ServletFileUpload upload = new ServletFileUpload(factory);

            // maximum file size to be uploaded.
            upload.setSizeMax(maxFileSize);

            try {
                // Parse the request to get file items.
                List<FileItem> fileItems = upload.parseRequest(request);

                // Process the uploaded file items
                Iterator i = fileItems.iterator();

                String tmpFileName = "tmp_file_" + String.valueOf(((int)(Math.random() * 1000000))) + String.valueOf(((int)(Math.random() * 1000000))) + ".jpg";
                while (i.hasNext()) {
                    FileItem fi = (FileItem) i.next();
                    if (!fi.isFormField()) {
                        // Get the uploaded file parameters
                        String fieldName = fi.getFieldName();
                        String fileName = fi.getName();
                        if (!fileName.endsWith(".jpg")) {
                            out.println("<span style=\"color:red\">Error: File name must end with \".jpg\".</span>");
                            out.println("<p>No file uploaded</p>");
                            break;
                        }
                        boolean isInMemory = fi.isInMemory();
                        long sizeInBytes = fi.getSize();

                        fileName = tmpFileName;
                        
                        // Write the file
                        if (fileName.lastIndexOf("\\") >= 0) {
                            file = new File(filePath
                                    + fileName.substring(fileName.lastIndexOf("\\")));
                        } else {
                            file = new File(filePath
                                    + fileName.substring(fileName.lastIndexOf("\\") + 1));
                        }
                        fi.write(file);
                        out.println("<span class=\"margin_left_and_big_font\">Uploaded screenshot.</span><br>");
                    }
                    if (fi.isFormField()) {
                        if (fi.getFieldName().equals("number")) {
                            number = fi.getString();
                            new File(filePath, tmpFileName).renameTo(new File(filePath, number + ".jpg"));
                        }
                    }
                }

            } catch (Exception ex) {
                System.out.println(ex);
            }
        } else {
            out.println("<p>No file uploaded</p>");
        }
    %>






    <% }
    
    out.println("<a href=\"read_variant.jsp?number="+ number +"\">Back to variant</a>");
    %>

    <div id="footer">Content available under a <a href="http://creativecommons.org/licenses/by-sa/4.0/" target="_blank" title="Content available under a Creative Commons Attribution-ShareAlike 4.0 International License.">Creative Commons Attribution-ShareAlike 4.0 International License</a> <a href="http://creativecommons.org/licenses/by-sa/4.0/" target="_blank" title="Content available under a Creative Commons Attribution-ShareAlike 4.0 International License."><img alt="Content available under a Creative Commons Attribution-ShareAlike 4.0 International License." style="border-width:0" src="images/creative_commons_attribution_share_alike_4.0_international_licence_88x31.png" /></a></div>
</body>
</html>
