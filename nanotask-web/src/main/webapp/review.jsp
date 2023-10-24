<%@page import="org.nanoboot.octagon.jakarta.utils.OctagonJakartaUtils"%>
<%@page import="org.nanoboot.nanotask.entity.Variant"%>
<%@page import="org.nanoboot.nanotask.persistence.api.VariantRepo"%>
<%@page import="java.util.List"%>
<%@page import="org.nanoboot.nanotask.persistence.api.WebsiteRepo"%>
<%@page import="org.nanoboot.nanotask.entity.Website"%>
<%@page import="org.springframework.web.context.support.WebApplicationContextUtils"%>
<%@page import="org.springframework.context.ApplicationContext"%>
<%@page import="java.io.IOException"%>
<%@page import="java.util.Base64"%>
<%@page import="java.nio.file.Files"%>
<%@page import="java.io.File"%>
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
        <title>Review of variants - Nanotask</title>
        <link rel="stylesheet" type="text/css" href="styles/nanotask.css">
        <link rel="icon" type="image/x-icon" href="favicon.ico" sizes="32x32">
    </head>

    <body>

        <a href="index.jsp" id="main_title">Nanotask</a></span>

    <span class="nav"><a href="index.jsp">Home</a>
        >> <a href="variants.jsp">Variants</a>
        >>
        
                
            <% boolean canUpdate = org.nanoboot.octagon.jakarta.utils.OctagonJakartaUtils.canUpdate(request); %>
<% if(canUpdate) { %>
 <a href="create_variant.jsp">Add Variant</a>
<% } %>
 <a href="review.jsp" class="nav_a_current">Review</a>       
    </span>

    <%
        ApplicationContext context = WebApplicationContextUtils.getWebApplicationContext(getServletContext());
        VariantRepo variantRepo = context.getBean("variantRepoImplSqlite", VariantRepo.class);
    %>


    <%
        List<Variant> variants = variantRepo.list(
                1,
                1000,
                null
                
        );

        if (variants.isEmpty()) {

    %><span style="font-weight:bold;color:orange;" class="margin_left_and_big_font">Warning: Nothing found.</span>

    <%            throw new jakarta.servlet.jsp.SkipPageException();
        }
    %>


        <%
            for (Variant v : variants) {
        %>
                
                   <%

                java.io.File file = new java.io.File(System.getProperty("nanotask.confpath") + "/" + "variantsScreenshots/" + v.getNumber() + ".jpg");
                if (file.exists()) {
                    String imageBase64Encoded = null;
                    try {
                        byte[] fileContent = Files.readAllBytes(file.toPath());
                        imageBase64Encoded = Base64.getEncoder().encodeToString(fileContent);
            %>
    <a href="read_variant.jsp?number=<%=v.getNumber()%>" target="_blank" title="<%=v.getName()%>" >
            <img alt="<%=v.getName()%>" style="max-height:600px;max-width:200px;" src="data:image/jpg;base64, <%=imageBase64Encoded%>" />
    </a>
    
            <%
                } catch (IOException e) {
                    log("Could not read file " + file, e);
                }

            }%>

          
      
        <%
            }
        %>

    </table>
        
        <div id="footer">Content available under a <a href="http://creativecommons.org/licenses/by-sa/4.0/" target="_blank" title="Content available under a Creative Commons Attribution-ShareAlike 4.0 International License.">Creative Commons Attribution-ShareAlike 4.0 International License</a> <a href="http://creativecommons.org/licenses/by-sa/4.0/" target="_blank" title="Content available under a Creative Commons Attribution-ShareAlike 4.0 International License."><img alt="Content available under a Creative Commons Attribution-ShareAlike 4.0 International License." style="border-width:0" src="images/creative_commons_attribution_share_alike_4.0_international_licence_88x31.png" /></a></div>
</body>
</html>
