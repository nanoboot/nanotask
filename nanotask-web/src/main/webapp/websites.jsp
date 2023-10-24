<%@page import="java.util.List"%>
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
        <title>List websites - Nanotask</title>
        <link rel="stylesheet" type="text/css" href="styles/nanotask.css">
        <link rel="icon" type="image/x-icon" href="favicon.ico" sizes="32x32">
    </head>

    <body>

        <a href="index.jsp" id="main_title">Nanotask</a></span>

    <span class="nav"><a href="index.jsp">Home</a>
        >> <a href="websites.jsp" class="nav_a_current">Websites</a>
        
                
            <% boolean canUpdate = org.nanoboot.octagon.jakarta.utils.OctagonJakartaUtils.canUpdate(request); %>
<% if(canUpdate) { %>
>> <a href="create_website.jsp">Add Website</a>
     <a href="create_websites.jsp">Add Websites</a>
<% } %>


        
    </span>

    <%
        ApplicationContext context = WebApplicationContextUtils.getWebApplicationContext(getServletContext());
        WebsiteRepo websiteRepo = context.getBean("websiteRepoImplSqlite", WebsiteRepo.class);
    %>


    <style>
        input[type="submit"] {
            padding-top: 15px !important;
            padding-left:10px;
            padding-right:10px;
            border:2px solid #888 !important;
            font-weight:bold;
        }
        input[type="checkbox"] {
            margin-right:20px;
        }
    </style>
    <%
        final String EMPTY = "[empty]";
        String number = request.getParameter("number");
        String url = request.getParameter("url");
        String variantNumber = request.getParameter("variantNumber");
