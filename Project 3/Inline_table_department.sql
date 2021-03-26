--======================================================================
-- Author: Trisha Espejo
-- Create Date: 11/29/2020
-- Description: inline table value for [G10_3].[Load_Department]
--======================================================================


Create or ALTER FUNCTION G10_3.LoadDepartment
(
    @GroupMemberUserAuthorityKey INT,
    @CurrentTime DATETIME2(7)
)
RETURNS TABLE
AS
RETURN
    
    SELECT DISTINCT Department = SUBSTRING([Course (hr, crd)], 0,  CHARINDEX(' ', [Course (hr, crd)]))
	 ,DateAdded = @CurrentTime 
     ,DateOfLastUpdate = @CurrentTime
     ,AuthorizationKey = @GroupMemberUserAuthorityKey 
	FROM groupnUploadfile.CurrentSemesterCourseOfferings
    WHERE [Course (hr, crd)]!= ' ';  
GO



SELECT* FROM G10_3.LoadDepartment(2, SYSDATETIME())



