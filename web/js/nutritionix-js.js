// Calculate totals for nutrition information
function calculateTotals() {
    // Get all nutrition values from the table
    const caloriesElements = document.querySelectorAll('.calories');
    const proteinElements = document.querySelectorAll('.protein');
    const carbsElements = document.querySelectorAll('.carbs');
    const fatElements = document.querySelectorAll('.fat');

    // Initialize totals
    let totalCalories = 0;
    let totalProtein = 0;
    let totalCarbs = 0;
    let totalFat = 0;

    // Sum up calories
    caloriesElements.forEach(element => {
        totalCalories += parseFloat(element.textContent) || 0;
    });

    // Sum up protein
    proteinElements.forEach(element => {
        totalProtein += parseFloat(element.textContent) || 0;
    });

    // Sum up carbs
    carbsElements.forEach(element => {
        totalCarbs += parseFloat(element.textContent) || 0;
    });

    // Sum up fat
    fatElements.forEach(element => {
        totalFat += parseFloat(element.textContent) || 0;
    });

    // Update the total elements
    document.getElementById('totalCalories').textContent = totalCalories.toFixed(1);
    document.getElementById('totalProtein').textContent = totalProtein.toFixed(1);
    document.getElementById('totalCarbs').textContent = totalCarbs.toFixed(1);
    document.getElementById('totalFat').textContent = totalFat.toFixed(1);
}

// Call the function when the summary tab is shown
document.addEventListener('DOMContentLoaded', function () {
    // Calculate totals on page load if summary tab is active
    if (document.querySelector('#summary.active')) {
        calculateTotals();
    }

    // Calculate totals whenever the summary tab is clicked
    document.getElementById('summary-tab').addEventListener('click', function () {
        // Use setTimeout to ensure the table is fully rendered before calculating
        setTimeout(calculateTotals, 100);
    });

    // Also calculate totals after a summary is loaded
    document.getElementById('summaryForm').addEventListener('submit', function () {
        // Use setTimeout to calculate after the form is submitted and response received
        setTimeout(calculateTotals, 500);
    });
});

// Add this function to your existing sortTableByDate function
function sortTableByDate() {
    // Your existing sorting code here

    // After sorting, recalculate totals
    calculateTotals();
}