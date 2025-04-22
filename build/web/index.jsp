<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Nutritionix Food Tracker</title>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
        <style>
            .tab-content > .tab-pane {
                display: none; /* Initially hide all panes */
            }
            .tab-content > .active {
                display: block; /* Show the active pane */
            }
        </style>
    </head>
    <body>
        <div class="container mt-5">
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
                    <% if (request.getAttribute("summary") != null) {%>
                    <p><%= request.getAttribute("summary")%></p>
                    <% } else { %>
                    <p>No food logged yet today.</p>
                    <% }%>
                </div>
            </div>
        </div>

        <% if (request.getAttribute("intake") != null) {%>
        <div class="mt-4 p-3 border rounded">
            <h3>Nutrition Information</h3>
            <p><%= request.getAttribute("intake")%></p>
        </div>
        <% }%>


        <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.3/dist/umd/popper.min.js"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
        <script>
            $(function () {
                $('#myTab a').on('click', function (e) {
                    e.preventDefault();
                    $(this).tab('show');
                })
            })
        </script>
    </body>
</html>