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
        <title>Nanotask - Add websites</title>
        <link rel="stylesheet" type="text/css" href="styles/nanotask.css">
        <link rel="icon" type="image/x-icon" href="favicon.ico" sizes="32x32">
    </head>

    <body>

        <a href="index.jsp" id="main_title">Nanotask</a></span>

    <span class="nav"><a href="index.jsp">Home</a>
        >> <a href="websites.jsp">Websites</a>
        >> <a href="create_website.jsp">Add Website</a>
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
        java.util.List<Website> freefreeWebsites = websiteRepo.list(
                1,
                100,
                null,
                null,
                null,
                null,
                "freefree",
                null
        );
    %>


    <%
        String param_urls = request.getParameter("urls");
        
        boolean formToBeProcessed = param_urls != null && !param_urls.isEmpty();
    %>

    <% if (!formToBeProcessed) { %>
    <form action="create_websites.jsp" method="post">
        <label for="urls">Urls <b style="color:red;font-size:130%;">*</b>: </label><br>

        <textarea id="urls" name="urls" rows="20" cols="100" placeholder="Insert here list of URLS - each URL on one row.">



























</textarea><br>
       
            <a href="websites.jsp" style="font-size:130%;background:#dddddd;border:2px solid #bbbbbb;padding:2px;text-decoration:none;margin-right:80px;">Cancel</a>
            <input type="submit" value="Add urls">
            </tr>
        </table>
        <b style="color:red;font-size:200%;margin-left:20px;">*</b> ...mandatory


    </form>

    <% } else { %>
    <table><tr><th>#</th><th>Result</th><th>Url</th></tr>
    <%
        Long timeAsLong = org.nanoboot.powerframework.time.moment.UniversalDateTime.now().toLong();
      java.util.List<String> lines = param_urls.lines().filter(url->!url.isBlank()).toList();
      int failedCount = 0;
      int successCount = 0;
for(String url:lines) {
      
if(url.endsWith("/")) url = url.substring(0, url.length() -1);

boolean failedBecauseOfSlash = url.endsWith("/");
boolean failedBecauseAlreadyExists = websiteRepo.hasSuchUrl(url);
        boolean failed = failedBecauseOfSlash || failedBecauseAlreadyExists;
        if(failed) {++failedCount;} else {++successCount;}
                      Website newWebsite = null;
        
        if(!failed) {
        if(!freefreeWebsites.isEmpty()) {
        Website freefreeWebsite = freefreeWebsites.get(0);
        freefreeWebsites.remove(0);
        newWebsite = new Website(
                freefreeWebsite.getNumber(),
                url,
                null,
                null,
                null,
                false,
                false,
                0,
        "bulk added - " + timeAsLong, null, null);
        websiteRepo.update(newWebsite);
        
        } else {
         newWebsite = new Website(
                0,
                url,
                null,
                null,
                null,
                false,
                false,
                null,
        "bulk added - " + timeAsLong, null, null);

        int numberOfNewWebsite = websiteRepo.create(newWebsite);

        newWebsite.setNumber(numberOfNewWebsite);
        }
      } %>


        <tr>
            <td><% if(!failed){%><a href="read_website.jsp?number=<%=newWebsite.getNumber()%>"><%=newWebsite.getNumber()%></a><%}%></td>
            <td>
                <%=failed?
                        ("<span style=\"color:red;font-weight:bold;\">FAILED</span>" + (failedBecauseOfSlash?" (/)":"") + (failedBecauseAlreadyExists?" (already exists)":""))
                        :
        "<span style=\"color:green;font-weight:bold;\">SUCCESS</span>"%>
            </td>
            <td><a href="<%=url%>"><%=(url.length()>40 ? url.substring(0, 40) + "..." : url)%></a></td>
        </tr>

      
      <% }; %>
      </table>

      <br>
      Success count:<%=successCount%><br>
      Failed count:<%=failedCount%><br>


    <% }%>

    <div id="footer">Content available under a <a href="http://creativecommons.org/licenses/by-sa/4.0/" target="_blank" title="Content available under a Creative Commons Attribution-ShareAlike 4.0 International License.">Creative Commons Attribution-ShareAlike 4.0 International License</a> <a href="http://creativecommons.org/licenses/by-sa/4.0/" target="_blank" title="Content available under a Creative Commons Attribution-ShareAlike 4.0 International License."><img alt="Content available under a Creative Commons Attribution-ShareAlike 4.0 International License." style="border-width:0" src="images/creative_commons_attribution_share_alike_4.0_international_licence_88x31.png" /></a></div>
    
</body>
</html>
