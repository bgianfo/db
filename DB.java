/** 
 * Crud.java - first cut at Oracle 9i version
 * This program illustrates database CRUD operations.
 * @author Brian Gianforcaro 
 * @author Nicholas Williams
 * @author David Erberhart
 **/ 

import java.io.*;
import java.sql.*;
import java.lang.*;
 
public class DB {

    private static String USER = "p48570c";
    private static String PASS = "eeph5efiXeow";
    private static String URL = "jdbc:oracle:thin:@queeg:1521:csodb10";


    private Connection con;

    public DB() {
	try {
		System.out.print("Connecting...");
		Class.forName("oracle.jdbc.driver.OracleDriver");
		this.con = DriverManager.getConnection( URL, USER, PASS );
		System.out.println("Success!");
	} catch( Exception e ) {
		e.printStackTrace();
		System.exit(0);
	}
    }

    private void close(  ) {
	try {
	  this.con.close();
 	  System.out.println("Disconnected");
	} catch( Exception e ) {
	  e.printStackTrace();
	  System.exit(0);
	}
    }

    /**
     *  Status:
     *
     *    [ ]	a) Report listing managers name and telephone for each hall of residence.
     * 
     *	  [ ]	b) Present a report listing names and banner numbers of students with the details of lease 
     * 
     *	  [ ]	c) Display the details of the lease agreements that include the summer semester.
     *
     *	  [ ]	d) Display the details of the total rent paid by a given student.
     *
     *	  [ ]	e) Present a report on students who have not paid their invoices by a given date.
     *
     *	  [X]	f) Display the details of apartment inspections where the property was found to be in unsatisfactory condition. 
     *
     *	  [ ]	g) Present a report of the names and banner numbers of students with their room number and place number in a particular hall of residence.
     *
     *	  [X]	h) Present a report listing the details of all students currently on the waiting list for accommodations; this is, who were not placed.  
     *
     *	  [X]	i) Display the total number of students of each category. 
     *
     *	  [X]	j) Present a report of the names and banner numbers for all students who have not supplied details of their next-of-kin.
     *
     *	  [ ]	k) Display the name and internal telephone number of the Adviser of a particular student. 
     *
     *	  [X]	l) Display the min, max and average monthly rent for rooms in residence halls.
     */

