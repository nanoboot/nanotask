<%@page import="org.nanoboot.octagon.jakarta.utils.OctagonJakartaUtils"%>
<%@page import="org.nanoboot.nanotask.persistence.api.WebsiteRepo"%>
<%@page import="org.nanoboot.nanotask.entity.Website"%>
<%@page import="org.springframework.web.context.support.WebApplicationContextUtils"%>
<%@page import="org.springframework.context.ApplicationContext"%>
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
        <title>Update website - Nanotask</title>
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
        >> <a href="websites.jsp">Websites</a>
        >>         <a href="read_website.jsp?number=<%=number%>">Read</a>
        
        <a href="update_website.jsp?number=<%=number%>" class="nav_a_current">Update</a>
        
        
        <a href="show_content.jsp?number=<%=number%>">Show</a>
        <a href="edit_content.jsp?number=<%=number%>">Edit</a>
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
        ApplicationContext context = WebApplicationContextUtils.getWebApplicationContext(getServletContext());
        WebsiteRepo websiteRepo = context.getBean("websiteRepoImplSqlite", WebsiteRepo.class);
        Website website = websiteRepo.read(Integer.valueOf(number));

        if (website == null) {
    %><span style="font-weight:bold;color:red;" class="margin_left_and_big_font">Error: Website with number <%=number%> was not found.</span>

    <%
            throw new jakarta.servlet.jsp.SkipPageException();
        }
        String param_url = request.getParameter("url");
        boolean formToBeProcessed = param_url != null && !param_url.isEmpty();
    %>

    <% if (!formToBeProcessed) {%>
    <form action="update_website.jsp" method="post">
        
        <table>
            <tr>
                <td><label for="number">Number <b style="color:red;font-size:130%;">*</b>:</label></td>
                <td><input type="text" name="number" value="<%=number%>" readonly style="background:#dddddd;"></td>
            </tr>
            <tr>
                <td><label for="url">Url <b style="color:red;font-size:130%;">*</b>:</label></td>
                <td><input type="text" name="url" value="<%=website.getUrl()%>"></td>
            </tr>
                        <tr>
                <td><label for="archives">Archives <b style="color:red;font-size:130%;"></b>:</label></td>
                <td><input type="text" name="archives" value="<%=OctagonJakartaUtils.formatToHtmlWithoutEmptyWord(website.getArchives())%>"></td>
            </tr>
            
            
            <tr>
                <td><label for="webArchiveSnapshot">Web archive snapshot:</label></td>
                <td><input type="text" name="webArchiveSnapshot" value="<%=(website.getWebArchiveSnapshot() == null ? "" : website.getWebArchiveSnapshot())%>"></td>
            </tr>
            <tr>
                <td><label for="language">Language:</label></td>
                <td style="text-align:left;"><input type="text" name="language" value="<%=OctagonJakartaUtils.formatToHtmlWithoutEmptyWord(website.getLanguage())%>" size="4" ></td>
            </tr>
            <tr>
                <td><label for="verified">Content verified:</label></td>
                <td style="text-align:left;">
                    <input type="checkbox" name="contentVerified" value="1"<%=website.getContentVerified().booleanValue() ? "checked" : ""%> >
                </td>
            </tr>
            <tr>
                <td><label for="verified">Archive verified:</label></td>
                <td style="text-align:left;">
                    <input type="checkbox" name="archiveVerified" value="1"<%=website.getArchiveVerified().booleanValue() ? "checked" : ""%> >
                </td>
            </tr>
            <tr>
                <td><label for="variantNumber">Variant:</label></td>
                <td style="text-align:left;"><input type="text" name="variantNumber" value="<%=website.getVariantNumber() == null ? "" : website.getVariantNumber()%>" size="5" ></td>
            </tr>
            <tr>
                <td><label for="comment">Comment</label></td>
                <td style="text-align:left;"><input type="text" name="comment" value="<%=website.getComment() == null ? "" : website.getComment()%>" size="50" ></td>
            </tr>

            <tr>
                <td><label for="comment">Recording comment</label></td>
                <td style="text-align:left;">
                    <input type="text" name="recordingComment" value="<%=website.getRecordingComment() == null ? "" : website.getRecordingComment()%>" size="50" >
                    <input type="hidden" name="recordingId" value="<%=website.getRecordingId() == null ? "" : website.getRecordingId()%>" size="36" >
                </td>
            </tr>

            <tr>
                <td><a href="websites.jsp" style="font-size:130%;background:#dddddd;border:2px solid #bbbbbb;padding:2px;text-decoration:none;">Cancel</a></td>
                <td style="text-align:right;">
                
                <input type="submit" value="Update">
                </td>
            </tr>
            <tr style="height:100px;"></tr>
            <tr>
                <td><label for"confirmClear">Confirm clear:</label><input type="checkbox" name="confirmClear" value="1"></td>
                <td style="text-align:right;"><input type="submit" name="clearSubmit" value="Clear (!will delete this website!)"></td>
            </tr>
        </table>
        <b style="color:red;font-size:200%;margin-left:20px;">*</b> ...mandatory


    </form>

    <% } else { %>

    <%
        String param_archives = request.getParameter("archives");
        if(param_archives != null &&  param_archives.isEmpty()) {
        param_archives = null;
        }
        String param_webArchiveSnapshot = request.getParameter("webArchiveSnapshot");

        String param_language = request.getParameter("language");

        
        String param_contentVerified = request.getParameter("contentVerified");
        String param_archiveVerified = request.getParameter("archiveVerified");
        String param_variantNumber = request.getParameter("variantNumber");
        String param_comment = request.getParameter("comment");
        String param_recordingId = request.getParameter("recordingId");
        String param_recordingComment = request.getParameter("recordingComment");
        
        //
        if (param_webArchiveSnapshot != null && param_webArchiveSnapshot.isEmpty()) {
            param_webArchiveSnapshot = null;
        }
        if (param_language != null && param_language.isEmpty()) {
            param_language = null;
        }

        if (param_language != null && param_language.isEmpty()) {
            param_language = null;
        }
        if (param_comment == null) {
            param_comment = "";
        }
        //
        Website updatedWebsite = new Website(
                Integer.valueOf(number),
                param_url,
                param_archives,
                param_webArchiveSnapshot,
                param_language,
                param_contentVerified == null ? false : param_contentVerified.equals("1"),
                param_archiveVerified == null ? false : param_archiveVerified.equals("1"),
                (param_variantNumber == null || param_variantNumber.isEmpty()) ? null : Integer.valueOf(param_variantNumber),
                param_comment,
                param_recordingId,
                param_recordingComment);
        if(param_archives == null && request.getParameter("confirmClear") != null && request.getParameter("confirmClear").equals("1") && request.getParameter("clearSubmit") != null && request.getParameter("clearSubmit").equals("Clear (!will delete this website!)")) {
           updatedWebsite = new Website(
                Integer.valueOf(number),
                "freefree" + ((int)(Math.random() * 1000000)) + ((int)(Math.random() * 1000000)),
                null,
                null,
                null,
                false,
                false,
                0,
                null,
                null,
                null);
        }
          

        websiteRepo.update(updatedWebsite);
    %>

    <script>
        function redirectToRead() {  
window.location.href = 'read_website.jsp?number=<%=number%>'
}  
redirectToRead();
</script>
<!--
    <p style="margin-left:20px;font-size:130%;">Updated website with number <%=updatedWebsite.getNumber()%>:<br><br>
        <a href="read_website.jsp?number=<%=updatedWebsite.getNumber()%>"><%=updatedWebsite.getUrl()%></a>

    </p>
-->


    <% }%>

    <div id="footer">Content available under a <a href="http://creativecommons.org/licenses/by-sa/4.0/" target="_blank" title="Content available under a Creative Commons Attribution-ShareAlike 4.0 International License.">Creative Commons Attribution-ShareAlike 4.0 International License</a> <a href="http://creativecommons.org/licenses/by-sa/4.0/" target="_blank" title="Content available under a Creative Commons Attribution-ShareAlike 4.0 International License."><img alt="Content available under a Creative Commons Attribution-ShareAlike 4.0 International License." style="border-width:0" src="images/creative_commons_attribution_share_alike_4.0_international_licence_88x31.png" /></a></div>
</body>
</html>
