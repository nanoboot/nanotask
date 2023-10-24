<%@page import="java.io.IOException"%>
<%@page import="java.util.Base64"%>
<%@page import="java.nio.file.Files"%>
<%@page import="java.io.File"%>
<%@page import="org.nanoboot.nanotask.entity.Variant"%>
<%@page import="org.nanoboot.nanotask.persistence.api.VariantRepo"%>
<%@page import="org.nanoboot.octagon.jakarta.utils.OctagonJakartaUtils"%>
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
        <title>Read website - Nanotask</title>
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
        >> <a href="read_variant.jsp?number=<%=number%>" class="nav_a_current">Read</a>
        
            <% boolean canUpdate = org.nanoboot.octagon.jakarta.utils.OctagonJakartaUtils.canUpdate(request); %>
<% if(canUpdate) { %>
<a href="update_variant.jsp?number=<%=number%>">Update</a>
        <a href="upload_variant_screenshot.jsp?number=<%=number%>">Upload screenshot</a>
<% } %>

        
    </span>



    <%
        ApplicationContext context = WebApplicationContextUtils.getWebApplicationContext(getServletContext());
        VariantRepo variantRepo = context.getBean("variantRepoImplSqlite", VariantRepo.class);
        Variant variant = variantRepo.read(Integer.valueOf(number));

        if (variant == null) {
    %><span style="font-weight:bold;color:red;" class="margin_left_and_big_font">Error: Website with number <%=number%> was not found.</span>

    <%
            throw new jakarta.servlet.jsp.SkipPageException();
        }
    %>
    <style>
        th{
            text-align:left;
            background:#cccccc;
        }
    </style>
    <p class="margin_left_and_big_font">
 
        
        <a href="read_variant.jsp?number=<%=variant.getNumber() - 1%>" class="button">Previous</a>
        <a href="read_variant.jsp?number=<%=variant.getNumber() + 1%>" class="button">Next</a>
    </p>
<script>  
function redirectToUpdate() {
    

<% if(canUpdate) { %>
window.location.href = 'update_variant.jsp?number=<%=number%>'
<% } %>
    

}

</script>  
    <table ondblclick = "redirectToUpdate()">
        <tr>
            <th>Number</th><td><%=variant.getNumber()%></td>

            <%

                File file = new File(System.getProperty("nanotask.confpath") + "/" + "variantsScreenshots/" + variant.getNumber() + ".jpg");
                if (file.exists()) {
                    String imageBase64Encoded = null;
                    try {
                        byte[] fileContent = Files.readAllBytes(file.toPath());
                        imageBase64Encoded = Base64.getEncoder().encodeToString(fileContent);
            %><td rowspan="12"><img src="data:image/jpg;base64, <%=imageBase64Encoded%>" alt="screenshot" style="max-height:600px;"/></td><%
                } catch (IOException e) {
                    log("Could not read file " + file, e);
                }

            }%>



        </tr>
        <tr><th>Name</th><td><%=variant.getName()%></td></tr>
        <tr><th>Note</th><td><%=OctagonJakartaUtils.formatToHtml(variant.getNote())%></td></tr>
        <tr><th>Status</th><td><%=OctagonJakartaUtils.formatToHtml(variant.getStatus())%></td></tr>
        <tr><th>Author</th><td><%=OctagonJakartaUtils.formatToHtml(variant.getAuthor())%></td></tr>
        <tr><th>Licence</th><td><%=OctagonJakartaUtils.formatToHtml(variant.getLicence())%></td></tr>
        <tr><th>User interface</th><td><%=OctagonJakartaUtils.formatToHtml(variant.getUserInterface())%></td></tr>
        <tr><th>Programming language</th><td><%=OctagonJakartaUtils.formatToHtml(variant.getProgrammingLanguage())%></td></tr>
        <tr><th>Binaries</th><td><%=OctagonJakartaUtils.formatToHtml(variant.getBinaries())%></td></tr>
        <tr><th>Open source</th><td><%=OctagonJakartaUtils.formatToHtml(variant.getOpenSource())%></td></tr>
        <tr><th>Last update</th><td><%=OctagonJakartaUtils.formatToHtml(variant.getLastUpdate())%></td></tr>
        <tr><th>Last version</th><td><%=OctagonJakartaUtils.formatToHtml(variant.getLastVersion())%></td></tr>

    </table>
        
        
<div id="footer">Content available under a <a href="http://creativecommons.org/licenses/by-sa/4.0/" target="_blank" title="Content available under a Creative Commons Attribution-ShareAlike 4.0 International License.">Creative Commons Attribution-ShareAlike 4.0 International License</a> <a href="http://creativecommons.org/licenses/by-sa/4.0/" target="_blank" title="Content available under a Creative Commons Attribution-ShareAlike 4.0 International License."><img alt="Content available under a Creative Commons Attribution-ShareAlike 4.0 International License." style="border-width:0" src="images/creative_commons_attribution_share_alike_4.0_international_licence_88x31.png" /></a></div>

</body>
</html>
