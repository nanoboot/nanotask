<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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

<html>
<head>
<title>Nanotask</title>
<link rel="stylesheet" type="text/css" href="styles/nanotask.css">
<link rel="icon" type="image/x-icon" href="favicon.ico" sizes="32x32">
</head>
 
<body>

<a href="index.jsp" id="main_title">Nanotask</a></span>

       <span class="nav"><a href="index.jsp" class="nav_a_current">Home</a>
        >> <a href="websites.jsp">Websites</a>
        <a href="variants.jsp">Variants</a></span>


    <% boolean canUpdate = org.nanoboot.octagon.jakarta.utils.OctagonJakartaUtils.canUpdate(request); %>
<% if(canUpdate) { %>
<form action="<%=request.getContextPath()%>/LogoutServlet" method="post" style="display:inline;margin-left:20px;">
<input type="submit" value="Logout" >
</form>

<br>
<br>
<a href="CheckFilesServlet?onlyko=true" class="button">Check file checksums</a>
<% } else {%>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="login.html" style="margin-left:20px;font-size:120%;" class="button">Log in</a>
<% } %>

<div id="footer">Content available under a <a href="http://creativecommons.org/licenses/by-sa/4.0/" target="_blank" title="Content available under a Creative Commons Attribution-ShareAlike 4.0 International License.">Creative Commons Attribution-ShareAlike 4.0 International License</a> <a href="http://creativecommons.org/licenses/by-sa/4.0/" target="_blank" title="Content available under a Creative Commons Attribution-ShareAlike 4.0 International License."><img alt="Content available under a Creative Commons Attribution-ShareAlike 4.0 International License." style="border-width:0" src="images/creative_commons_attribution_share_alike_4.0_international_licence_88x31.png" /></a></div>

</body>
</html>
