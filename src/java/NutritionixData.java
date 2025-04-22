
import java.io.IOException;
import java.io.PrintWriter;
import java.net.URI;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.json.JSONArray;
import org.json.JSONObject;

/**
 *
 * @author Naim Najmi
 */
public class NutritionixData extends HttpServlet {

    private static final String APP_ID = "06afbbe3"; // Replace with your Nutritionix App ID
    private static final String API_KEY = "ccbdc53c092e1466f81ea0b328d45339"; // Replace with your Nutritionix API Key
    private static final String API_URL = "https://trackapi.nutritionix.com/v2/natural/nutrients";

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String foodQuery = request.getParameter("foodQuery");

        try {
            // Build JSON payload
            JSONObject payload = new JSONObject();
            payload.put("query", foodQuery);

            // Create HTTP request using Apache HttpClient
            HttpClient httpClient = HttpClients.createDefault();
            HttpPost httpPost = new HttpPost(API_URL);

            // Set headers
            httpPost.setHeader("Content-Type", "application/json");
            httpPost.setHeader("x-app-id", APP_ID);
            httpPost.setHeader("x-app-key", API_KEY);

            // Set entity (payload)
            StringEntity requestEntity = new StringEntity(payload.toString(), "UTF-8");
            httpPost.setEntity(requestEntity);

            // Send request and get response
            HttpResponse httpResponse = httpClient.execute(httpPost);
            HttpEntity responseEntity = httpResponse.getEntity();
            String responseString = EntityUtils.toString(responseEntity);

            // Parse JSON response
            JSONObject jsonResponse = new JSONObject(responseString);
            JSONArray foods = jsonResponse.getJSONArray("foods");
            StringBuilder result = new StringBuilder();

            for (int i = 0; i < foods.length(); i++) {
                JSONObject food = foods.getJSONObject(i);
                result.append("Food: ").append(food.getString("food_name")).append("<br>")
                        .append("Calories: ").append(food.getDouble("nf_calories")).append(" kcal<br>")
                        .append("Protein: ").append(food.getDouble("nf_protein")).append(" g<br>")
                        .append("Carbohydrates: ").append(food.getDouble("nf_total_carbohydrate")).append(" g<br>")
                        .append("Fat: ").append(food.getDouble("nf_total_fat")).append(" g<br><br>");
            }

            // Set result attribute and forward to JSP
            request.setAttribute("result", result.toString());

        } catch (Exception e) {
            request.setAttribute("result", "Error: " + e.getMessage());
        }

        request.getRequestDispatcher("nutritionix.jsp").forward(request, response);
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
