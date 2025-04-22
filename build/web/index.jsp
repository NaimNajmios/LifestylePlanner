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
        <title>Nutritionix Food Tracker</title>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
        <style>
            body {
                background-color: #f8f9fa; /* Light gray background for the page */
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; /* Modern font */
            }
            .container {
                background-color: #ffffff; /* White background for the container */
                border-radius: 10px;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1); /* Subtle shadow for depth */
                padding: 30px;
                margin-top: 50px;
                margin-bottom: 50px;
            }
            h2, h3, h5 {
                color: #343a40; /* Dark gray for headings */
            }
            .nav-tabs .nav-link {
                font-weight: 500;
                color: #495057; /* Slightly lighter gray for tab links */
                border: none;
                border-bottom: 2px solid transparent;
                transition: all 0.3s ease;
            }
            .nav-tabs .nav-link:hover {
                border-bottom: 2px solid #007bff; /* Blue underline on hover */
                color: #007bff;
            }
            .nav-tabs .nav-link.active {
                color: #007bff; /* Active tab in blue */
                border-bottom: 2px solid #007bff;
            }
            .tab-content > .tab-pane {
                display: none; /* Initially hide all panes */
            }
            .tab-content > .active {
                display: block; /* Show the active pane */
            }
            .form-group label {
                font-weight: 500;
                color: #495057;
            }
            .form-control {
                border-radius: 5px;
                border: 1px solid #ced4da;
                transition: border-color 0.3s ease;
            }
            .form-control:focus {
                border-color: #007bff;
                box-shadow: 0 0 5px rgba(0, 123, 255, 0.3); /* Subtle blue glow on focus */
            }
            .btn-primary {
                background-color: #007bff;
                border-color: #007bff;
                border-radius: 5px;
                padding: 10px 20px;
                font-weight: 500;
                transition: background-color 0.3s ease;
            }
            .btn-primary:hover {
                background-color: #0056b3;
                border-color: #0056b3;
            }
            .table th {
                cursor: pointer; /* Indicate that the column is sortable */
                background-color: #343a40; /* Dark header background */
                color: #ffffff; /* White text for headers */
                font-weight: 500;
            }
            .table th:hover {
                background-color: #495057; /* Slightly lighter on hover */
            }
            .table td {
                vertical-align: middle; /* Center-align table data */
            }
            .table-striped tbody tr:nth-of-type(odd) {
                background-color: #f8f9fa; /* Light gray for odd rows */
            }
            .total-section {
                background-color: #e9ecef; /* Light gray background for totals */
                border-radius: 5px;
                padding: 15px;
                margin-top: 20px;
            }
            .total-section p {
                margin: 0;
                font-size: 1.1rem;
                color: #343a40;
            }
            .total-section span {
                font-weight: bold;
                color: #007bff; /* Blue for total values */
            }
            .nutrition-info {
                background-color: #ffffff;
                border: 1px solid #dee2e6;
                border-radius: 5px;
                padding: 20px;
                margin-top: 30px;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h2 class="mb-4">Nutritionix Food Tracker</h2>

            <ul class="nav nav-tabs" id="myTab" role="tablist">
                <li class="nav-item">
                    <a class="nav-link active" id="input-tab" data-toggle="tab" href="#input" role="tab" aria-controls="input" aria-selected="true">Input</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" id="summary-tab" data-toggle="tab" href="#summary" role="tab" aria-controls="summary" aria-selected="false">Summary</a>
                </li>
            </ul>

            <div class="tab-content mt-3" id="myTabContent">
                <div class="tab-pane fade show active" id="input" role="tabpanel" aria-labelledby="input-tab">
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
                <div class="tab-pane fade" id="summary" role="tabpanel" aria-labelledby="summary-tab">
                    <h3>Daily Summary</h3>
                    <form action="NutritionSummary" method="post" id="summaryForm">
                        <div class="form-group">
                            <label for="summaryDate">Select Date:</label>
                            <input type="date" class="form-control w-25 d-inline-block" id="summaryDate" name="summaryDate">
                            <button type="submit" class="btn btn-primary ml-2">Load Summary</button>
                        </div>
                    </form>
                    <div id="summaryTable">
                        <% if (request.getAttribute("intakeList") != null) { %>
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
                        <p>No food logged for this date.</p>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>

        <% if (request.getAttribute("intake") != null) {%>
        <div class="container nutrition-info">
            <h3>Nutrition Information</h3>
            <p><%= request.getAttribute("intake")%></p>
        </div>
        <% }%>

        <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.3/dist/umd/popper.min.js"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
        <script>
            $(document).ready(function () {
                // Set today's date as the default value for the date input
                const today = new Date();
                const formattedToday = today.getFullYear() + '-' +
                        String(today.getMonth() + 1).padStart(2, '0') + '-' +
                        String(today.getDate()).padStart(2, '0');
                $('#summaryDate').val(formattedToday);

                // Flag to track if the summary has been loaded
                let summaryLoaded = false;

                // Tab navigation
                $('#myTab a').on('click', function (e) {
                    e.preventDefault();
                    $(this).tab('show');

                    // Auto-submit the form when the Summary tab is clicked for the first time
                    if ($(this).attr('id') === 'summary-tab' && !summaryLoaded) {
                        $('#summaryForm').submit();
                        summaryLoaded = true; // Set flag to prevent re-submission
                    }
                });

                // Calculate totals for the "Total for the Day" section
                function calculateTotals() {
                    let totalCalories = 0;
                    let totalProtein = 0;
                    let totalCarbs = 0;
                    let totalFat = 0;

                    // Iterate over each row in the table body
                    $('#summaryBody tr').each(function () {
                        const calories = parseFloat($(this).find('.calories').text()) || 0;
                        const protein = parseFloat($(this).find('.protein').text()) || 0;
                        const carbs = parseFloat($(this).find('.carbs').text()) || 0;
                        const fat = parseFloat($(this).find('.fat').text()) || 0;

                        totalCalories += calories;
                        totalProtein += protein;
                        totalCarbs += carbs;
                        totalFat += fat;
                    });

                    // Update the totals in the UI (rounded to 1 decimal place)
                    $('#totalCalories').text(totalCalories.toFixed(1));
                    $('#totalProtein').text(totalProtein.toFixed(1));
                    $('#totalCarbs').text(totalCarbs.toFixed(1));
                    $('#totalFat').text(totalFat.toFixed(1));
                }

                // Call calculateTotals on page load if the table exists
                if ($('#summaryBody').length) {
                    calculateTotals();
                    summaryLoaded = true; // Mark as loaded if data is already present
                }
            });

            document.addEventListener('DOMContentLoaded', function() {
            const dateInput = document.getElementById('summaryDate');
            const today = new Date();
            const todayFormatted = today.toISOString().split('T')[0]; // Get today's date in YYYY-MM-DD format

            dateInput.setAttribute('max', todayFormatted);
            });

        </script>
    </body>
</html>