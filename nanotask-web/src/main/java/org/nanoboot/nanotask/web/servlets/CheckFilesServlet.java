///////////////////////////////////////////////////////////////////////////////////////////////
// Nanotask.
// Copyright (C) 2023-2023 the original author or authors.
//
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; version 2
// of the License only.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
///////////////////////////////////////////////////////////////////////////////////////////////
package org.nanoboot.nanotask.web.servlets;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Scanner;
import java.util.logging.Level;
import java.util.logging.Logger;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.nanoboot.octagon.jakarta.utils.OctagonJakartaUtils;

@WebServlet(
        name = "CheckFilesServlet",
        urlPatterns = "/CheckFilesServlet/*"
)
public class CheckFilesServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (OctagonJakartaUtils.cannotUpdate(req)) {
            resp.getOutputStream().println("&nbsp;&nbsp;&nbsp;&nbsp;Access forbidden. <br><br> &nbsp;&nbsp;&nbsp;&nbsp;<a href=\"login.html\" target=\"_blank\">Log in</a>");
            return;
        }

        boolean onlyKO = "true".equals(req.getParameter("onlyko"));
        File fileRootDir = new File(System.getProperty("nanotask.confpath") + "/" + "websitesFormatted/");
        File archiveDir = new File(System.getProperty("nanotask.archiveDir"));
        StringBuilder sb = new StringBuilder("<a href=\"index.jsp\">Back</a><br><br><table><tr><th>Result</th><th>#</th><th>File</th><th>Detail</th></tr>");
        sb.append("""
                  <style>
                  table, th, td {
                      border: 1px solid black;
                      border-collapse: collapse;
                  }
                  
                  th {
                      background: silver;
                  }
                  td,th {
                      padding:8px;
                  }
                  tr:hover {
                      background-color: #cbf8ff;
                  }
                  </style>
                  """);
        String greenOK = "<span style=\"color:green;font-weight:bold\">OK</span>";
        String redKO = "<span style=\"color:red;font-weight:bold\">KO</span>";
        System.err.println(fileRootDir.getAbsolutePath());
        for (File number : fileRootDir.listFiles()) {
            if (!number.isDirectory()) {
                continue;
            }
            System.err.println("Processing:" + number.getAbsolutePath());
            //
            for (File file : number.listFiles()) {
                if (file.getName().equals("website.html")) {
                    continue;
                }
                if (file.getName().endsWith(".sha512")) {
                    continue;
                }
                if (file.isDirectory()) {
                    continue;
                }
                sb.append("<tr>");
                {
                    String realHexString = calculateSha512(file);
                    String expectedHexString = "";
                    File hexFile = new File(file.getParentFile(), file.getName() + ".sha512");

                    if (hexFile.exists()) {
                        Scanner sc = new Scanner(hexFile);

                        // we just need to use \\Z as delimiter
                        sc.useDelimiter("\\Z");

                        expectedHexString = sc.next();
                    } else {
                        expectedHexString = "hexfilemissing";
                    }
                    final boolean result = expectedHexString.equals(realHexString);
                    if (onlyKO && result) {
                        //nothing to do
                        continue;
                    }
                    sb
                            .append("<td>")
                            .append(result ? greenOK : redKO)
                            .append("</td><td>")
                            .append(number.getName())
                            .append("</td><td>")
                            .append(file.getAbsolutePath())
                            .append("</td><td>");
                    if (expectedHexString.equals("hexfilemissing")) {
                        sb.append(".sha512 File is missing");
                    } else {
                        if (!result) {
                            sb.append("Calculated hash differs from the expected one.");
                        }
                    }
                    sb.append("</td>");
                    ////
                }
                sb.append("</tr>");
            }
        }
        for (File archive : archiveDir.listFiles()) {
            if (archive.isDirectory()) {
                continue;
            }
            System.err.println("Processing:" + archive.getAbsolutePath());
            //

     
                sb.append("<tr>");
                {
                    String realHexString = calculateSha512(archive);
                    String expectedHexString = "";
                    File hexFile = new File(archive.getParentFile().getParentFile().getAbsolutePath() + "/archiveCheckSums/", archive.getName() + ".sha512");

                    if (hexFile.exists()) {
                        Scanner sc = new Scanner(hexFile);

                        // we just need to use \\Z as delimiter
                        sc.useDelimiter("\\Z");

                        expectedHexString = sc.next();
                    } else {
                        expectedHexString = "hexfilemissing";
                    }
                    final boolean result = expectedHexString.equals(realHexString);
                    if (onlyKO && result) {
                        //nothing to do
                        continue;
                    }
                    sb
                            .append("<td>")
                            .append(result ? greenOK : redKO)
                            .append("</td><td>")
                            .append(archive.getName())
                            .append("</td><td>")
                            .append(archive.getName())
                            .append("</td><td>");
                    if (expectedHexString.equals("hexfilemissing")) {
                        sb.append(".sha512 File is missing_");
                    } else {
                        if (!result) {
                            sb.append("Calculated hash differs from the expected one.");
                        }
                    }
                    sb.append("</td>");
                    ////
                }
                sb.append("</tr>");
            
        }

        sb.append("</table>");
        resp.getOutputStream().println(sb.toString());

    }

    private static String calculateSha512(File file) {
        return OctagonJakartaUtils.calculateSHA512Hash(file);
    }
}
