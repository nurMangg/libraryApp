
package library;

import com.mysql.cj.jdbc.MysqlDataSource;
import java.sql.Connection;
import java.sql.SQLException;

/**
 *
 * @author mangg
 */
public class koneksi {
    public static Connection sambungKeDB(){
        try {
            MysqlDataSource mds = new MysqlDataSource();
            mds.setUser("root");
            mds.setPassword(""); 
            mds.setDatabaseName("uas_pemKomputer"); 
            mds.setServerName("localhost"); 
            mds.setPortNumber(3306); 
            mds.setServerTimezone("Asia/Jakarta"); 
            Connection c = mds.getConnection();
            return c;            
        } catch (SQLException e) {
            System.err.println(e.getMessage());
        }
        
        return null;
    }
}

