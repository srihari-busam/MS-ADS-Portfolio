--select * into demo.dbo.timesheets
--from fudgemart_employees join fudgemart_employee_timesheets
--on employee_id = timesheet_employee_id;

-- Q1
USE demo;
GO

DROP INDEX IF EXISTS IX_Time_Sheet_Payroll ON dbo.timesheets
GO

-- Create the index
CREATE NONCLUSTERED INDEX IX_Time_Sheet_Payroll 
ON dbo.timesheets (employee_id)  
INCLUDE (employee_firstname, employee_lastname, timesheet_hourlyrate, timesheet_hours);  
GO

-- Select statement to use the created index
SELECT	employee_id,
		employee_firstname, 
		employee_lastname, 
		sum(timesheet_hourlyrate*timesheet_hours) as total_pay
FROM dbo.timesheets
GROUP BY employee_id, employee_firstname, employee_lastname;







--Q2 to leverage index seek

SELECT	employee_id,
		employee_firstname,
		employee_lastname,
		sum(timesheet_hourlyrate*timesheet_hours) AS total_pay
FROM  dbo.timesheets
WHERE employee_id = 1
GROUP BY employee_id, employee_firstname, employee_lastname;















-- Q3
CREATE NONCLUSTERED COLUMNSTORE INDEX IX_Dept_JobTitle
	ON dbo.timesheets (employee_department,employee_jobtitle, timesheet_hours, timesheet_hourlyrate)
	WITH ( DROP_EXISTING = ON)

SELECT	employee_department,
		SUM(timesheet_hours) AS total_hours
FROM	timesheets
GROUP BY employee_department

SELECT	employee_jobtitle,
		AVG(timesheet_hourlyrate) AS avg_hourly_rate
FROM	dbo.timesheets
GROUP BY employee_jobtitle

--Q4 indexed view
DROP VIEW IF EXISTS dbo.v_employees
GO

CREATE VIEW dbo.v_employees
WITH SCHEMABINDING
AS
	SELECT  COUNT_BIG(*) as record_count,
			employee_id,
			employee_firstname,
			employee_lastname,
			employee_jobtitle,
			employee_department
	FROM dbo.timesheets
	GROUP BY employee_id,
			employee_firstname,
			employee_lastname,
			employee_jobtitle,
			employee_department
GO

CREATE UNIQUE CLUSTERED INDEX IX_v_employees
	ON v_employees (
		employee_id
	)
GO


-- Query to use view index to use index seek
SELECT * from dbo.v_employees 
	WHERE employee_id =  2 





---- Q5

SELECT  employee_id, 
		employee_firstname, 
		employee_lastname, 
		COUNT(*) as total_timesheets, 
		SUM(timesheet_hours) as total_hours_worked, 
		AVG(timesheet_hourlyrate) avg_timesheet_hourly_rate
FROM dbo.timesheets
GROUP BY employee_id, employee_firstname, employee_lastname
FOR JSON AUTO