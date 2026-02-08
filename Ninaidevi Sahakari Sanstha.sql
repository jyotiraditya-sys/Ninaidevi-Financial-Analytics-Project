create database sahakari_sanstha;
use sahakari_sanstha;
CREATE TABLE ninaidevi_master_financials (
    Year VARCHAR(50),
    Capacity_Utilization_Pct FLOAT,
    Annual_Paddy_Processing_Tons FLOAT,
    Sales_Revenue_Rice_Lacs FLOAT,
    Sales_Revenue_Byproducts_Lacs FLOAT,
    Total_Sales_Revenue_Lacs FLOAT,
    Raw_Material_Cost_Lacs FLOAT,
    Consumables_Cost_Lacs FLOAT,
    Direct_Labour_Wages_Lacs FLOAT,
    Power_Fuel_Utilities_Lacs FLOAT,
    Repairs_Maintenance_Lacs FLOAT,
    Admin_Selling_Overheads_Lacs FLOAT,
    Interest_on_Term_Loan_Lacs FLOAT,
    Depreciation_WDV_Lacs FLOAT,
    Profit_Before_Tax_Lacs FLOAT,
    Income_Tax_Lacs FLOAT,
    Profit_After_Tax_Lacs FLOAT,
    Debt_Service_Coverage_Ratio FLOAT,
    sum FLOAT
);

CREATE TABLE ninaidevi_detailed_staffing (
    Designation VARCHAR(255),
    Department VARCHAR(100),
    Number_of_Posts INT,
    Annual_Salary_Per_Head_Rs FLOAT,
    Total_Annual_Cost_Lacs FLOAT
);

CREATE TABLE ninaidevi_repayment_schedule (
    Operating_Year VARCHAR(50),
    Loan_Opening_Balance_Lacs FLOAT,
    Loan_Principal_Repayment_Lacs FLOAT,
    Loan_Interest_Payment_Lacs FLOAT,
    Govt_Capital_Opening_Lacs FLOAT,
    Govt_Capital_Repayment_Lacs FLOAT
);

-- Q1. Retrieve all information from the Master Financials table.
SELECT * FROM ninaidevi_master_financials;

-- Q2. List all staff designations and their respective departments.
SELECT Designation, Department 
FROM ninaidevi_detailed_staffing;

-- Q3. Find all years in Master Financials where the Capacity Utilization is greater than 75%.
SELECT Year, Capacity_Utilization_Pct 
FROM ninaidevi_master_financials 
WHERE Capacity_Utilization_Pct > 75;

-- Q4 Sort the staffing list by Total_Annual_Cost_Lacs in descending order
SELECT * FROM ninaidevi_detailed_staffing 
ORDER BY Total_Annual_Cost_Lacs DESC;

-- Q5. Find unique department names present in the staffing table.
SELECT DISTINCT Department 
FROM ninaidevi_detailed_staffing;

-- Q6. Calculate the total number of staff members across all departments.
SELECT SUM(Number_of_Posts) AS Total_Staff_Count 
FROM ninaidevi_detailed_staffing;

-- Q7. Find the average
SELECT AVG(Profit_After_Tax_Lacs) AS Average_Profit 
FROM ninaidevi_master_financials;

-- Q8. Group the staffing data by Department and show the total cost for each.
SELECT Department, SUM(Total_Annual_Cost_Lacs) AS Dept_Total_Cost
FROM ninaidevi_detailed_staffing
GROUP BY Department;

-- Q9. Identify departments that have more than 5 total posts.
SELECT Department, SUM(Number_of_Posts) AS Total_Posts
FROM ninaidevi_detailed_staffing
GROUP BY Department
HAVING SUM(Number_of_Posts) > 5;

-- Q10. Combine Master Financials and Repayment Schedule to see Profit vs. Interest Paid per year.
SELECT f.Year, f.Profit_After_Tax_Lacs, r.Loan_Interest_Payment_Lacs
FROM ninaidevi_master_financials f
JOIN ninaidevi_repayment_schedule r ON f.Year = r.Operating_Year;

-- Q11. Find the year with the highest profit using a subquery.
SELECT Year, Profit_After_Tax_Lacs
FROM ninaidevi_master_financials
WHERE Profit_After_Tax_Lacs = (SELECT MAX(Profit_After_Tax_Lacs) FROM ninaidevi_master_financials);

-- Q12. Categorize the years based on Profitability (High/Medium/Low).
SELECT Year, Profit_After_Tax_Lacs,
CASE 
    WHEN Profit_After_Tax_Lacs > 50 THEN 'High Profit'
    WHEN Profit_After_Tax_Lacs BETWEEN 30 AND 50 THEN 'Medium Profit'
    ELSE 'Low Profit'
END AS Profit_Category
FROM ninaidevi_master_financials;

-- Q13. Create a running total of the Loan Principal Repayment over the years.
SELECT Operating_Year, Loan_Principal_Repayment_Lacs,
SUM(Loan_Principal_Repayment_Lacs) OVER (ORDER BY Operating_Year) AS Cumulative_Repayment
FROM ninaidevi_repayment_schedule;

-- Q14. Find the staff designations that earn more than the average salary of all staff.
SELECT Designation, Annual_Salary_Per_Head_Rs
FROM ninaidevi_detailed_staffing
WHERE Annual_Salary_Per_Head_Rs > (SELECT AVG(Annual_Salary_Per_Head_Rs) FROM ninaidevi_detailed_staffing);

-- Q15. Rank the years based on Sales Revenue without skipping ranks.
SELECT Year, Total_Sales_Revenue_Lacs,
DENSE_RANK() OVER (ORDER BY Total_Sales_Revenue_Lacs DESC) AS Sales_Rank
FROM ninaidevi_master_financials;
