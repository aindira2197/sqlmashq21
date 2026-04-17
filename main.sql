CREATE TABLE IF NOT EXISTS SystemSecurityAudit (
    audit_id INT PRIMARY KEY AUTO_INCREMENT,
    table_name VARCHAR(100),
    action_type ENUM('INSERT', 'UPDATE', 'DELETE'),
    record_id INT,
    old_value TEXT,
    new_value TEXT,
    performed_by VARCHAR(100),
    ip_address VARCHAR(45),
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //

CREATE TRIGGER Audit_Employee_Salary_Update
BEFORE UPDATE ON Employees
FOR EACH ROW
BEGIN
    IF OLD.salary <> NEW.salary THEN
        INSERT INTO SystemSecurityAudit (
            table_name, 
            action_type, 
            record_id, 
            old_value, 
            new_value, 
            performed_by
        )
        VALUES (
            'Employees', 
            'UPDATE', 
            OLD.emp_id, 
            CONCAT('Salary: ', OLD.salary), 
            CONCAT('Salary: ', NEW.salary), 
            USER()
        );
    END IF;
END //

CREATE TRIGGER Audit_Product_Price_Change
BEFORE UPDATE ON Products
FOR EACH ROW
BEGIN
    IF OLD.price <> NEW.price THEN
        INSERT INTO SystemSecurityAudit (
            table_name, 
            action_type, 
            record_id, 
            old_value, 
            new_value, 
            performed_by
        )
        VALUES (
            'Products', 
            'UPDATE', 
            OLD.prod_id, 
            CONCAT('Price: ', OLD.price), 
            CONCAT('Price: ', NEW.price), 
            USER()
        );
    END IF;
END //

DELIMITER ;
