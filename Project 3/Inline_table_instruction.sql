--======================================================================
-- Author: Trisha Espejo
-- Create Date: 11/29/2020
-- Description: inline table value for [G10_3].[Load_Instruction]
--======================================================================
Create SCHEMA G10_3
GO


Create or ALTER FUNCTION G10_3.LoadInstruction
(
    @GroupMemberUserAuthorityKey INT,
    @CurrentTime DATETIME2(7)
)
RETURNS TABLE
AS
RETURN
    
    SELECT DISTINCT [Mode of Instruction]
	 ,DateAdded = @CurrentTime 
     ,DateOfLastUpdate = @CurrentTime
     ,AuthorizationKey = @GroupMemberUserAuthorityKey 
	FROM groupnUploadfile.CurrentSemesterCourseOfferings
    WHERE [Mode of Instruction] != ' ';
    
GO



SELECT* FROM G10_3.LoadInstruction(2, SYSDATETIME())



