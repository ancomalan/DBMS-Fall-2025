import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Scanner;

public class Vo_Alan_IP_Task5b {

	// Database credentials
	final static String HOSTNAME = "vo0063-sql-server.database.windows.net";
	final static String DBNAME = "cs-dsa-4513-sql-db";
	final static String USERNAME = "vo0063";
	final static String PASSWORD = "A1@njas0n";

	// Database connection string
	final static String URL = String.format("jdbc:sqlserver://%s:1433;database=%s;user=%s;password=%s;encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30;",
			HOSTNAME, DBNAME, USERNAME, PASSWORD);

	// Query templates
	//template for inserting into Person table 
	final static String INSERT_PERSON = "INSERT INTO Person " + 
										"VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);";
	//template for inserting into Visitor table 
	final static String INSERT_VISITOR = "INSERT INTO Visitor " + 
										 "VALUES (?);";
	//template for inserting into Enroll_in table (associating visitors with park programs)
	final static String INSERT_ENROLL_IN = "INSERT INTO Enroll_in "+ 
										   "VALUES (?, ?, ?, ?, ?);";
	//template for inserting into Park_pass table 
	final static String INSERT_PARK_PASS = "INSERT INTO Park_pass " + 
										   "VALUES (?, ?, ?);";
	//template for inserting into Holds table (visitors can hold many park passes)
	final static String INSERT_HOLDS = "INSERT INTO Holds " + 
									   "VALUES (?, ?);";
	//template for inserting into Person_phone table (multi-valued attribute of Person table technically)
	final static String INSERT_PERSON_PHONE = "INSERT INTO Person_phone " + 
											  "VALUES (?, ?); ";
	//template for inserting into Person_email table (multi-valued attribute of Person table technically)
	final static String INSERT_PERSON_EMAIL = "INSERT INTO Person_email " + 
											  "VALUES (?, ?);";
	//template for inserting into Emergency_contact table 
	final static String INSERT_EMERGENCY_CONTACT = "INSERT INTO Emergency_contact " + 
												   "VALUES (?, ?, ?, ?);";
	
	//query 13: Retrieve the names, IDs, contact information, and newsletter subscription status of all individuals in the database (following three queries)
	final static String RETRIEVE_PEOPLE = "SELECT person_ID, first_name, last_name, middle_initial, subscribed_to_newsletter FROM Person; ";
	final static String RETRIEVE_PHONE_NUMBERS = "SELECT * FROM Person_phone; ";
	final static String RETRIEVE_EMAILS = "SELECT * FROM Person_email; ";

	
	// User input prompt
	final static String PROMPT = 
			"\nPlease select one of the options below: \n" +
					"1) Insert a new visitor into the database and associate them with one or more park programs; \n" + 
					"13) Retrieve the names, IDs, contact information, and newsletter subscription status of all individuals in the database; \n" + 
					"18) Quit";

