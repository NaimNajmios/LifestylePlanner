<%@ page import="java.util.List" %>
<%@ page import="Entities.Intake" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Food Nutrition Tracker</title>
        <%
            response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
            response.setHeader("Pragma", "no-cache");
            response.setDateHeader("Expires", 0);
            String activeTab = request.getParameter("activeTab");
            boolean summaryActive = "summary".equals(activeTab);
        %>
        <%@ include file="../include/nutritionix-styling.html" %>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    </head>
    <body>
        <div class="container">
            <h2 class="mb-4"><i class="fas fa-utensils"></i> Food Nutrition Tracker</h2>
            <ul class="nav nav-tabs" id="myTab" role="tablist">
                <li class="nav-item">
                    <a class="nav-link <%= !summaryActive ? "active" : ""%>" id="input-tab" data-toggle="tab" href="#input" role="tab" aria-controls="input" aria-selected="<%= !summaryActive ? "true" : "false"%>">
                        <i class="fas fa-plus-circle"></i> Input
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link <%= summaryActive ? "active" : ""%>" id="summary-tab" data-toggle="tab" href="#summary" role="tab" aria-controls="summary" aria-selected="<%= summaryActive ? "true" : "false"%>">
                        <i class="fas fa-chart-bar"></i> Summary
                    </a>
                </li>
            </ul>

            <div class="tab-content mt-3" id="myTabContent">
                <div class="tab-pane fade <%= !summaryActive ? "show active" : ""%>" id="input" role="tabpanel" aria-labelledby="input-tab">
                    <form action="NutritionServlet" method="post">
                        <div class="form-group">
                            <label for="mealType"><i class="fas fa-clock"></i> Meal Type:</label>
                            <select class="form-control" id="mealType" name="mealType">
                                <option value="Breakfast"><i class="fas fa-coffee"></i> Breakfast</option>
                                <option value="Lunch"><i class="fas fa-hamburger"></i> Lunch</option>
                                <option value="High Tea"><i class="fas fa-mug-hot"></i> High Tea</option>
                                <option value="Dinner"><i class="fas fa-utensils"></i> Dinner</option>
                                <option value="Supper"><i class="fas fa-moon"></i> Supper</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="foodName"><i class="fas fa-apple-alt"></i> Food Name:</label>
                            <input type="text" class="form-control" id="foodName" name="foodName" placeholder="Enter food item (e.g., Grilled Chicken Breast, Brown Rice)">
                        </div>
                        <div class="form-group">
                            <label for="quantity"><i class="fas fa-balance-scale"></i> Quantity:</label>
                            <input type="text" class="form-control" id="quantity" name="quantity" placeholder="Specify amount and unit (e.g., 200g, 1 cup, 2 slices)">
                        </div>
                        <div class="form-group">
                            <label for="otherInfo"><i class="fas fa-info-circle"></i> Additional Notes:</label>
                            <textarea class="form-control" id="otherInfo" name="otherInfo" rows="3" placeholder="Add cooking method, brand, or special preparation details">No additional notes</textarea>
                        </div>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-plus"></i> Add to Summary
                        </button>
                    </form>

                    <% if (request.getAttribute("intake") != null) {
                        Intake intake = (Intake) request.getAttribute("intake");
                    %>
                    <div class="card mt-4">
                        <h3 class="card-title mt-3 ml-3"><i class="fas fa-info-circle"></i> Nutrition Information for Last Added Item</h3>
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-6">
                                    <h5 class="mb-3"><i class="fas fa-utensils"></i> Food Details</h5>
                                    <table class="table table-striped">
                                        <tbody>
                                            <tr>
                                                <td><i class="fas fa-apple-alt"></i> Food:</td>
                                                <td><%= intake.getFoodQuery() %></td>
                                            </tr>
                                            <tr>
                                                <td><i class="fas fa-balance-scale"></i> Quantity:</td>
                                                <td><%= intake.getQuantity() %></td>
                                            </tr>
                                            <tr>
                                                <td><i class="fas fa-clock"></i> Meal Type:</td>
                                                <td><%= intake.getMealType() %></td>
                                            </tr>
                                            <% if (intake.getRemark() != null && !intake.getRemark().isEmpty()) { %>
                                            <tr>
                                                <td><i class="fas fa-info-circle"></i> Additional Notes:</td>
                                                <td><%= intake.getRemark() %></td>
                                            </tr>
                                            <% } %>
                                        </tbody>
                                    </table>
                                </div>
                                <div class="col-md-6">
                                    <h5 class="mb-3"><i class="fas fa-chart-pie"></i> Nutritional Values</h5>
                                    <table class="table table-striped">
                                        <tbody>
                                            <tr>
                                                <td><i class="fas fa-fire"></i> Calories:</td>
                                                <td><%= intake.getCalories() %> kcal</td>
                                            </tr>
                                            <tr>
                                                <td><i class="fas fa-drumstick-bite"></i> Protein:</td>
                                                <td><%= intake.getProtein() %> g</td>
                                            </tr>
                                            <tr>
                                                <td><i class="fas fa-bread-slice"></i> Carbs:</td>
                                                <td><%= intake.getCarbs() %> g</td>
                                            </tr>
                                            <tr>
                                                <td><i class="fas fa-cheese"></i> Fat:</td>
                                                <td><%= intake.getFat() %> g</td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                    <% } %>
                </div>
                <div class="tab-pane fade <%= summaryActive ? "show active" : ""%>" id="summary" role="tabpanel" aria-labelledby="summary-tab">
                    <h3><i class="fas fa-chart-line"></i> Daily Summary</h3>
                    <form action="NutritionSummary" method="post" id="summaryForm">
                        <div class="form-group">
                            <label for="summaryDate"><i class="fas fa-calendar-alt"></i> Select Date:</label>
                            <input type="date" class="form-control w-25 d-inline-block" id="summaryDate" name="summaryDate" required>
                            <button type="submit" class="btn btn-primary ml-2">
                                <i class="fas fa-sync"></i> Load Summary
                            </button>
                        </div>
                    </form>
                    <div id="summaryTable">
                        <% if (request.getAttribute("errorMessage") != null) { %>
                        <p class="text-danger">
                            <i class="fas fa-exclamation-triangle"></i> <%= request.getAttribute("errorMessage") %>
                        </p>
                        <% } else if (request.getAttribute("intakeList") != null && !((List<Intake>) request.getAttribute("intakeList")).isEmpty()) { %>
                        <table class="table table-striped table-bordered">
                            <thead class="thead-dark">
                                <tr>
                                    <th><i class="fas fa-clock"></i> Meal Type</th>
                                    <th><i class="fas fa-apple-alt"></i> Food Name</th>
                                    <th><i class="fas fa-balance-scale"></i> Quantity</th>
                                    <th><i class="fas fa-fire"></i> Calories</th>
                                    <th><i class="fas fa-drumstick-bite"></i> Protein (g)</th>
                                    <th><i class="fas fa-bread-slice"></i> Carbs (g)</th>
                                    <th><i class="fas fa-cheese"></i> Fat (g)</th>
                                    <th id="sortDate" onclick="sortTableByDate()">
                                        <i class="fas fa-calendar"></i> Date ▼
                                    </th>
                                    <th><i class="fas fa-info-circle"></i> Additional Notes</th>
                                </tr>
                            </thead>
                            <tbody id="summaryBody">
                                <%
                                    List<Intake> intakeList = (List<Intake>) request.getAttribute("intakeList");
                                    for (Intake intake : intakeList) {
                                %>
                                <tr>
                                    <td><%= intake.getMealType() %></td>
                                    <td><%= intake.getFoodQuery() %></td>
                                    <td><%= intake.getQuantity() %></td>
                                    <td class="calories"><%= intake.getCalories() %></td>
                                    <td class="protein"><%= intake.getProtein() %></td>
                                    <td class="carbs"><%= intake.getCarbs() %></td>
                                    <td class="fat"><%= intake.getFat() %></td>
                                    <td><%= intake.getDateConsumed() %></td>
                                    <td><%= intake.getRemark() != null ? intake.getRemark() : "No additional notes" %></td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                        <div class="total-section">
                            <h5><i class="fas fa-calculator"></i> Total for the Day:</h5>
                            <p>
                                <i class="fas fa-fire"></i> Calories: <span id="totalCalories">0.0</span> kcal |
                                <i class="fas fa-drumstick-bite"></i> Protein: <span id="totalProtein">0.0</span> g |
                                <i class="fas fa-bread-slice"></i> Carbs: <span id="totalCarbs">0.0</span> g |
                                <i class="fas fa-cheese"></i> Fat: <span id="totalFat">0.0</span> g
                            </p>
                        </div>
                        <% } else { %>
                        <p>
                            <i class="fas fa-info-circle"></i> No food entries found for this date. Please select another date or add new entries in the Input tab.
                        </p>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </body>
    <%@ include file="../include/nutritionix-js.html" %>
</html>