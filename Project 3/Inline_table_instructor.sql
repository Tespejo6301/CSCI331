--======================================================================
-- Author: Trisha Espejo
-- Create Date: 11/29/2020
-- Description: inline table value for [G10_3].[Load_Instructor]
--======================================================================
 Create SCHEMA G10_3
GO

 CREATE OR ALTER FUNCTION G10_3.LoadInstructor
(
    @GroupMemberUserAuthorityKey INT,
    @CurrentTime DATETIME2
)
RETURNS TABLE
AS
RETURN
Select Distinct Department.ID
    , Firstname = SUBSTRING(orig.Instructor, CHARINDEX(', ', orig.Instructor) + 1, LEN(orig.Instructor))
    , Lastname = SUBSTRING(orig.Instructor, 0, CHARINDEX(', ', orig.Instructor))
    , FullName = CONCAT(SUBSTRING(orig.Instructor, CHARINDEX(', ', orig.Instructor) + 1, LEN(orig.Instructor)), 
         ' ', SUBSTRING(Instructor, 0, CHARINDEX(', ', orig.Instructor)))
    ,DateAdded = @CurrentTime
	,DateOfLastUpdate = @CurrentTime
    ,AuthorizationKey = @GroupMemberUserAuthorityKey      
    FROM groupnUploadfile.CurrentSemesterCourseOfferings As orig
    INNER JOIN School.Department AS Department
        ON  SUBSTRING(orig.[Course (hr, crd)], 0,  CHARINDEX(' ', orig.[Course (hr, crd)])) = Department.Name 
    WHERE orig.Instructor != ','
 GO   


SELECT * FROM G10_3.LoadInstructor(2, SYSDATETIME());