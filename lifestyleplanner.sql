-- Lifestyle Planner DB

DROP DATABASE IF EXISTS lifestyleplanner;

CREATE DATABASE lifestyleplanner;

USE lifestyleplanner;

-- Calorie  Table
-- id, food consumed, quantity, calories(kcal), protein(g), carbohydrate(g), fat(g),  date, type of meals, remark
CREATE TABLE intake (
    id INT NOT NULL AUTO_INCREMENT,
    foodconsumed VARCHAR(255) NOT NULL,
    quantity VARCHAR(255) NOT NULL,
    calories DECIMAL(6, 2) NOT NULL,
    protein DECIMAL(5, 2) NOT NULL,
    carbohydrate DECIMAL(5, 2) NOT NULL,
    fat DECIMAL(5, 2) NOT NULL,
    date DATE NOT NULL,
    type VARCHAR(255) NOT NULL CHECK (type IN ('Breakfast', 'Lunch', 'High Tea', 'Dinner', 'Supper')),
    remark VARCHAR(255),
    PRIMARY KEY (id)
);

-- Example of PreparedStatement to insert data into the table
-- PreparedStatement ps = conn.prepareStatement("insert into intake (foodconsumed, quantity, calories, protein, carbohydrate, fat, date, type, remark) values (?, ?, ?, ?, ?, ?, ?, ?, ?)");
-- ps.setString(1, "Chicken Rice");
-- ps.setString(2, "200g");
-- ps.setDouble(3, 500);
-- ps.setDouble(4, 50);
-- ps.setDouble(5, 30);
-- ps.setDouble(6, 20);
-- ps.setDate(7, new java.sql.Date(System.currentTimeMillis()));
-- ps.setString(8, "Lunch");
-- ps.setString(9, "Good");
-- ps.executeUpdate();

