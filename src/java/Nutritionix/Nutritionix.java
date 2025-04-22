package Nutritionix;

import Entities.Intake;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;
import org.json.JSONArray;
import org.json.JSONObject;
import java.io.IOException;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.impl.client.CloseableHttpClient;

public class Nutritionix {

    private static final String APP_ID = "06afbbe3"; // Replace with your Nutritionix App ID
    private static final String API_KEY = "ccbdc53c092e1466f81ea0b328d45339"; // Replace with your Nutritionix API Key
    private static final String API_URL = "https://trackapi.nutritionix.com/v2/natural/nutrients";

    private String foodQuery;
    private Intake intake = new Intake();

    // Empty constructor
    public Nutritionix() {
    }

    // Constructor with food query
    public Nutritionix(String foodQuery) {
        this.foodQuery = foodQuery;
    }

    // Set food query
    public void setFoodQuery(String foodQuery) {
        this.foodQuery = foodQuery;
    }

    // Get nutrition information for a given food query, return an Intake object
    public Intake getNutritionInfo() {
        // Validate food query
        if (foodQuery == null || foodQuery.trim().isEmpty()) {
            System.err.println("Error: Food query is null or empty");
            return intake;
        }

        // Initialize HTTP client and POST request
        try (CloseableHttpClient httpClient = HttpClients.createDefault()) {
            HttpPost httpPost = new HttpPost(API_URL);

            // Prepare JSON payload
            JSONObject payload = new JSONObject();
            payload.put("query", foodQuery);
            StringEntity requestEntity = new StringEntity(payload.toString(), "UTF-8");
            requestEntity.setContentType("application/json");

            // Set headers
            httpPost.setHeader("x-app-id", APP_ID);
            httpPost.setHeader("x-app-key", API_KEY);
            httpPost.setEntity(requestEntity);

            // Execute request
            try (CloseableHttpResponse response = httpClient.execute(httpPost)) {
                int statusCode = response.getStatusLine().getStatusCode();
                String responseBody = EntityUtils.toString(response.getEntity(), "UTF-8");

                // Validate HTTP status
                if (statusCode != 200) {
                    System.err.println("HTTP Error: Status " + statusCode + ", Response: " + responseBody);
                    return intake;
                }

                // Parse JSON response
                JSONObject jsonResponse = new JSONObject(responseBody);
                if (jsonResponse.has("message")) {
                    System.err.println("API Error: " + jsonResponse.getString("message"));
                    return intake;
                }

                // Extract food data
                JSONArray foods = jsonResponse.getJSONArray("foods");
                if (foods.isEmpty()) {
                    System.err.println("No nutritional data found for query: " + foodQuery);
                    return intake;
                }

                // Process first food item
                JSONObject food = foods.getJSONObject(0);
                intake.setCalories(food.optDouble("nf_calories", 0.0));
                intake.setProtein(food.optDouble("nf_protein", 0.0));
                intake.setCarbs(food.optDouble("nf_total_carbohydrate", 0.0));
                intake.setFat(food.optDouble("nf_total_fat", 0.0));

                // Log nutritional information
                System.out.println("Nutrition Info for '" + foodQuery + "':");
                System.out.println("Calories: " + intake.getCalories() + " kcal");
                System.out.println("Protein: " + intake.getProtein() + " g");
                System.out.println("Carbs: " + intake.getCarbs() + " g");
                System.out.println("Fat: " + intake.getFat() + " g");

            } catch (IOException e) {
                System.err.println("IO Error during API request: " + e.getMessage());
            } catch (Exception e) {
                System.err.println("Error parsing API response: " + e.getMessage());
                e.printStackTrace();
            }
        } catch (IOException e) {
            System.err.println("Error initializing HTTP client: " + e.getMessage());
        }

        return intake;
    }

    @Override
    public String toString() {
        return "Nutritionix{"
                + "intake=" + intake
                + ", foodQuery='" + foodQuery + '\''
                + '}';
    }
}