	public static void main(String[] args) throws SQLException {

		System.out.println("WELCOME TO THE NATIONAL PARK SERVICE SYSTEM DATABASE");

		final Scanner sc = new Scanner(System.in); // Scanner is used to collect the user input
		String option = ""; // Initialize user option selection as nothing
		while (!option.equals("18")) { // Ask user for options until option 18 is selected
			System.out.println(PROMPT); // Print the available options
			option = sc.next(); // Read in the user option selection

			switch (option) { // Switch between different options
			case "1": // Insert a new visitor and associate them with one or more park programs
				// Collect input data from user
				System.out.println("Please enter visitor's ID: ");
				final int visitor_ID = sc.nextInt(); // Read in the user input for person_ID

				System.out.println("Please enter visitor's first name:");
				// Preceding nextInt, nextFloat, etc. does not consume new line characters from the user input.
				// We call nextLine to consume that newline character, so that subsequent nextLine doesn't return nothing.
				sc.nextLine();
				final String visitor_first_name = sc.nextLine(); // Read in user input of Person's First Name (white-spaces allowed).

				System.out.println("Please enter visitor's last name:");
				// No need to call nextLine extra time here, because the preceding nextLine consumed the newline character.
				final String visitor_last_name = sc.nextLine(); // Read in user input of student Last Name (white-spaces allowed).

				System.out.println("Please enter visitor's middle initial (1 character, if any): ");
				final String visitor_middle_initial = sc.nextLine();

				System.out.println("Please enter visitor's DOB (YYYY-MM-DD): ");
				final String visitor_DOB = sc.nextLine();

				System.out.println("Please enter visitor's gender (M or F): ");
				final String visitor_gender = sc.nextLine();

				System.out.println("Please enter visitor's street address: ");
				final String visitor_street = sc.nextLine(); 

				System.out.println("Please enter visitor's city: ");
				final String visitor_city = sc.nextLine();

				System.out.println("Please enter visitor's state abbreviation (e.g., AZ): ");
				final String visitor_state = sc.nextLine();

				System.out.println("Please enter visitor's postal code: ");
				final String visitor_postal_code = sc.nextLine();

				System.out.println("Is person subscribed to newsletter from NPSS? (Y or N): ");
				final String visitor_subscription_status = sc.nextLine();


				//execute queries in database 
				System.out.println("Connecting to the database...");
				// Get a database connection and prepare a query statement
				try (final Connection connection = DriverManager.getConnection(URL)) {
					//insert into Person table first
					try (
							final PreparedStatement insertPerson = connection.prepareStatement(INSERT_PERSON)) {
						// Populate the query template with the data collected from the user
						insertPerson.setInt(1, visitor_ID);
						insertPerson.setString(2, visitor_first_name);
						insertPerson.setString(3, visitor_last_name);
						insertPerson.setString(4, visitor_middle_initial);
						insertPerson.setString(5, visitor_DOB);
						insertPerson.setString(6, visitor_gender);
						insertPerson.setString(7, visitor_street);
						insertPerson.setString(8, visitor_city);
						insertPerson.setString(9, visitor_state);
						insertPerson.setString(10, visitor_postal_code);
						insertPerson.setString(11, visitor_subscription_status);

						// Actually execute the populated query
						final int rows_inserted = insertPerson.executeUpdate();
						System.out.println(String.format("Done. %d rows inserted into Person table.", rows_inserted));
					}
					//insert into Visitor table next
					try (
							final PreparedStatement insertVisitor = connection.prepareStatement(INSERT_VISITOR)) {
						//populate query template
						insertVisitor.setInt(1, visitor_ID); // Populate the query template with the data collected from the user
						// Actually execute the populated query
						final int rows_inserted = insertVisitor.executeUpdate();
						System.out.println(String.format("Done. %d rows inserted into Visitor table.", rows_inserted));
					}
					//associate visitor with 1 or more park programs 
					try (
							final PreparedStatement insertEnrollIn = connection.prepareStatement(INSERT_ENROLL_IN)) {
						//associate them with one or more programs 
						System.out.println("How many park programs would you like to associate with this visitor (0 for none)? "); 
						final int number_programs = sc.nextInt();
						sc.nextLine(); //consume newline from preceding nextInt

						//use for loop to associate visitor with multiple park programs (by inserting them multiple times into the Enroll_in table)
						for (int i = 0; i < number_programs; i++) {
							//get park_name, program_name, visit_date, and accessibility_needs (program information)
							//variables are not final because they must be reassigned after every iteration
							//Program and National Park data have to already exist in the database because of foreign key constraints (we can populate Programs with query 7)
							System.out.println("Please enter National Park name: ");
							String park_name = sc.nextLine();

							System.out.println("Please enter program name: ");
							String program_name = sc.nextLine();

							System.out.println("Please enter visit date (YYYY-MM-DD): ");
							String visit_date = sc.nextLine();

							System.out.println("Please enter visitor's accessibility needs: ");
							String accessibility_needs = sc.nextLine(); 

							//populate query template 
							insertEnrollIn.setInt(1, visitor_ID);
							insertEnrollIn.setString(2, park_name);
							insertEnrollIn.setString(3, program_name);
							insertEnrollIn.setString(4, visit_date);
							insertEnrollIn.setString(5, accessibility_needs);

							// Actually execute the populated query
							final int rows_inserted = insertEnrollIn.executeUpdate();
							System.out.println(String.format("Done. %d rows inserted into the Enroll_in table.", rows_inserted));
						}
					}
					//account for visitor holding park passes (query 15)
					try (
							//try with resources can have more than one resource (we need to insert into Park_pass and Holds tables to account for how visitors can hold many park passes)
							final PreparedStatement insertParkPass = connection.prepareStatement(INSERT_PARK_PASS);
							final PreparedStatement insertHolds = connection.prepareStatement(INSERT_HOLDS)
							) {
						//associate visitor with one or more park passes
						System.out.println("How many park passes would you like to associate with this visitor (0 for none)? "); 
						final int number_passes = sc.nextInt();
						sc.nextLine(); //consume newline from preceding nextInt

						//use for loop to associate visitor with multiple park passes, if any
						for (int i = 0; i < number_passes; i++) {
							//variables are not final because they have to be reassigned after every iteration
							System.out.println("Please enter pass ID: ");
							int pass_ID = sc.nextInt();
							sc.nextLine();//consume newline from preceding nextInt
							
							System.out.println("Please enter pass type (e.g., annual, day): ");
							String pass_type = sc.nextLine();

							System.out.println("Please enter expiration date for pass (YYYY-MM-DD): ");
							String pass_expiration_date = sc.nextLine();

							//populate query template 
							insertParkPass.setInt(1, pass_ID);
							insertParkPass.setString(2, pass_type);
							insertParkPass.setString(3, pass_expiration_date);
						
							// Actually execute the populated query
							final int rows_inserted = insertParkPass.executeUpdate(); //insert pass into Park_pass table first since Holds table references it 
							System.out.println(String.format("Done. %d rows inserted into the Park_pass table.", rows_inserted));
							
							//insert into Holds table to account for the relationship
							insertHolds.setInt(1, pass_ID);
							insertHolds.setInt(2, visitor_ID);
							final int rows_inserted2 = insertHolds.executeUpdate();
							System.out.println(String.format("Done. %d rows inserted into the Holds table.", rows_inserted2));
						}
					}
					//account for multi-valued attributes of phone numbers
					try (
							final PreparedStatement insertPhone = connection.prepareStatement(INSERT_PERSON_PHONE)) {
						System.out.println("How many phone numbers would you like to add for visitor (0 for none)?");
						final int number_phones = sc.nextInt();
						sc.nextLine();//consume new line character from nextInt

						//loop based on how many phone numbers that the user wants to insert 
						for (int i = 0; i < number_phones; i++) {
							System.out.println("Please enter phone number " + (i+1) + " for visitor: ");
							String phone_number = sc.nextLine(); //variable is not final since it needs to be reassigned after every iteration

							//populate query template
							insertPhone.setInt(1, visitor_ID); 
							insertPhone.setString(2, phone_number);
							// Actually execute the populated query
							final int rows_inserted = insertPhone.executeUpdate();
							System.out.println(String.format("Done. %d rows inserted into Person_phone table.", rows_inserted));
						}
					}
					//account for multi-valued attribute of emails
					try (
							final PreparedStatement insertEmail = connection.prepareStatement(INSERT_PERSON_EMAIL)) {
						System.out.println("How many email addresses would you like to add for visitor (0 for none)?");
						final int number_emails = sc.nextInt();
						sc.nextLine();//consume new line character from nextInt

						//loop based on how many phone numbers that the user wants to insert 
						for (int i = 0; i < number_emails; i++) {
							System.out.println("Please enter email " + (i+1) + " for visitor: ");
							String email = sc.nextLine(); //variable is not final since it needs to be reassigned after every iteration

							//populate query template
							insertEmail.setInt(1, visitor_ID); 
							insertEmail.setString(2, email);
							// Actually execute the populated query
							final int rows_inserted = insertEmail.executeUpdate();
							System.out.println(String.format("Done. %d rows inserted into Person_email table.", rows_inserted));
						}
					}
					//lastly, account for emergency contacts that each visitor might have (query 8)
					try (
							final PreparedStatement insertEmergencyContact = connection.prepareStatement(INSERT_EMERGENCY_CONTACT)) {
						System.out.println("How many emergency contacts would you like to add for this visitor (0 for none)?");
						final int number_contacts = sc.nextInt(); //use in for loop 
						sc.nextLine();//consume new line character from nextInt

						//loop based on how many emergency contacts that the user wants to insert 
						for (int i = 0; i < number_contacts; i++) {
							//collect all attributes for Emergency_contact 
							System.out.println("Please enter contact name for visitor: "); 
							String contact_name = sc.nextLine(); //variable is not final since it needs to be reassigned after every iteration
							System.out.println("Please enter relationship to the visitor: ");
							String relationship = sc.nextLine();
							System.out.println("Please enter phone number for emergency contact: ");
							String emergency_phone_number = sc.nextLine();

							//populate query template
							insertEmergencyContact.setInt(1, visitor_ID); 
							insertEmergencyContact.setString(2, contact_name);
							insertEmergencyContact.setString(3, relationship);
							insertEmergencyContact.setString(4, emergency_phone_number);

							// Actually execute the populated query
							final int rows_inserted = insertEmergencyContact.executeUpdate();
							System.out.println(String.format("Done. %d rows inserted into Emergency_contact table.", rows_inserted));
						}
					}
				}
				break;
			case "2":
				break;
			case "3": 
				break;
			case "4":
				//insert a new donor 
				//ask if they prefer to be anonymous 
				//insert 2 anonymous and 1 not 
				break;
			case "5": 
				break;
			case "6": 
				break;
			case "7": 
				break;
			case "8": 
				break;
			case "9": 
				break;
			case "10": 
				break;
			case "11": 
				//donors are NOT assumed to all be anonymous 
				
				break;
			case "12": 
				break;
			case "13":
				//Retrieve the names, IDs, contact information, and newsletter subscription status of all individuals in the database
				System.out.println("Connecting to the database...");
				// Get the database connection, create statement and execute it right away, as no user input need be collected
				try (final Connection connection = DriverManager.getConnection(URL)) {
					System.out.println("Dispatching the query...");
					//get attributes from person table 
					try (
							final Statement statement = connection.createStatement();
							final ResultSet resultSet = statement.executeQuery(RETRIEVE_PEOPLE)) {

						System.out.println("Contents of the Person table:");
						System.out.println("person_ID | first_name | last_name | middle_initial | subscribed_to_newsletter ");

						// Unpack the tuples returned by the database and print them out to the user
						while (resultSet.next()) {
							System.out.println(String.format("%s | %s | %s | %s | %s ",
									resultSet.getString(1),
									resultSet.getString(2),
									resultSet.getString(3),
									resultSet.getString(4),
									resultSet.getString(5)));
						}
						System.out.println();
					}
					//get entire Person_phone table
					try (
							final Statement statement = connection.createStatement();
							final ResultSet resultSet = statement.executeQuery(RETRIEVE_PHONE_NUMBERS)) {

						System.out.println("Contents of the Person_phone table:");
						System.out.println("person_ID | phone_number ");

						// Unpack the tuples returned by the database and print them out to the user
						while (resultSet.next()) {
							System.out.println(String.format("%s | %s ",
									resultSet.getString(1),
									resultSet.getString(2)));
						}
						System.out.println();
					}
					try (
							final Statement statement = connection.createStatement();
							final ResultSet resultSet = statement.executeQuery(RETRIEVE_EMAILS)) {

						System.out.println("Contents of the Person_email table:");
						System.out.println("person_ID | email_address ");

						// Unpack the tuples returned by the database and print them out to the user
						while (resultSet.next()) {
							System.out.println(String.format("%s | %s ",
									resultSet.getString(1),
									resultSet.getString(2)));
						}
					}
				}
				break;
			case "14": 
				break;
			case "15": 
				break;
		
			case "18": // Do nothing, the while loop will terminate upon the next iteration
				System.out.println("Exiting! Good-bye!");
				break;
			default: // Unrecognized option, re-prompt the user for the correct one
				System.out.println(String.format(
						"Unrecognized option: %s\n" + 
								"Please try again!", 
								option));
				break;
			}
		}

		sc.close(); // Close the scanner before exiting the application
	}
}
