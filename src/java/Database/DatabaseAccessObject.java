package Database;


import Entities.Intake;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

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
            preparedStatement.setDate(7, new Date(intake.getDateConsumed().getTime())); // Use java.sql.Date
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
}
