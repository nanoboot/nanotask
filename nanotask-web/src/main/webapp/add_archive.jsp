<%@page import="java.io.FileWriter"%>
<%@page import="java.io.FileWriter"%>
<%@page import="java.io.BufferedWriter"%>
<%@page import="java.security.MessageDigest"%>
<%@page import="java.nio.file.Paths"%>
<%@page import="java.nio.file.Files"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.List"%>
<%@page import="java.io.File"%>
<%@page import="org.nanoboot.powerframework.time.moment.LocalDate"%>
<%@page import="org.nanoboot.octagon.jakarta.utils.OctagonJakartaUtils"%>
<%@page import="org.nanoboot.nanotask.entity.Variant"%>
<%@page import="org.springframework.web.context.support.WebApplicationContextUtils"%>
<%@page import="org.springframework.context.ApplicationContext"%>

<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="org.apache.commons.fileupload.FileUploadException"%>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@page import="org.apache.commons.io.output.*"%>
<%@page import="org.nanoboot.nanotask.persistence.api.WebsiteRepo"%>
<%@page import="org.nanoboot.nanotask.entity.Website"%>


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
        <title>Add Archive - Nanotask</title>
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

    <% if (number != null) {%>
    <span class="nav"><a href="index.jsp">Home</a>
        >> <a href="websites.jsp">Websites</a>
        >>         <a href="read_website.jsp?number=<%=number%>">Read</a>

        <a href="update_website.jsp?number=<%=number%>">Update</a>


        <a href="show_content.jsp?number=<%=number%>">Show</a>
        <a href="edit_content.jsp?number=<%=number%>">Edit</a>
        <a href="list_files.jsp?number=<%=number%>">List</a>
        <a href="upload_file.jsp?number=<%=number%>">Upload</a>
        <a href="add_archive.jsp?number=<%=number%>" class="nav_a_current">Add Archive</a>

    </span>

    <%
        if (org.nanoboot.octagon.jakarta.utils.OctagonJakartaUtils.cannotUpdate(request)) {
            out.println("&nbsp;&nbsp;&nbsp;&nbsp;Access forbidden. <br><br> &nbsp;&nbsp;&nbsp;&nbsp;<a href=\"login.html\" target=\"_blank\">Log in</a>");
            throw new jakarta.servlet.jsp.SkipPageException();
        }
    %>

    <% } %>

    <%
        String param_file = request.getParameter("file");

        //param_variant_screenshot != null && !param_variant_screenshot.isEmpty();
    %>

    <% if (!formToBeProcessed) {%>
    <form action="add_archive.jsp"  method = "post" enctype = "multipart/form-data">
        Select an archive to upload: <br />

        <input type = "file" name = "file" size = "50" />
        <br /><br />
        <input type = "submit" value = "Upload archive" />
        <input type="hidden" name="number" value="<%=number%>" />
    </form>

    <% } else { %>

    <%
boolean success = false;
        File file;
        int maxFileSize = 100 * 1024 * 1024;
        int maxRequestSize = 100 * 1024 * 1024;
        int maxMemSize = 5000 * 1024;
        ServletContext context = pageContext.getServletContext();
        String filePath = System.getProperty("nanotask.archiveDir") + "/";
        if(filePath == null || filePath.isEmpty()) {
        
        
        throw new jakarta.servlet.jsp.SkipPageException("Cannot upload archive. Reason: This property is not defined: nanotask.archiveDir");
        }

        // Verify the content type
        String contentType = request.getContentType();

        if ((contentType.indexOf("multipart/form-data") >= 0)) {
            DiskFileItemFactory factory = new DiskFileItemFactory();
            // maximum size that will be stored in memory
            factory.setSizeThreshold(maxMemSize);

            factory.setRepository(new File("csa-tmp"));
            
            ServletFileUpload upload = new ServletFileUpload(factory);
            upload.setSizeMax(maxRequestSize);
            upload.setFileSizeMax(maxRequestSize);
            

            try {
                // Parse the request to get file items.
                List<FileItem> fileItems = upload.parseRequest(request);

                // Process the uploaded file items
                Iterator i = fileItems.iterator();

                String tmpFileName = filePath + "tmp_file_" + String.valueOf(((int) (Math.random() * 1000000))) + String.valueOf(((int) (Math.random() * 1000000)));

                String origFileName = null;
                while (i.hasNext()) {
                    FileItem fi = (FileItem) i.next();
                    if (!fi.isFormField()) {
                        // Get the uploaded file parameters
                        String fieldName = fi.getFieldName();
                        String fileName = fi.getName();
                        if(!fileName.endsWith(".warc") && !fileName.endsWith(".warc.gz")) {
                        String msg = "File name does not end with warc or warc.gz. Uploading failed.";
                        out.println(msg);
                        throw new RuntimeException(msg);
        }

                        boolean isInMemory = fi.isInMemory();
                        long sizeInBytes = fi.getSize();
                        origFileName = fileName;
                        fileName = tmpFileName;
                        // Write the file
                        if (fileName.lastIndexOf("\\") >= 0) {
                            file = new File(fileName.substring(fileName.lastIndexOf("\\")));
                        } else {
                            file = new File(fileName.substring(fileName.lastIndexOf("\\") + 1));
                        }
                        fi.write(file);
                        
                    }
                    if (fi.isFormField()) {
                        if (fi.getFieldName().equals("number")) {

                            number = fi.getString();
                            if(!origFileName.startsWith(number + ".")) {
                            origFileName = number + "." + origFileName;
                            
                            //String msg = "File name must start with website number, which is here: \"" + number  + ".\". Uploading failed.";
                            //out.println(msg);
                            //out.println("<span class=\"margin_left_and_big_font\">Uploaded failed.</span><br>");
                            //new File(tmpFileName).delete();
                            //throw new SkipPageException(msg);
        }
                            if (origFileName == null) {
                                System.err.println("Uploading file failed.");
                            } else {
                            
                                File newFile = new File(filePath + "/" + origFileName);
                                if(newFile.exists()) {
                                String msg = "File already exists. Uploading failed.";
                                new File(tmpFileName).delete();
                                out.println(msg);
                                throw new RuntimeException(msg);
        }
                                File parentDir = new File(filePath);
                                if(!parentDir.exists()) {
                                    parentDir.mkdirs();
                                }
                                
                                boolean renameResult = new File(tmpFileName).renameTo(newFile);
                                
                                ////
                                byte[] sha512sumByteArray = MessageDigest.getInstance("SHA-512").digest(Files.readAllBytes(Paths.get(newFile.getAbsolutePath())));
                                StringBuilder sb = new StringBuilder(sha512sumByteArray.length * 2);
                                for (byte b : sha512sumByteArray) {
                                    sb.append(String.format("%02x", b));
                                }
                                String hexString = sb.toString();
                                File archiveCheckSums = new File(newFile.getParentFile().getParentFile().getAbsolutePath() + "/" + "archiveCheckSums");
                                System.err.println("archiveCheckSums=" + archiveCheckSums.getAbsolutePath());
                                if(!archiveCheckSums.exists()) {
                                archiveCheckSums.mkdir();
        }
                                File hexFile = new File(archiveCheckSums, newFile.getName() + ".sha512");

                                
                                BufferedWriter writer = new BufferedWriter(new FileWriter(hexFile));
                                writer.write(hexString);

                                writer.close();
                                ApplicationContext ct = WebApplicationContextUtils.getWebApplicationContext(getServletContext());
                                WebsiteRepo websiteRepo = ct.getBean("websiteRepoImplSqlite", WebsiteRepo.class);
                                Website website = websiteRepo.read(Integer.valueOf(number));
                                String currentArchives = website.getArchives();
                                if(currentArchives == null) {
                                currentArchives = "";
        }
        website.setArchives(currentArchives + "::::" + origFileName + "####" + hexString);
                                websiteRepo.update(website);
        
                                out.println("Upload was successful.");
                                success = true;
                                %><script>window.location.href = 'read_website.jsp?number=<%=number%>'</script><%
                                ////
                            }

                        }
                    }
                }

            } catch (Exception ex) {
                System.out.println(ex);
            }
        } else {
            out.println("<p>No archive uploaded</p>");
        }
    %>



<% if(success) { %>
    <script>
        function redirectToRead() {  
window.location.href = 'list_files.jsp?number=<%=number%>'
}  
redirectToRead2();
</script>
<% } %>


<a href="read_website.jsp?number=<%=number%>">Back to website</a>

    <% } %>
   
        
        



</body>
</html>
