package Database;

import Entities.Intake;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 *
 * @author Naim Najmi
 */
public class DatabaseAccessObject {

    private DatabaseConnection db;
    Connection connection = null;
    PreparedStatement preparedStatement = null;
    ResultSet resultSet = null;
    Intake intake = new Intake();

    public DatabaseAccessObject() {
        db = new DatabaseConnection();
    }

    // Method to insert intake into the database, return boolean
    public boolean insertIntake(Intake intake) {
        try {
            connection = db.getConnection();

            // Check intake object for null values
            if (intake == null) {
                System.out.println("Intake object is null.");
                return false;
            } else {
                System.out.println(intake);
            }

            // Preparedstatement
            String sql = "insert into intake (foodconsumed, quantity, calories, protein, carbohydrate, fat, date, type, remark) values (?, ?, ?, ?, ?, ?, ?, ?, ?)";
            preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setString(1, intake.getFoodQuery());
            preparedStatement.setString(2, intake.getQuantity());
            preparedStatement.setDouble(3, intake.getCalories());
            preparedStatement.setDouble(4, intake.getProtein());
            preparedStatement.setDouble(5, intake.getCarbs());
            preparedStatement.setDouble(6, intake.getFat());
            preparedStatement.setDate(7, (java.sql.Date) new Date(intake.getDateConsumed().getTime())); // Use java.sql.Date
            preparedStatement.setString(8, intake.getMealType());
            preparedStatement.setString(9, intake.getRemark());

            // Check if the insert was successful
            if (preparedStatement.executeUpdate() > 0) {
                System.out.println("Intake inserted successfully.");
                return true;
            } else {
                System.out.println("Failed to insert intake.");
                return false;
            }

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            try {
                preparedStatement.close();
                connection.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    // Method to get the intakes from the database, return ArrayList of Intakes for chosen date
    public ArrayList<Intake> getDailyIntakes(String dateStr) {
        ArrayList<Intake> intakes = new ArrayList<>();
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;

        try {
            // Validate the date string
            if (dateStr == null || dateStr.trim().isEmpty()) {
                System.out.println("Invalid date string provided: " + dateStr);
                return intakes; // Return empty list if date is invalid
            }

            // Get database connection
            connection = DatabaseConnection.getConnection();

            // Prepare SQL query
            String sql = "SELECT * FROM intake WHERE date = ?";
            preparedStatement = connection.prepareStatement(sql);

            // Convert the String date to java.sql.Date
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            java.util.Date parsedDate = dateFormat.parse(dateStr);
            preparedStatement.setDate(1, new java.sql.Date(parsedDate.getTime()));

            // Execute query
            resultSet = preparedStatement.executeQuery();

            // Process results
            while (resultSet.next()) {
                Intake intake = new Intake();
                intake.setId(resultSet.getString("id"));
                intake.setFoodQuery(resultSet.getString("foodconsumed"));
                intake.setQuantity(resultSet.getString("quantity"));
                intake.setCalories(resultSet.getDouble("calories"));
                intake.setProtein(resultSet.getDouble("protein"));
                intake.setCarbs(resultSet.getDouble("carbohydrate"));
                intake.setFat(resultSet.getDouble("fat"));
                intake.setDateConsumed(resultSet.getDate("date"));
                intake.setMealType(resultSet.getString("type"));
                intake.setRemark(resultSet.getString("remark"));

                intakes.add(intake);
            }

            // Log the result
            if (intakes.isEmpty()) {
                System.out.println("No intakes found for the given date: " + dateStr);
            } else {
                System.out.println("Intakes found for the given date: " + intakes);
            }

            return intakes;

        } catch (Exception e) {
            e.printStackTrace();
            return intakes; // Return empty list in case of error
        } finally {
            // Close resources
            try {
                if (resultSet != null) {
                    resultSet.close();
                }
                if (preparedStatement != null) {
                    preparedStatement.close();
                }
                if (connection != null) {
                    connection.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