    private void runSimpleCommand( String cmd ) {
	String query;
        ResultSet rs;

	try {

 	  Statement stmt = this.con.createStatement();
	  if ( cmd.contains("categoryTotals") ) {

	     String types[] = { "Undergrad", "Grad", "Postgrad" };
	     for( String type : types ) {
	       query = "SELECT COUNT(*) AS \"number\" FROM Student WHERE category LIKE '" + type + "'";
	       rs = stmt.executeQuery( query );
	       while ( rs.next() ) {
	         int count = rs.getInt("number");
	         System.out.println( type + "  " + count );
	       }
	     }

   	  } else if ( cmd.contains("badApartments") ) {
	      query = "SELECT aptNo " +
   	              "FROM Inspects WHERE result LIKE '%fail%'";

              System.out.println(" Apartment Number | Banner Number | Student Name ");
              System.out.println("-------------------------------------------------------------------");

	      rs = stmt.executeQuery( query );
	      while ( rs.next() ) {
		 int aptNo = rs.getInt("aptNo");
		 query = "SELECT Leases.bannerNo AS \"bannerNo\" " +
			 "FROM Leases, Room WHERE " +
			 "Room.aptNo = " + aptNo + " AND Room.placeNo = Leases.placeNo" ;
	         ResultSet rs2 = stmt.executeQuery( query );
		 rs2.next();
		 String bannerNo = rs2.getString("bannerNo");
 		 query = "SELECT lastName, firstName, middleName " +
		         "FROM Student WHERE bannerNo LIKE '" + bannerNo +"'";

	         ResultSet rs3 = stmt.executeQuery( query );

		 rs3.next();
	         String last = rs3.getString("lastName");
	         String first = rs3.getString("firstName");
	         String middl = rs3.getString("middleName");
	         System.out.println( aptNo + " |  " + bannerNo + " | " + first + " " + middl + " " + last );
	      }

	  } else if ( cmd.contains("rentStats") ) {

	      query = "SELECT MIN(rentRate) AS \"min\" " +
		      "FROM Room WHERE horName IS NOT NULL AND " +
		      "horRoomNo IS NOT NULL";

	      rs = stmt.executeQuery( query );
	      rs.next();
	      int min = rs.getInt("min");
	      System.out.println( "Min Rent: " + min );

	      query = "SELECT MAX(rentRate) AS \"max\" " +
	  	      "FROM Room WHERE horName IS NOT NULL AND " +
		      "horRoomNo IS NOT NULL";
	      rs = stmt.executeQuery( query );
	      rs.next();
	      int max = rs.getInt("max");
	      System.out.println( "Max Rent: " + max );

	      query = "SELECT AVG(rentRate) AS \"avg\" " +
 	 	      "FROM Room WHERE horName IS NOT NULL AND " +
		      "horRoomNo IS NOT NULL";
	      rs = stmt.executeQuery( query );
	      rs.next();
	      int avg = rs.getInt("avg");
	      System.out.println( "Average Rent: " + avg );

   	  } else if ( cmd.contains("noKin") ) {

	      query = "SELECT lastName, firstName, middleName, bannerNo " +
		      "FROM Student WHERE bannerNo NOT IN ( SELECT bannerNo FROM Has_Next_Of_Kin )";
	      rs = stmt.executeQuery( query );
	      System.out.println(" Banner Number | Student Name ");
	      System.out.println("-------------------------------------------------------------------");

	      while ( rs.next() ) {
	        String banner = rs.getString("bannerNo");
	        String last = rs.getString("lastName");
	        String first = rs.getString("firstName");
	        String middl = rs.getString("middleName");
	        System.out.println( banner + " | " + first + " " + middl + " " + last );
	      }
          } else if ( cmd.equals("awaitingAccommodations") ) {
		System.out.println("Students awaiting accommodations:");
		System.out.println("  Banner Number | Student Name");
		System.out.println("  -------------------------------------------------------------------------");
		
		query = "SELECT * FROM Student WHERE bannerNo NOT IN (SELECT bannerNo FROM Leases)";
		rs = stmt.executeQuery( query );
		while ( rs.next() ) {
		  System.out.print("  " + rs.getString("bannerNo"));
		  System.out.println( " | " + rs.getString("firstName") + " " + rs.getString("middleName") + " " + rs.getString("lastName"));
		}
	}


	  stmt.close();
	} catch( Exception e ) {
	  e.printStackTrace();
	  System.exit(0);
	}
    }

    public static void main( String args[] ) {

	DB runner = new DB();

	try {

	    InputStreamReader inReader = new InputStreamReader(System.in);
	    BufferedReader bReader = new BufferedReader( inReader );

	    String c;
  	    while ( true ) {

	        System.out.print("> ");
	        c = bReader.readLine();

		if ( c == null ) {
		  System.out.println();
		  break;
		} else if ( c.equals("awaitingAccommodations") || c.contains("categoryTotals") ||
		            c.contains("noKin") || c.contains("rentStats") || c.contains("badApartments") ) {
		   runner.runSimpleCommand( c );
		} else if ( c.contains("quit") ) {

	 	   break;

		} else if ( c.contains("help") ) {

		   System.out.println( "Commands:\n" );
		   System.out.println( "  categoryTotals - Display the total number of students of each category.\n" );
		   System.out.println( "  rentStats - Display the min, max and average monthly rent for rooms in residence halls.\n" );
		   System.out.println( "  noKin - List all students who have not supplied details of their next-of-kin.\n" );
		   System.out.println( "  awaitingAccommodations- List details of students currently on the waiting list for accommodations. \n"); 
     		   System.out.println( "  badApartments - Display  apartments where the property was found to be in unsatisfactory condition.\n"); 
 
		} else {
		   System.out.println( "Unknown Command" );
		}
	    }
	    runner.close();
	}
	catch( Exception e ) {
	    e.printStackTrace();
	}
    }
}
