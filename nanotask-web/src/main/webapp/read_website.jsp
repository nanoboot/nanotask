<%@page import="org.nanoboot.octagon.jakarta.utils.OctagonJakartaUtils"%>
<%@page import="org.nanoboot.nanotask.persistence.api.WebsiteRepo"%>
<%@page import="org.nanoboot.nanotask.entity.Website"%>
<%@page import="org.springframework.web.context.support.WebApplicationContextUtils"%>
<%@page import="org.springframework.context.ApplicationContext"%>
<%@page import="java.io.File"%>
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
        >> <a href="websites.jsp">Websites</a>
        >> 
        <a href="read_website.jsp?number=<%=number%>" class="nav_a_current">Read</a>
        
        
                    <% boolean canUpdate = org.nanoboot.octagon.jakarta.utils.OctagonJakartaUtils.canUpdate(request); %>
<% if(canUpdate) { %>
        <a href="update_website.jsp?number=<%=number%>">Update</a>
        <a href="show_content.jsp?number=<%=number%>">Show</a>
        <a href="edit_content.jsp?number=<%=number%>">Edit</a>
        <a href="list_files.jsp?number=<%=number%>">List</a>
        <a href="upload_file.jsp?number=<%=number%>">Upload</a>
        <a href="add_archive.jsp?number=<%=number%>">Add archive</a>
<% } %>


        
        
    </span>




    <%
        ApplicationContext context = WebApplicationContextUtils.getWebApplicationContext(getServletContext());
        WebsiteRepo websiteRepo = context.getBean("websiteRepoImplSqlite", WebsiteRepo.class);
        Website website = websiteRepo.read(Integer.valueOf(number));

        if (website == null) {
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
        <a href="read_website.jsp?number=<%=website.getNumber() - 1%>" class="button">Previous</a>
        <a href="read_website.jsp?number=<%=website.getNumber() + 1%>" class="button">Next</a>
        <br><br>
    </p>
    
<script>  
function redirectToUpdate() {
    
    <% if(canUpdate) { %>
window.location.href = 'update_website.jsp?number=<%=number%>'
<% } %>

}

</script>  
    <table ondblclick = "redirectToUpdate()">
        <tr>
            <th>Number</th><td><%=website.getNumber()%></td></tr>
        <tr><th>Url</th><td><a href="<%=website.getUrl()%>"><%=website.getUrl()%></a></td></tr>
        <tr><th>Archive url</th><td>
                <%
                    if(website.getArchiveUrl() != null && !website.getArchiveUrl().isEmpty()) {%>
                    <a href="<%=OctagonJakartaUtils.formatToHtml(website.getArchiveUrl())%>" target="_blank"><%=OctagonJakartaUtils.formatToHtml(website.getArchiveUrl())%></a>
                    <% } else {%><%=OctagonJakartaUtils.formatToHtml(website.getArchiveUrl())%><%}
            %>
            </td></tr>
        <tr><th>Web archive snapshot</th><td><%=OctagonJakartaUtils.formatToHtml(website.getWebArchiveSnapshot())%></td></tr>
        <tr><th>Language</th><td><%=OctagonJakartaUtils.formatToHtml(website.getLanguage())%></td></tr>
        <tr><th>Content verified</th><td><%=OctagonJakartaUtils.formatToHtml(website.getContentVerified())%></td></tr>
        <tr><th>Archive verified</th><td><%=OctagonJakartaUtils.formatToHtml(website.getArchiveVerified())%></td></tr>
        <tr><th>Variant</th><td><a href="read_variant.jsp?number=<%=OctagonJakartaUtils.formatToHtml(website.getVariantNumber())%>" >Variant #<%=OctagonJakartaUtils.formatToHtml(website.getVariantNumber())%></a></td></tr>
        <tr><th>Comment</th><td><%=OctagonJakartaUtils.formatToHtml(website.getComment())%></td></tr>
        
        <tr><th>Recording</th><td>
                
                <% boolean recordingEnabled = website.getRecordingId() != null && !website.getRecordingId().isEmpty(); 
                
                
                    if (!canUpdate) { out.println(recordingEnabled?"<span style=\"color:#F08080;font-weight:bold;padding:4px;\">Started</span>":"Stopped");}

boolean isWindows = System.getProperty("os.name").toLowerCase().startsWith("windows");
        if (canUpdate) {
            
    %>
    
    
    
                <%
                  String recording_action = request.getParameter("recording_action");
                  if(recording_action != null && !recording_action.isEmpty()) {
                  java.io.File targetArchiveDir = new java.io.File(System.getProperty("nanotask.archiveDir"));
                      java.io.File pywbRootDir = new java.io.File(targetArchiveDir, "/../../.." );
                      String pywbRootDirPath = pywbRootDir.getAbsolutePath();
                      
                  
                    //#####
                  if(recording_action.equals("Start")&&!recordingEnabled){
                  website.setRecordingId(java.util.UUID.randomUUID().toString());
                  //https://www.baeldung.com/run-shell-command-in-java
                  
                  boolean result = org.nanoboot.octagon.jakarta.utils.OctagonJakartaUtils.runProcess("wb-manager init " + website.getRecordingId(), pywbRootDir);
                  
                  if(!result)
                  org.nanoboot.octagon.jakarta.utils.OctagonJakartaUtils.throwErrorInJsp("Creating PyWB collection failed.", out);
                
websiteRepo.update(website);
java.io.File tmpCollection = new java.io.File(pywbRootDirPath + "/collections/" + website.getRecordingId());
java.io.File website_number = new java.io.File(tmpCollection, "/website_number.txt");
java.io.File recording_comment = new java.io.File(tmpCollection, "/recording_comment.txt");

org.nanoboot.powerframework.io.utils.FileUtils.writeTextToFile(website.getNumber().toString(), website_number);
org.nanoboot.powerframework.io.utils.FileUtils.writeTextToFile(website.getRecordingComment() == null ? "" : website.getRecordingComment(), recording_comment);

    }
        //#####
                  if(recording_action.equals("Save")&&recordingEnabled){
                  if(isWindows) org.nanoboot.octagon.jakarta.utils.OctagonJakartaUtils.throwErrorInJsp("Recording is not yet supported on Windows (reason- merging ... cat).", out);
                
                  String originalRecordingId = website.getRecordingId();
                  website.setRecordingId("");
                  
                  
                  java.io.File tmpCollection = new java.io.File(pywbRootDirPath + "/collections/" + originalRecordingId);
                  java.io.File tmpArchiveDir = new java.io.File(tmpCollection, "archive");
                  
                  
                  java.io.File[] foundArchives = tmpArchiveDir.listFiles();
                  if(foundArchives.length == 0) org.nanoboot.octagon.jakarta.utils.OctagonJakartaUtils.throwErrorInJsp("Nothing was recorded. Please, record something.", out);
                
                    
                    websiteRepo.update(website);
                    
                    
                  java.io.File firstArchive = foundArchives[0];
                  String firstArchiveName = firstArchive.getName();
                  java.io.File finalWarcGz = new java.io.File(tmpArchiveDir, website.getNumber() + "." +firstArchiveName);
                  for(java.io.File f:foundArchives) {
                  out.println("found archive " + f.getAbsolutePath());
                    }
                    if(foundArchives.length> 1) {                    
if(!org.nanoboot.octagon.jakarta.utils.OctagonJakartaUtils.runProcess("cat *.warc.gz > tmp&&mv tmp tmp.warc.gz", tmpArchiveDir)) 
    org.nanoboot.octagon.jakarta.utils.OctagonJakartaUtils.throwErrorInJsp("Merging WARC files failed.", out);
    java.io.File tmpWarcGz = new java.io.File(tmpArchiveDir, "tmp.warc.gz");
    tmpWarcGz.renameTo(finalWarcGz);
                    } else {
                    firstArchive.renameTo(finalWarcGz);
                    }
                    
                    java.io.File finalWarcGzInFinalCollection = new java.io.File(targetArchiveDir, finalWarcGz.getName());
                    finalWarcGz.renameTo(finalWarcGzInFinalCollection);
                    String hash = org.nanoboot.octagon.jakarta.utils.OctagonJakartaUtils.calculateSHA512Hash(finalWarcGzInFinalCollection);
                    
                    File archiveCheckSums = new File(finalWarcGzInFinalCollection.getParentFile().getParentFile().getAbsolutePath() + "/" + "archiveCheckSums");
                                System.err.println("archiveCheckSums=" + archiveCheckSums.getAbsolutePath());
                                if(!archiveCheckSums.exists())archiveCheckSums.mkdir();
                                
                                File hexFile = new File(archiveCheckSums, finalWarcGzInFinalCollection.getName() + ".sha512");
org.nanoboot.powerframework.io.utils.FileUtils.writeTextToFile(hash, hexFile);

                                
                                String currentArchives = website.getArchives();
                                if(currentArchives == null) currentArchives = "";
                                website.setArchives(currentArchives + "::::" + finalWarcGzInFinalCollection + "####" + hash);
                                websiteRepo.update(website);
        
                                
                                
                                
                                
                    
                  //tmpCollection.renameTo(new java.io.File(System.getProperty("nanotask.archiveDir") + "/../../saved___" + originalRecordingId));
//                  System.err.println("Renaming " + new java.io.File(System.getProperty("nanotask.archiveDir") + "/../" + originalRecordingId).getAbsolutePath()
//                  + "to " + new java.io.File(System.getProperty("nanotask.archiveDir") + "/../" + originalRecordingId + "_obsolete")
//                  .getAbsolutePath());
                  org.apache.commons.io.FileUtils.deleteDirectory(tmpCollection);
                  %>
                  <script>
        function redirectToRead() {window.location.href = 'read_website.jsp?number=<%=number%>'}
        redirectToRead()
        </script>
<%
    }
    //#####
                  if(recording_action.equals("Abort")&&recordingEnabled){String originalRecordingId = website.getRecordingId();
                  website.setRecordingId("");
                  websiteRepo.update(website);
                  java.io.File newDir = new java.io.File(System.getProperty("nanotask.archiveDir") + "/../../" + originalRecordingId);
                  java.io.File renamed = new java.io.File(System.getProperty("nanotask.archiveDir") + "/../../aborted___" + originalRecordingId);
                  newDir.renameTo(renamed);
                  org.apache.commons.io.FileUtils.deleteDirectory(renamed);
    }

}

                %>
                
                <% recordingEnabled = website.getRecordingId() != null && !website.getRecordingId().isEmpty(); %>
                <%=recordingEnabled?"<span style=\"color:#F08080;font-weight:bold;padding:4px;\">Started</span>":"Stopped"%>
                
                <%if(!recordingEnabled){%><form action="read_website.jsp" method="post" style="margin:0;display:inline;"><input type="hidden" name="number" value="<%=website.getNumber()%>"> <input type="submit" name="recording_action" value="Start" style="padding:4px;margin:2px;"></form><%}%>
                <%if(recordingEnabled){%><form action="read_website.jsp" method="post" style="margin:0;display:inline;"><input type="hidden" name="number" value="<%=website.getNumber()%>"><input type="submit" name="recording_action"  value="Save" style="padding:4px;margin:2px;"></form><%}%>
                <%if(recordingEnabled){%><form action="read_website.jsp" method="post" style="margin:0;display:inline;"><input type="hidden" name="number" value="<%=website.getNumber()%>"><input type="submit" name="recording_action"  value="Abort" style="padding:4px;margin:2px;"></form><%}%>
                <% if(recordingEnabled) { 
                   String archiveWebUrl = System.getProperty("nanotask.archiveWebUrl");
        
        String tmpArchiveWebUrlBase = (archiveWebUrl != null && !archiveWebUrl.isEmpty()) ? (archiveWebUrl) : null;
        String[] tmpArray = tmpArchiveWebUrlBase.split("/");
        tmpArchiveWebUrlBase=(tmpArchiveWebUrlBase.startsWith("localhost") ? "http://" : "") + tmpArchiveWebUrlBase.substring(0,tmpArchiveWebUrlBase.length() - tmpArray[tmpArray.length - 1 ].length() - 1);
        
                %>
                <a style="padding:2px;font-size:110%;margin-left:15px;" href="<%=tmpArchiveWebUrlBase +"/" + website.getRecordingId() + "/record/" + website.getUrl()%>" target="_blank">Record</a>
                <a style="padding:2px;font-size:110%;" href="<%=tmpArchiveWebUrlBase +"/" + website.getRecordingId() + "/" + website.getUrl()%>" target="_blank">Replay</a>
                 <% } %>
                 
                 <% } %>
                 
            </td></tr>
        <tr><th>Recording Id</th><td><%=OctagonJakartaUtils.formatToHtml(website.getRecordingId())%></td></tr>
        <tr><th>Recording comment</th><td><%=OctagonJakartaUtils.formatToHtml(website.getRecordingComment())%></td></tr>
    </table>
        <p class="margin_left_and_big_font"><a href="list_archives.jsp?number=<%=website.getNumber()%>" target="_blank">List archives</a></p>
        
        <% if(website.getArchiveUrl() != null && !website.getArchiveUrl().isEmpty()) {%>
                    
                    <script>
                        function show_pywb_iframe() {
                        document.getElementById('pywb_iframe').innerHTML='<iframe style="width: 100%; height: 100%" src="<%=website.getArchiveUrl()%>"></iframe>'
                    }
                    </script>
                    <span class="margin_left_and_big_font"><button onclick="show_pywb_iframe()">Show website from archive</button></span>
        <div id="pywb_iframe" class="margin_left_and_big_font"></div>
                    <% } %>
        
        
        
        <div id="footer">Content available under a <a href="http://creativecommons.org/licenses/by-sa/4.0/" target="_blank" title="Content available under a Creative Commons Attribution-ShareAlike 4.0 International License.">Creative Commons Attribution-ShareAlike 4.0 International License</a> <a href="http://creativecommons.org/licenses/by-sa/4.0/" target="_blank" title="Content available under a Creative Commons Attribution-ShareAlike 4.0 International License."><img alt="Content available under a Creative Commons Attribution-ShareAlike 4.0 International License." style="border-width:0" src="images/creative_commons_attribution_share_alike_4.0_international_licence_88x31.png" /></a></div>
</body>
</html>
