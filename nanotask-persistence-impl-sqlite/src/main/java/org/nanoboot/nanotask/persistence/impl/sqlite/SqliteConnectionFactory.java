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
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.nanoboot.dbmigration.core.main.MigrationResult;

/**
 *
 * @author robertvokac
 */
public class SqliteConnectionFactory {
    private final String jdbcUrl= "jdbc:sqlite:" + System.getProperty("nanotask.confpath") + "/" + "nanotask.sqlite";
    private boolean migrated = false;
    public Connection createConnection() throws ClassNotFoundException  {
        if(!migrated) {
            MigrationResult migrationResult = SqliteDatabaseMigration.getInstance().migrate();
            if(migrationResult != MigrationResult.SUCCESS) {
                throw new RuntimeException("Database Schema migration failed.");
            }
            migrated = true;
        }
        try {
            Class.forName("org.sqlite.JDBC");
            return DriverManager.getConnection(jdbcUrl);
            
        } catch (SQLException ex) {
            if(true) throw new RuntimeException(ex);
            Logger.getLogger(SqliteConnectionFactory.class.getName()).log(Level.SEVERE, null, ex);
            return null;
        }
    }
    
}
