use fudgemart_v3

SELECT product_id,
       product_name,
       CASE
           WHEN CHARINDEX(' ', product_name) < 1 THEN product_name
           ELSE RIGHT(product_name, CHARINDEX(' ', REVERSE(product_name))-1)
       END AS product_category
FROM fudgemart_products;
go

/*
2. Write a user defined function called f_total_vendor_sales which calculates the sum of the wholesale price * quantity of all products sold for that vendor. 
There should be one number associated with each vendor id, which is the input into the function.  
Demonstrate the function works by executing an SQL select statement over all vendors calling the function.
*/

DROP FUNCTION IF EXISTS dbo.f_total_vendor_sales;
go

CREATE OR ALTER FUNCTION dbo.f_total_vendor_sales ( @vendor_id AS INT )
RETURNS money
AS
BEGIN
	RETURN
	(
		SELECT     Sum(PRD.product_wholesale_price * ORDD.order_qty)
		FROM       fudgemart_products PRD
		INNER JOIN fudgemart_order_details ORDD
		ON         PRD.product_id = ORDD.product_id
		WHERE      PRD.product_vendor_id = @vendor_id 
	);
END
go

SELECT vendor_name,
       dbo.F_total_vendor_sales(vendor_id) AS TotalSales
FROM   dbo.fudgemart_vendors
ORDER  BY vendor_name; 
GO

/*3*/

DROP PROCEDURE IF EXISTS dbo.p_write_vendor;
go

CREATE OR ALTER PROCEDURE dbo.p_write_vendor
    @vendor_name nvarchar(50),
    @vendor_phone varchar(15),
    @vendor_website varchar(256)
AS

IF EXISTS ( SELECT * FROM fudgemart_vendors WHERE vendor_name = @vendor_name)
	UPDATE dbo.fudgemart_vendors
	SET vendor_phone = @vendor_phone, vendor_website = @vendor_website
	WHERE vendor_name = @vendor_name;
ELSE
	INSERT INTO dbo.fudgemart_vendors ( vendor_name, vendor_phone, vendor_website)
	VALUES ( @vendor_name, @vendor_phone, @vendor_website);

go

EXEC dbo.p_write_vendor 'test vendor', '000-000-000', 'http://test-website.com';
go

SELECT * FROM fudgemart_vendors WHERE vendor_name = 'test vendor'
go


EXEC dbo.p_write_vendor 'test vendor', '111-111-111', 'http://test-website.com';
go

SELECT * FROM fudgemart_vendors WHERE vendor_name = 'test vendor'
go

/*4.	Create a view based on the logic you completed in question 1 or 2. 
Your SQL script should be programmed so that the entire script works every time, 
dropping the view if it exists, and then re-creating it*/

DROP VIEW IF EXISTS dbo.vw_total_vendor_sales;
go

CREATE OR ALTER VIEW dbo.vw_total_vendor_sales AS
SELECT	PRD.product_id, PRD.product_vendor_id,  PRD.product_wholesale_price * ORDD.order_qty as sales_value
FROM	fudgemart_products PRD
INNER JOIN fudgemart_order_details ORDD
ON	PRD.product_id = ORDD.product_id
go

SELECT * from dbo.vw_total_vendor_sales
go


/*table valued function
5.	Write a table valued function f_employee_timesheets which when provided an employee_id will output the employee id, name, department, payroll date,
hourly rate on the timesheet, hours worked, and gross pay (hourly rate times hours worked).*/

DROP FUNCTION IF EXISTS dbo.f_employee_timesheets;
go

CREATE OR ALTER FUNCTION dbo.f_employee_timesheets ( @employee_id AS INT )
RETURNS TABLE
AS
	RETURN
	(
		SELECT	EMP.employee_id, EMP.employee_lastname, EMP.employee_firstname, EMP.employee_department,
				ETS.timesheet_payrolldate, ETS.timesheet_hourlyrate, ETS.timesheet_hours* ETS.timesheet_hourlyrate as GrossPay
		FROM	fudgemart_employee_timesheets AS ETS
		INNER JOIN fudgemart_employees AS EMP
		ON		EMP.employee_id = ETS.timesheet_employee_id
		WHERE	EMP.employee_id = @employee_id
	);
go

SELECT * FROM dbo.f_employee_timesheets(1);
go
