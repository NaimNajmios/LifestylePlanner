$(document).ready(function () {
    // Set today's date as the default value for the date input
    const today = new Date();
    const formattedToday = today.getFullYear() + '-' +
        String(today.getMonth() + 1).padStart(2, '0') + '-' +
        String(today.getDate()).padStart(2, '0');
    $('#summaryDate').val(formattedToday);

    // Flag to track if the summary has been loaded
    let summaryLoaded = false;

    // Check URL hash or intakeList to activate the correct tab
    const hash = window.location.hash; // e.g., "#summary"
    const hasIntakeList = $('#summaryBody').length > 0; // Check if table body exists (indicates non-empty intakeList)
    if (hash === '#summary' || hasIntakeList) {
        $('#summary-tab').tab('show'); // Activate the Summary tab
        if (!summaryLoaded && !hasIntakeList) {
            $('#summaryForm').submit(); // Submit the form to load data if no data is present
            summaryLoaded = true;
        }
    }

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

    // Reset summaryLoaded when the date changes to allow resubmission
    $('#summaryDate').on('change', function () {
        summaryLoaded = false; // Allow form submission on date change
        $('#summaryForm').submit(); // Submit form immediately on date change
    });

    // Ensure form submission triggers a full page reload
    $('#summaryForm').on('submit', function (e) {
        // Let the form submit naturally (no AJAX), triggering a page reload
        // No need to preventDefault; let the browser handle the POST request
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

    // Sorting function for the Date column
    window.sortTableByDate = function () {
        const table = document.getElementById('summaryBody');
        const rows = Array.from(table.querySelectorAll('tr'));
        const isAscending = document.getElementById('sortDate').textContent.includes('▼');

        rows.sort((a, b) => {
            const dateA = new Date(a.cells[7].textContent);
            const dateB = new Date(b.cells[7].textContent);
            return isAscending ? dateA - dateB : dateB - dateA;
        });

        // Toggle sort indicator
        document.getElementById('sortDate').textContent = isAscending ? 'Date ▲' : 'Date ▼';

        // Re-append sorted rows
        table.innerHTML = '';
        rows.forEach(row => table.appendChild(row));
    };
});

document.addEventListener('DOMContentLoaded', function () {
    const dateInput = document.getElementById('summaryDate');
    const today = new Date();
    const todayFormatted = today.toISOString().split('T')[0]; // Get today's date in<ctrl3348>-MM-DD format

    dateInput.setAttribute('max', todayFormatted);
});