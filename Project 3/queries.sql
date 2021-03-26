--======================================================================
-- Author: Trisha Espejo
-- Create Date: 12/2/2020
-- Description: Find all the employee's who belongs to more than 1 Department
--======================================================================
SELECT FirstName,LastName, FullName, Count(FullName) AS NumofDeparment
FROM Semester.Instructor
GROUP BY FirstName, LastName, FullName
HAVING  Count(FullName) > 1;
--======================================================================
-- Author: Trisha Espejo
-- Create Date: 12/2/2020
-- Description: Find number of the employees in each department
--======================================================================

SELECT Distinct Department.ID, Department.Name, Count(Department.ID) AS numEmployeesinDept
FROM Semester.Instructor AS Instructor
    INNER JOIN School.Department AS Department
        ON Instructor.DepartmentID = Department.ID
     GROUP BY  Department.ID, Department.Name