//        String archiveUrl = request.getParameter("archiveUrl");
        
        String contentVerified = request.getParameter("contentVerified");
        String archiveVerified = request.getParameter("archiveVerified");
        String recording = request.getParameter("recording");
        String pageNumber = request.getParameter("pageNumber");
        String pageSize = request.getParameter("pageSize");
        String previousNextPage = request.getParameter("PreviousNextPage");
        if (previousNextPage != null && !previousNextPage.isEmpty()) {
            if (previousNextPage.equals("Previous page")) {
                pageNumber = String.valueOf(Integer.valueOf(pageNumber) - 1);
            }
            if (previousNextPage.equals("Next page")) {
                pageNumber = String.valueOf(Integer.valueOf(pageNumber) + 1);
            }
        }
        int pageNumberInt = pageNumber == null || pageNumber.isEmpty() ? 1 : Integer.valueOf(pageNumber);

    %>


    <form action="websites.jsp" method="get">

        <label for="pageNumber">Page </label><input type="text" name="pageNumber" value="<%=pageNumberInt%>" size="4" style="margin-right:10px;">
        <label for="number">Number </label><input type="text" name="number" value="<%=number != null ? number : ""%>" size="5" style="margin-right:10px;">
        <label for="url">Url </label><input type="text" name="url" value="<%=url != null ? url : ""%>" style="margin-right:10px;">
        <label for="variantNumber">Variant number </label><input type="text" name="variantNumber" value="<%=variantNumber != null ? variantNumber : ""%>" size="5" style="margin-right:10px;">
        <label for="contentVerified">Content verified</label><input type="checkbox" name="contentVerified"  <%=contentVerified != null && contentVerified.equals("1") ? "checked " : ""%>value="1">
        
        <label for="archiveVerified">Archive verified</label>
        <select id="archiveVerified" name="archiveVerified">
            <option value="all">All</option>
            <option value="yes">Yes</option>
            <option value="no">No</option>
        </select>
        
        <label for="recording">Recording</label>
        <select id="recording" name="recording">
            <option value="all">All</option>
            <option value="yes">Yes</option>
            <option value="no">No</option>
        </select>

        <input type="submit" value="Filter" style="margin-left:20px;height:40px;">
        <br>
        <br>

        <input type="submit" name="PreviousNextPage" value="Previous page" style="margin-left:20px;height:40px;">
        <input type="submit" name="PreviousNextPage" value="Next page" style="margin-left:20px;height:40px;">
    </form>

    <%
        List<Website> websites = websiteRepo.list(
                pageNumberInt,
                ((pageSize == null || pageSize.isEmpty()) ? 10 : Integer.valueOf(pageSize)),
                contentVerified == null ? null : Boolean.valueOf(contentVerified.equals("1")),
                archiveVerified,
                recording,
                number == null || number.isEmpty() ? null : Integer.valueOf(number),
                url == null || url.isEmpty() ? null : url,
                variantNumber == null || variantNumber.isEmpty() ? null : Integer.valueOf(variantNumber)
        );

        if (websites.isEmpty()) {

    %><span style="font-weight:bold;color:orange;" class="margin_left_and_big_font">Warning: Nothing found.</span>

    <%            throw new jakarta.servlet.jsp.SkipPageException();
        }
    %>


    <table>
        <thead>
            <tr>
                <th title="Number">#</th>
                <th style="width:100px;"></th>
                <th>Url</th>
                <th>Archive url</th>
                <th>Language</th>
                <th>Variant</th>
                <th>Flags</th>
                <th>Comment</th>
            </tr>
        </thead>

        <tbody>

        <style>

            tr td a img {
                border:2px solid grey;
                background:#dddddd;
                padding:4px;
                width:30%;
                height:30%;
            }
            tr td a img:hover {
                border:3px solid #888888;
                padding:3px;
            }
            tr td {
                padding-right:0;
            }
        </style>


        <%
            for (Website w : websites) {
        %>
        <tr>
            <td><%=w.getNumber()%></td>
            <td>
                <a href="read_website.jsp?number=<%=w.getNumber()%>"><img src="images/read.png" title="View" /></a>
                <% if(canUpdate) { %><a href="update_website.jsp?number=<%=w.getNumber()%>"><img src="images/update.png" title="Update" /></a><%}%>
            </td>
            <%
                String finalUrl = w.getUrl();
                if (w.getDeadUrl().booleanValue()) {
                    finalUrl = "https://web.archive.org/web/" + w.getWebArchiveSnapshot() + "/" + w.getUrl();
                }
                //example:
                //https://web.archive.org/web/20080521061635if_/http://linez.varten.net:80
                String urlToBeShown = w.getUrl();
                if (urlToBeShown.length() > 60) {
                    urlToBeShown = urlToBeShown.substring(0, 60) + "...";
                }
                
                String archiveUrl = w.getArchiveUrl();
                if(archiveUrl == null) {
                archiveUrl="";
                }
            %>


            <td><a href="<%=finalUrl%>" target="_blank"><%=urlToBeShown%></a></td>
            <td><a href="<%=archiveUrl%>" target="_blank"><%=archiveUrl.isEmpty()?"":"Link"%></a></td>
            <td><%=w.getLanguage() == null ? EMPTY : w.getLanguage()%></td>
            <td><%=w.getVariantNumber() == null ? EMPTY : w.getVariantNumber()%></td>
            <td>
                <%=w.getDeadUrl().booleanValue() ? "<span class=\"grey_flag\" title=\"Dead url\">†</span>" : ""%>
                <%=w.getContentVerified().booleanValue() ? "<span class=\"orange_flag\" title=\"Content verified\">C</span>" : ""%>
                <%=w.getArchiveVerified().booleanValue() ? "<span class=\"green_flag\" title=\"Archive verified\">A</span>" : ""%>
                <%=(w.getRecordingId() != null && !w.getRecordingId().isEmpty()) ? "<span class=\"red_flag\" title=\"Recording in progress\">R</span>" : ""%>
            </td>
            <td><%=w.getComment() == null ? EMPTY : (w.getComment().length() > 16 ? w.getComment().substring(0,16) + "..." : w.getComment())%></td>

        </tr>
        <%
            }
        %>
    </tbody>
</table>
    
    <div id="footer">Content available under a <a href="http://creativecommons.org/licenses/by-sa/4.0/" target="_blank" title="Content available under a Creative Commons Attribution-ShareAlike 4.0 International License.">Creative Commons Attribution-ShareAlike 4.0 International License</a> <a href="http://creativecommons.org/licenses/by-sa/4.0/" target="_blank" title="Content available under a Creative Commons Attribution-ShareAlike 4.0 International License."><img alt="Content available under a Creative Commons Attribution-ShareAlike 4.0 International License." style="border-width:0" src="images/creative_commons_attribution_share_alike_4.0_international_licence_88x31.png" /></a></div>
    
</body>
</html>
