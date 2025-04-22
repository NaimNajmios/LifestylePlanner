<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Nutritionix Food Tracker</title>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    </head>
    <body>
        <div class="container mt-5">
            <h2 class="mb-4">Nutritionix Food Tracker</h2>
            <form action="NutritionixData" method="post">
                <div class="form-group">
                    <label for="foodQuery">Enter Food (e.g., 1 cup of rice):</label>
                    <input type="text" class="form-control" id="foodQuery" name="foodQuery" required>
                </div>
                <button type="submit" class="btn btn-primary">Get Nutrition Info</button>
            </form>

            <% if (request.getAttribute("result") != null) {%>
            <div class="mt-4 p-3 border rounded">
                <h3>Nutrition Information</h3>
                <p><%= request.getAttribute("result")%></p>
            </div>
            <% }%>
        </div>

        <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.3/dist/umd/popper.min.js"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    </body>
</html>