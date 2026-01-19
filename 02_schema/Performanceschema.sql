CREATE TABLE performance (
    emp_id INT PRIMARY KEY,
    rating INT,
    project_count INT,
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id)
);
