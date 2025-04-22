
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.crypto.Data;

import Database.DatabaseConnection;
import Database.DatabaseAccessObject;
import Entities.Intake;
import Nutritionix.Nutritionix;
import java.io.IOException;
import java.util.Date;
import java.time.LocalDate;

/**
 *
 * @author Naim Najmi
 */
public class NutritionServlet extends HttpServlet {

    private static final String APP_ID = "06afbbe3"; // Replace with your Nutritionix App ID
    private static final String API_KEY = "ccbdc53c092e1466f81ea0b328d45339"; // Replace with your Nutritionix API Key
    private static final String API_URL = "https://trackapi.nutritionix.com/v2/natural/nutrients";

    private Intake intake = new Intake();
    private Nutritionix nutritionix = new Nutritionix();
    private DatabaseAccessObject dao = new DatabaseAccessObject();
    private DatabaseConnection db = new DatabaseConnection();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Test database connection
        DatabaseConnection.testConnection();

        // Get the food query from the request parameter
        String foodQuery = request.getParameter("foodName");
        String quantity = request.getParameter("quantity");
        String mealType = request.getParameter("mealType");
        String remark = request.getParameter("otherInfo");

        // Set the food query in the Intake object
        intake.setFoodQuery(foodQuery);
        intake.setQuantity(quantity);
        intake.setMealType(mealType);
        intake.setRemark(remark);
        LocalDate today = LocalDate.now();

        // Log intake
        System.out.println("Food Query: " + intake.getFoodQuery());
        System.out.println("Quantity: " + intake.getQuantity());
        System.out.println("Meal Type: " + intake.getMealType());
        System.out.println("Remark: " + intake.getRemark());

        // Get the nutrition information for the food query
        nutritionix.setFoodQuery(foodQuery);
        Intake intakeInfo = nutritionix.getNutritionInfo();

        // Set the nutrition information in the Intake object
        intake.setCalories(intakeInfo.getCalories());
        intake.setProtein(intakeInfo.getProtein());
        intake.setCarbs(intakeInfo.getCarbs());
        intake.setFat(intakeInfo.getFat());

        // Set the date consumed in the Intake object
        Date date = java.sql.Date.valueOf(today); // Best for database DATE columns

        // Set the date consumed in the Intake object    
        intake.setDateConsumed(date);

        // Set the remark in the Intake object
        intake.setRemark(remark);

        // Check if the insert was successful
        if (dao.insertIntake(intake)) {
            System.out.println("Intake inserted successfully.");
            // Set result attribute and forward to JSP
            request.setAttribute("intake", intake);
            request.getRequestDispatcher("index.jsp").forward(request, response);
        } else {
            System.out.println("Failed to insert intake.");
            // Handle the error case appropriately
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to insert intake.");
        }

    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
