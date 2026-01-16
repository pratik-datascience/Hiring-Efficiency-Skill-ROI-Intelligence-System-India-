CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    company_id INT,
    role VARCHAR(100),
    city VARCHAR(50),
    salary INT,
    joining_date DATE,
    exit_date DATE,
    FOREIGN KEY (company_id) REFERENCES companies(company_id)
);
