/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.crypto.Data;

import Database.DatabaseAccessObject;
import Entities.Intake;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Date;

/**
 *
 * @author Naim Najmi
 */
public class NutritionSummary extends HttpServlet {

    // DAO object to access the database
    private DatabaseAccessObject dao = new DatabaseAccessObject();

    // List of Intake objects to store the nutrition information
    private ArrayList<Intake> intakeList = new ArrayList<>();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, ParseException {

        ArrayList<Intake> intakeList = new ArrayList<>();

        // Get date request from the form to get the nutrition summary
        String requestedDate = request.getParameter("summaryDate");

        // Log the requested date
        System.out.println("Requested Date: " + requestedDate);

        // Get the nutrition summary for the requested date
        intakeList = dao.getDailyIntakes(requestedDate);

        // Check if the list is empty
        if (intakeList.isEmpty()) {
            // If the list is empty, set an error message
            request.setAttribute("errorMessage", "No nutrition information found for the selected date.");
        } else {
            // If the list is not empty, set the list as an attribute
            request.setAttribute("intakeList", intakeList);
            request.getRequestDispatcher("index.jsp").forward(request, response);

        }

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
        try {
            processRequest(request, response);
        } catch (ParseException ex) {
            throw new ServletException("Error parsing date", ex);
        }
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
        try {
            processRequest(request, response);
        } catch (ParseException ex) {
            throw new ServletException("Error parsing date", ex);
        }
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
