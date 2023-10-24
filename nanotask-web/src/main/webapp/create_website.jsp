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

<%@page import="org.nanoboot.nanotask.persistence.api.WebsiteRepo"%>
<%@page import="org.nanoboot.nanotask.entity.Website"%>
<%@page import="org.springframework.web.context.support.WebApplicationContextUtils"%>
<%@page import="org.springframework.context.ApplicationContext"%>
<!DOCTYPE>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
    <head>
        <title>Nanotask - Add website</title>
        <link rel="stylesheet" type="text/css" href="styles/nanotask.css">
        <link rel="icon" type="image/x-icon" href="favicon.ico" sizes="32x32">
    </head>

    <body>

        <a href="index.jsp" id="main_title">Nanotask</a></span>

    <span class="nav"><a href="index.jsp">Home</a>
        >> <a href="websites.jsp">Websites</a>
        >> <a href="create_website.jsp" class="nav_a_current">Add Website</a>
     <a href="create_websites.jsp">Add Websites</a>
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
    %>


    <%
        String param_url = request.getParameter("url");
        
        boolean formToBeProcessed = param_url != null && !param_url.isEmpty();
    %>

    <% if (!formToBeProcessed) { %>
    <form action="create_website.jsp" method="post">
        <table>
            <!--            <tr>
                            <td><label for="number">Number <b style="color:red;font-size:130%;">*</b>:</label></td>
                            <td><input type="text" name="number" value=""></td>
                        </tr>-->
            <tr>
                <td><label for="url">Url <b style="color:red;font-size:130%;">*</b>:</label></td>
                <td><input type="text" name="url" value=""></td>
            </tr>
            <tr>
                <td><label for="webArchiveSnapshot">Web archive snapshot:</label></td>
                <td><input type="text" name="webArchiveSnapshot" value=""></td>
            </tr>
            <tr>
                <td><label for="language">Language:</label></td>
                <td style="text-align:left;"><input type="text" name="language" value="" size="4" ></td>
            </tr>
            <tr>
                <td><label for="contentVerified">Content verified:</label></td>
                <td style="text-align:left;">
                    <input type="checkbox" name="contentVerified" value="1" >
                </td>
            </tr>
            <tr>
                <td><label for="archiveVerified">Archive verified:</label></td>
                <td style="text-align:left;">
                    <input type="checkbox" name="archiveVerified" value="1" >
                </td>
            </tr>
            <tr>
                <td><label for="variantNumber">Variant:</label></td>
                <td style="text-align:left;"><input type="text" name="variantNumber" value="" size="5" ></td>
            </tr>

            <tr>
                <td><a href="websites.jsp" style="font-size:130%;background:#dddddd;border:2px solid #bbbbbb;padding:2px;text-decoration:none;">Cancel</a></td>
                <td style="text-align:right;"><input type="submit" value="Add"></td>
            </tr>
        </table>
        <b style="color:red;font-size:200%;margin-left:20px;">*</b> ...mandatory


    </form>


    <% } else { %>

    <%
        String param_webArchiveSnapshot = request.getParameter("webArchiveSnapshot");

        String param_language = request.getParameter("language");

        String param_contentVerified = request.getParameter("contentVerified");
        String param_archiveVerified = request.getParameter("archiveVerified");
        String param_variantNumber = request.getParameter("variantNumber");
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
        //
        if(param_url.endsWith("/")) {
        org.nanoboot.octagon.jakarta.utils.OctagonJakartaUtils.throwErrorInJsp("Adding failed, because URL ends with /", out);
        }
        if(websiteRepo.hasSuchUrl(param_url)) {
        org.nanoboot.octagon.jakarta.utils.OctagonJakartaUtils.throwErrorInJsp("Adding failed, because this URL already exists", out);
        }
        Website newWebsite = new Website(
                0,
                param_url,
                null, 
                param_webArchiveSnapshot,
                param_language,
                param_contentVerified == null ? false : param_contentVerified.equals("1"),
                param_archiveVerified == null ? false : param_archiveVerified.equals("1"),
                (param_variantNumber == null || param_variantNumber.isEmpty()) ? null : Integer.valueOf(param_variantNumber),
        "", null, null);

        int numberOfNewWebsite = websiteRepo.create(newWebsite);

        newWebsite.setNumber(numberOfNewWebsite);
    %>


    <p style="margin-left:20px;font-size:130%;">Created new website with number <%=newWebsite.getNumber()%>:<br><br>
        <a href="read_website.jsp?number=<%=newWebsite.getNumber()%>"><%=newWebsite.getUrl()%></a>

    </p>
    number = <%=newWebsite.getNumber()%><br>
    url = <%=param_url%><br>
    webArchiveSnapshot = <%=param_webArchiveSnapshot%><br>
    language = <%=param_language%><br>
    content verified = <%=param_contentVerified%><br>
    archive verified = <%=param_archiveVerified%><br>
    variantNumber = <%=param_variantNumber%><br>



    <% }%>

    <div id="footer">Content available under a <a href="http://creativecommons.org/licenses/by-sa/4.0/" target="_blank" title="Content available under a Creative Commons Attribution-ShareAlike 4.0 International License.">Creative Commons Attribution-ShareAlike 4.0 International License</a> <a href="http://creativecommons.org/licenses/by-sa/4.0/" target="_blank" title="Content available under a Creative Commons Attribution-ShareAlike 4.0 International License."><img alt="Content available under a Creative Commons Attribution-ShareAlike 4.0 International License." style="border-width:0" src="images/creative_commons_attribution_share_alike_4.0_international_licence_88x31.png" /></a></div>
    
</body>
</html>
