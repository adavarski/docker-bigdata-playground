package test;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.Statement;
import java.util.logging.Logger;

public class Main {


        private static final String JDBC_DRIVER_NAME = "org.apache.hive.jdbc.HiveDriver";
        private static final String CONNECTION_URL = "jdbc:hive2://localhost:10000/;ssl=false";

        public static void main(String[] args) throws IOException {

                // create connection
                Connection connection = null;

                try {
                        // set hive driver and connect
                        Class.forName(JDBC_DRIVER_NAME);
                        connection = DriverManager.getConnection(CONNECTION_URL,"hdfs","");

                        // create a statement of query execution
                        Statement stmt = connection.createStatement();

                        // create table and insert data
                        stmt.execute("DROP TABLE IF EXISTS test_table");
                        stmt.execute("CREATE TABLE test_table(Id INT, Message STRING) STORED AS PARQUET");
                        stmt.execute("INSERT INTO test_table VALUES (1, \"test value\")");

                        // select data from table
                        ResultSet resultSet = stmt.executeQuery("SELECT * from test_table");
                        ResultSetMetaData rsmd = resultSet.getMetaData();
                        int columnsNumber = rsmd.getColumnCount();

                        // output the column headings
                        for (int i = 1; i <= columnsNumber; i++) {
                                System.out.print(" | " + rsmd.getColumnName(i));
                        }
                        System.out.print(" |");
                        System.out.println("");

                        // output each row in the table
                        while (resultSet.next()) {

                            // process each column
                            for (int i = 1; i <= columnsNumber; i++) {
                                String columnValue = resultSet.getString(i);
                                System.out.print(" | " +  columnValue);
                            }
                            System.out.print(" |");
                            System.out.println("");
                        }

		} catch (Exception e) {
                        System.out.println("ERROR: "+ e);
                } finally {

                        // close the connection
                        try {
                                connection.close();
                        } catch (Exception e) {
                                System.err.println("There was a problem closing the connection");
                        }
                }

        }
}

