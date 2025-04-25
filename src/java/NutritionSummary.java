
/*
 * NutritionSummary Servlet
 * Fetches daily nutrition data for a given date and forwards to index.jsp
 */
import java.io.IOException;
import java.text.ParseException;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import Database.DatabaseAccessObject;
import Entities.Intake;

/**
 * Servlet to handle nutrition summary requests
 *
 * @author Naim Najmi
 */
@WebServlet("/NutritionSummary")
public class NutritionSummary extends HttpServlet {

    // DAO object to access the database
    private DatabaseAccessObject dao = new DatabaseAccessObject();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, ParseException {
        // Prevent caching
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        // Get date request from the form to get the nutrition summary
        String requestedDate = request.getParameter("summaryDate");

        // Log the requested date
        System.out.println("Requested Date: " + requestedDate);

        // Get the nutrition summary for the requested date
        ArrayList<Intake> intakeList = dao.getDailyIntakes(requestedDate);

        // Check if the list is empty
        if (intakeList == null || intakeList.isEmpty()) {
            // If the list is empty, set an error message
            request.setAttribute("errorMessage", "No nutrition information found for the selected date.");
            request.getRequestDispatcher("/index.jsp?activeTab=summary").forward(request, response);
        } else {
            // If the list is not empty, set the list as an attribute
            request.setAttribute("intakeList", intakeList);
            request.getRequestDispatcher("/index.jsp?activeTab=summary").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (ParseException ex) {
            throw new ServletException("Error parsing date", ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (ParseException ex) {
            throw new ServletException("Error parsing date", ex);
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet to fetch and display daily nutrition summary";
    }
}
