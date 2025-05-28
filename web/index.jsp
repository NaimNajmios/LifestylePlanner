<%-- Import List --%>
<%@ page import="java.util.List" %>
<%-- Import Intake class --%>
<%@ page import="Entities.Intake" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Food Nutrition Tracker</title>
        <%-- Prevent caching --%>
        <%
            response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
            response.setHeader("Pragma", "no-cache");
            response.setDateHeader("Expires", 0);

            // Check for active tab parameter
            String activeTab = request.getParameter("activeTab");
            boolean summaryActive = "summary".equals(activeTab);
        %>
        <%-- Include styling --%>
        <%@ include file="../include/nutritionix-styling.html" %>
    </head>
    <body>
        <div class="container">
            <h2 class="mb-4">Food Nutrition Tracker</h2>
            <ul class="nav nav-tabs" id="myTab" role="tablist">
                <li class="nav-item">
                    <a class="nav-link <%= !summaryActive ? "active" : ""%>" id="input-tab" data-toggle="tab" href="#input" role="tab" aria-controls="input" aria-selected="<%= !summaryActive ? "true" : "false"%>">Input</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link <%= summaryActive ? "active" : ""%>" id="summary-tab" data-toggle="tab" href="#summary" role="tab" aria-controls="summary" aria-selected="<%= summaryActive ? "true" : "false"%>">Summary</a>
                </li>
            </ul>

            <div class="tab-content mt-3" id="myTabContent">
                <div class="tab-pane fade <%= !summaryActive ? "show active" : ""%>" id="input" role="tabpanel" aria-labelledby="input-tab">
                    <form action="NutritionServlet" method="post">
                        <div class="form-group">
                            <label for="mealType">Meal Type:</label>
                            <select class="form-control" id="mealType" name="mealType">
                                <option value="Breakfast">Breakfast</option>
                                <option value="Lunch">Lunch</option>
                                <option value="High Tea">High Tea</option>
                                <option value="Dinner">Dinner</option>
                                <option value="Supper">Supper</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="foodName">Food Name:</label>
                            <input type="text" class="form-control" id="foodName" name="foodName" placeholder="e.g., Rice">
                        </div>
                        <div class="form-group">
                            <label for="quantity">Quantity:</label>
                            <input type="text" class="form-control" id="quantity" name="quantity" placeholder="e.g., 1 cup, 100g">
                        </div>
                        <div class="form-group">
                            <label for="otherInfo">Other Info:</label>
                            <textarea class="form-control" id="otherInfo" name="otherInfo" rows="3" placeholder="Any additional details">No additional remark</textarea>
                        </div>
                        <button type="submit" class="btn btn-primary">Add to Summary</button>
                    </form>
                </div>
                <div class="tab-pane fade <%= summaryActive ? "show active" : ""%>" id="summary" role="tabpanel" aria-labelledby="summary-tab">
                    <h3>Daily Summary</h3>
                    <form action="NutritionSummary" method="post" id="summaryForm">
                        <div class="form-group">
                            <label for="summaryDate">Select Date:</label>
                            <input type="date" class="form-control w-25 d-inline-block" id="summaryDate" name="summaryDate" required>
                            <button type="submit" class="btn btn-primary ml-2">Load Summary</button>
                        </div>
                    </form>
                    <div id="summaryTable">
                        <% if (request.getAttribute("errorMessage") != null) {%>
                        <p class="text-danger"><%= request.getAttribute("errorMessage")%></p>
                        <% } else if (request.getAttribute("intakeList") != null && !((List<Intake>) request.getAttribute("intakeList")).isEmpty()) { %>
                        <table class="table table-striped table-bordered">
                            <thead class="thead-dark">
                                <tr>
                                    <th>Meal Type</th>
                                    <th>Food Name</th>
                                    <th>Quantity</th>
                                    <th>Calories</th>
                                    <th>Protein (g)</th>
                                    <th>Carbs (g)</th>
                                    <th>Fat (g)</th>
                                    <th id="sortDate" onclick="sortTableByDate()">Date ▼</th>
                                    <th>Other Info</th>
                                </tr>
                            </thead>
                            <tbody id="summaryBody">
                                <%
                                    List<Intake> intakeList = (List<Intake>) request.getAttribute("intakeList");
                                    for (Intake intake : intakeList) {
                                %>
                                <tr>
                                    <td><%= intake.getMealType()%></td>
                                    <td><%= intake.getFoodQuery()%></td>
                                    <td><%= intake.getQuantity()%></td>
                                    <td class="calories"><%= intake.getCalories()%></td>
                                    <td class="protein"><%= intake.getProtein()%></td>
                                    <td class="carbs"><%= intake.getCarbs()%></td>
                                    <td class="fat"><%= intake.getFat()%></td>
                                    <td><%= intake.getDateConsumed()%></td>
                                    <td><%= intake.getRemark() != null ? intake.getRemark() : "No additional remark"%></td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                        <div class="total-section">
                            <h5>Total for the Day:</h5>
                            <p>
                                Calories: <span id="totalCalories">0.0</span> kcal |
                                Protein: <span id="totalProtein">0.0</span> g |
                                Carbs: <span id="totalCarbs">0.0</span> g |
                                Fat: <span id="totalFat">0.0</span> g
                            </p>
                        </div>
                        <% } else { %>
                        <p>No food logged for this date. Try selecting another date or adding food in the Input tab.</p>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>

        <% if (request.getAttribute("intake") != null) {
            Intake intake = (Intake) request.getAttribute("intake");
        %>
        <div class="container mt-4 mb-4">
            <h4>Nutrition Information for Last Added Item:</h4>
            <div class="form-group">
                <label>Food:</label>
                <input type="text" class="form-control" value="<%= intake.getFoodQuery()%>" readonly>
            </div>
            <div class="form-group">
                <label>Quantity:</label>
                <input type="text" class="form-control" value="<%= intake.getQuantity()%>" readonly>
            </div>
            <div class="form-group">
                <label>Meal Type:</label>
                <input type="text" class="form-control" value="<%= intake.getMealType()%>" readonly>
            </div>
            <% if (intake.getRemark() != null && !intake.getRemark().isEmpty()) { %>
            <div class="form-group">
                <label>Remarks:</label>
                <textarea class="form-control" rows="3" readonly><%= intake.getRemark()%></textarea>
            </div>
            <% } %>

            <hr>

            <h5>Nutritional Values:</h5>
            <div class="form-group">
                <label>Calories:</label>
                <input type="text" class="form-control" value="<%= intake.getCalories()%> kcal" readonly>
            </div>
            <div class="form-group">
                <label>Protein:</label>
                <input type="text" class="form-control" value="<%= intake.getProtein()%>g" readonly>
            </div>
            <div class="form-group">
                <label>Carbs:</label>
                <input type="text" class="form-control" value="<%= intake.getCarbs()%>g" readonly>
            </div>
            <div class="form-group">
                <label>Fat:</label>
                <input type="text" class="form-control" value="<%= intake.getFat()%>g" readonly>
            </div>
        </div>
        <% }%>
    </body>

    <%-- Include JS --%>
    <%@ include file="../include/nutritionix-js.html" %>

</html>