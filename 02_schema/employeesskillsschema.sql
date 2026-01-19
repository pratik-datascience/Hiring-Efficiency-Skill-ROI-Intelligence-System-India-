CREATE TABLE employee_skills (
    emp_id INT,
    skill_id INT,
    PRIMARY KEY (emp_id, skill_id),
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id),
    FOREIGN KEY (skill_id) REFERENCES skills(skill_id)
);
