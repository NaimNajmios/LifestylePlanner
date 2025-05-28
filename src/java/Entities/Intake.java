package Entities;

import java.util.Date;
import java.time.LocalDate;

/**
 *
 * @author Naim Najmi
 */
public class Intake {

    // Instance variables
    private String id;
    private String foodQuery;
    private String quantity;
    private double calories;
    private double protein;
    private double carbs;
    private double fat;
    private Date dateConsumed;
    private String mealType;
    private String remark;

    public Intake() {
        // Init
        this.id = null;
        this.foodQuery = null;
        this.quantity = null;
        this.calories = 0.0;
        this.protein = 0.0;
        this.carbs = 0.0;
        this.fat = 0.0;
        this.dateConsumed = java.sql.Date.valueOf(LocalDate.now());
        this.mealType = null;
        this.remark = null;
    }

    public String getId() {
        return this.id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getQuantity() {
        return this.quantity;
    }

    public void setQuantity(String quantity) {
        this.quantity = quantity;
    }

    public String getFoodQuery() {
        return this.foodQuery;
    }

    public void setFoodQuery(String foodQuery) {
        this.foodQuery = foodQuery;
    }

    public double getCalories() {
        return this.calories;
    }

    public void setCalories(double calories) {
        this.calories = calories;
    }

    public double getProtein() {
        return this.protein;
    }

    public void setProtein(double protein) {
        this.protein = protein;
    }

    public double getCarbs() {
        return this.carbs;
    }

    public void setCarbs(double carbs) {
        this.carbs = carbs;
    }

    public double getFat() {
        return this.fat;
    }

    public void setFat(double fat) {
        this.fat = fat;
    }

    public Date getDateConsumed() {
        return dateConsumed;
    }

    // This is the critical method:
    public void setDateConsumed(Date dateConsumed) { // Parameter MUST be java.sql.Date
        this.dateConsumed = dateConsumed;
    }

    public String getMealType() {
        return this.mealType;
    }

    public void setMealType(String mealType) {
        this.mealType = mealType;
    }

    public String getRemark() {
        return this.remark;
    }

    public void setRemark(String remark) {
        this.remark = remark;
    }

    @Override
    public String toString() {
        return "Intake{"
                + "id='" + id + '\''
                + ", foodQuery='" + foodQuery + '\''
                + ", quantity='" + quantity + '\''
                + ", calories=" + calories
                + ", protein=" + protein
                + ", carbs=" + carbs
                + ", fat=" + fat
                + ", dateConsumed=" + dateConsumed
                + ", mealType='" + mealType + '\''
                + ", remark='" + remark + '\''
                + '}';
    }

}
