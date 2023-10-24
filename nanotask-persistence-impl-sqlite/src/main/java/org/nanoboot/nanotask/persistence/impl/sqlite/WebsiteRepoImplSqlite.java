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
package org.nanoboot.nanotask.persistence.impl.sqlite;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import lombok.Setter;
import org.nanoboot.nanotask.entity.Website;
import org.nanoboot.nanotask.persistence.api.WebsiteRepo;

/**
 *
 * @author robertvokac
 */
public class WebsiteRepoImplSqlite implements WebsiteRepo {

    @Setter
    private SqliteConnectionFactory sqliteConnectionFactory;

    @Override
    public List<Website> list(
            int pageNumber,
            int pageSize,
            Boolean contentVerified,
            String archiveVerified,
            String recording,
            Integer number,
            String url,
            Integer variantNumber) {
        int numberEnd = pageSize * pageNumber;
        int numberStart = numberEnd - pageSize + 1;

        List<Website> result = new ArrayList<>();
        StringBuilder sb = new StringBuilder();
        sb
                .append("SELECT * FROM ")
                .append(WebsiteTable.TABLE_NAME)
                .append(" WHERE ");
        boolean pagingIsEnabled = contentVerified == null && (archiveVerified == null || archiveVerified.equals("all"))  && number == null && url == null && variantNumber == null;

        if (pagingIsEnabled) {
            sb.append(WebsiteTable.NUMBER)
                    .append(" BETWEEN ? AND ? ");
        } else {
            sb.append("1=1");
        }
        if (contentVerified != null) {
            sb.append(" AND ").append(WebsiteTable.CONTENT_VERIFIED)
                    .append("=?");
        }

        if (number != null) {
            sb.append(" AND ").append(WebsiteTable.NUMBER)
                    .append("=?");
        }
        if (url != null) {
            sb.append(" AND ").append(WebsiteTable.URL)
                    .append(" LIKE '%' || ? || '%'");
        }
        if (variantNumber != null) {
            sb.append(" AND ").append(WebsiteTable.VARIANT_NUMBER)
                    .append(" =?");
        }
        if (recording != null && recording.equals("yes")) {
            sb.append(" AND ")
                    .append(WebsiteTable.RECORDING_ID)
                    .append(" IS NOT NULL AND ")
                    .append(WebsiteTable.RECORDING_ID)
            .append("!='' ");
        }

        if (recording != null && recording.equals("no")) {
            sb.append(" AND ")
                    .append(WebsiteTable.RECORDING_ID)
                    .append(" IS NULL OR ")
                    .append(WebsiteTable.RECORDING_ID)
                    .append("='' ");
        }
        if (archiveVerified != null && archiveVerified.equals("yes")) {
            sb.append(" AND ")
                    .append(WebsiteTable.ARCHIVE_VERIFIED)
                    .append(" IS NOT NULL AND ")
                    .append(WebsiteTable.ARCHIVE_VERIFIED)
            .append("=1 ");
        }

        if (archiveVerified != null && archiveVerified.equals("no")) {
            sb.append(" AND ")
                    .append(WebsiteTable.ARCHIVE_VERIFIED)
                    .append(" IS NULL OR ")
                    .append(WebsiteTable.ARCHIVE_VERIFIED)
                    .append("!=1 ");
        }
        String sql = sb.toString();
        System.err.println(sql);
        int i = 0;
        ResultSet rs = null;
        try (
                 Connection connection = sqliteConnectionFactory.createConnection();  PreparedStatement stmt = connection.prepareStatement(sql);) {
            if (pagingIsEnabled) {
                stmt.setInt(++i, numberStart);
                stmt.setInt(++i, numberEnd);
            }

            if (contentVerified != null) {
                stmt.setInt(++i, contentVerified ? 1 : 0);
            }
            if (number != null) {
                stmt.setInt(++i, number);
            }
            if (url != null) {
                stmt.setString(++i, url);
            }
            if (variantNumber != null) {
                stmt.setInt(++i, variantNumber);
            }
            System.err.println(stmt.toString());
            rs = stmt.executeQuery();

            while (rs.next()) {
                result.add(extractWebsiteFromResultSet(rs));
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(WebsiteRepoImplSqlite.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
            } catch (SQLException ex) {
                Logger.getLogger(WebsiteRepoImplSqlite.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return result;
    }

    private static Website extractWebsiteFromResultSet(final ResultSet rs) throws SQLException {
        return new Website(
                rs.getInt(WebsiteTable.NUMBER),
                rs.getString(WebsiteTable.URL),
                rs.getString(WebsiteTable.ARCHIVES),
                rs.getString(WebsiteTable.WEB_ARCHIVE_SNAPSHOT),
                rs.getString(WebsiteTable.LANGUAGE),
                rs.getInt(WebsiteTable.CONTENT_VERIFIED) != 0,
                rs.getInt(WebsiteTable.ARCHIVE_VERIFIED) != 0,
                rs.getInt(WebsiteTable.VARIANT_NUMBER),
                rs.getString(WebsiteTable.COMMENT),
                rs.getString(WebsiteTable.RECORDING_ID),
                rs.getString(WebsiteTable.RECORDING_COMMENT)
        );
    }

    @Override
    public int create(Website website) {
        StringBuilder sb = new StringBuilder();
        sb
                .append("INSERT INTO ")
                .append(WebsiteTable.TABLE_NAME)
                .append("(")
                .append(WebsiteTable.URL).append(",")
                .append(WebsiteTable.ARCHIVES).append(",")
                .append(WebsiteTable.WEB_ARCHIVE_SNAPSHOT).append(",")
                .append(WebsiteTable.LANGUAGE).append(",")
                //
                
                .append(WebsiteTable.CONTENT_VERIFIED).append(",")
                .append(WebsiteTable.ARCHIVE_VERIFIED).append(",")
                .append(WebsiteTable.COMMENT).append(",")
                .append(WebsiteTable.RECORDING_ID).append(",")
                .append(WebsiteTable.RECORDING_COMMENT);
        if (website.getVariantNumber() != null) {
            sb.append(",").append(WebsiteTable.VARIANT_NUMBER);
        }
        sb.append(")")
                .append(" VALUES (?,?,?,?,  ?,?,? ,?,?");
        if (website.getVariantNumber() != null) {
            sb.append(",?");
        }
        sb.append(")");

        String sql = sb.toString();
        System.err.println(sql);
        try (
                 Connection connection = sqliteConnectionFactory.createConnection();  PreparedStatement stmt = connection.prepareStatement(sql);) {
            int i = 0;
            stmt.setString(++i, website.getUrl());
            stmt.setString(++i, website.getArchives());
            stmt.setString(++i, website.getWebArchiveSnapshot());
            stmt.setString(++i, website.getLanguage());
            //
            
            stmt.setInt(++i, website.getContentVerified()? 1 : 0);
            stmt.setInt(++i, website.getArchiveVerified()? 1 : 0);
            stmt.setString(++i, website.getComment() == null ? "" : website.getComment());
            stmt.setString(++i, website.getRecordingId() == null ? "" : website.getRecordingId());
            stmt.setString(++i, website.getRecordingComment() == null ? "" : website.getRecordingComment());
            if (website.getVariantNumber() != null) {
                stmt.setInt(++i, website.getVariantNumber());
            }
            //

            stmt.execute();
            //System.out.println(stmt.toString());
            ResultSet rs = connection.createStatement().executeQuery("select last_insert_rowid() as last");
            while (rs.next()) {
                int numberOfNewWebsite = rs.getInt("last");
                //System.out.println("numberOfNewWebsite=" + numberOfNewWebsite);
                return numberOfNewWebsite;
            }

        } catch (SQLException e) {
            System.out.println(e.getMessage());
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(WebsiteRepoImplSqlite.class.getName()).log(Level.SEVERE, null, ex);
        }
        System.err.println("Error.");
        return 0;
    }

    @Override
    public Website read(Integer number) {

        if (number == null) {
            throw new RuntimeException("number is null");
        }
        StringBuilder sb = new StringBuilder();
        sb
                .append("SELECT * FROM ")
                .append(WebsiteTable.TABLE_NAME)
                .append(" WHERE ")
                .append(WebsiteTable.NUMBER)
                .append("=?");

        String sql = sb.toString();
        int i = 0;
        ResultSet rs = null;
        try (
                 Connection connection = sqliteConnectionFactory.createConnection();  PreparedStatement stmt = connection.prepareStatement(sql);) {

            stmt.setInt(++i, number);

            rs = stmt.executeQuery();

            while (rs.next()) {
                return extractWebsiteFromResultSet(rs);
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(WebsiteRepoImplSqlite.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
            } catch (SQLException ex) {
                Logger.getLogger(WebsiteRepoImplSqlite.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return null;
    }

    @Override
    public void update(Website website) {
        StringBuilder sb = new StringBuilder();
        sb
                .append("UPDATE ")
                .append(WebsiteTable.TABLE_NAME)
                .append(" SET ")
                .append(WebsiteTable.URL).append("=?, ")
                .append(WebsiteTable.ARCHIVES).append("=?, ")
                .append(WebsiteTable.WEB_ARCHIVE_SNAPSHOT).append("=?, ")
                .append(WebsiteTable.LANGUAGE).append("=?, ")
                //
                
                .append(WebsiteTable.CONTENT_VERIFIED).append("=?, ")
                .append(WebsiteTable.ARCHIVE_VERIFIED).append("=?, ")
                .append(WebsiteTable.VARIANT_NUMBER).append("=?, ")
                .append(WebsiteTable.COMMENT).append("=?, ")
                .append(WebsiteTable.RECORDING_ID).append("=?, ")
                .append(WebsiteTable.RECORDING_COMMENT).append("=?")
                .append(" WHERE ").append(WebsiteTable.NUMBER).append("=?");

        String sql = sb.toString();
        System.err.println(sql);
        try (
                 Connection connection = sqliteConnectionFactory.createConnection();  PreparedStatement stmt = connection.prepareStatement(sql);) {
            int i = 0;
            stmt.setString(++i, website.getUrl());
            stmt.setString(++i, website.getArchives());
            stmt.setString(++i, website.getWebArchiveSnapshot());
            stmt.setString(++i, website.getLanguage());
            //
            stmt.setInt(++i, website.getContentVerified() ? 1 : 0);
            stmt.setInt(++i, website.getArchiveVerified() ? 1 : 0);
            stmt.setInt(++i, website.getVariantNumber());
            stmt.setString(++i, website.getComment());
            stmt.setString(++i, website.getRecordingId());
            stmt.setString(++i, website.getRecordingComment());
            //
            stmt.setInt(++i, website.getNumber());

            int numberOfUpdatedRows = stmt.executeUpdate();
            //System.out.println("numberOfUpdatedRows=" + numberOfUpdatedRows);
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(WebsiteRepoImplSqlite.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

        public boolean hasSuchUrl(String url) {
    
        if (url == null) {
            throw new RuntimeException("url is null");
        }
        StringBuilder sb = new StringBuilder();
        sb
                .append("SELECT count(*) as count FROM ")
                .append(WebsiteTable.TABLE_NAME)
                .append(" WHERE ")
                .append(WebsiteTable.URL)
                .append("=?");

        String sql = sb.toString();
        int i = 0;
        ResultSet rs = null;
        try (
                 Connection connection = sqliteConnectionFactory.createConnection();  PreparedStatement stmt = connection.prepareStatement(sql);) {

            stmt.setString(++i, url);

            rs = stmt.executeQuery();

            while (rs.next()) {
                Integer count = rs.getInt("count");
                return count > 0;
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(WebsiteRepoImplSqlite.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
            } catch (SQLException ex) {
                Logger.getLogger(WebsiteRepoImplSqlite.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        throw new IllegalStateException(this.getClass().getName() + "." + "hasSuchUrl()");
}

    @Override
    public long archived() {
        return archived(true);
    }

    @Override
    public long notArchived() {
        return archived(false);
    }
    private long archived(boolean b) {
        
        StringBuilder sb = new StringBuilder();
        sb
                .append("SELECT count(*) as count FROM ")
                .append(WebsiteTable.TABLE_NAME)
                .append(" WHERE ");
        
                    sb.append(WebsiteTable.ARCHIVE_VERIFIED)
                    .append(" IS NOT NULL AND ")
                    .append(WebsiteTable.ARCHIVE_VERIFIED)
            .append("= ").append(b ? 1 : 0);
       

        String sql = sb.toString();
        System.err.println(sql);
        ResultSet rs = null;
        try (
                 Connection connection = sqliteConnectionFactory.createConnection();  PreparedStatement stmt = connection.prepareStatement(sql);) {


            System.err.println(stmt.toString());
            rs = stmt.executeQuery();

            while (rs.next()) {
                return rs.getInt("count");
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(WebsiteRepoImplSqlite.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
            } catch (SQLException ex) {
                Logger.getLogger(WebsiteRepoImplSqlite.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return 0;
    }
}
