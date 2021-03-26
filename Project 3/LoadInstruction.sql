--======================================================================
-- Author: Trisha Espejo
-- Create Date: 11/29/2020
-- Description: add three columns to Semester.Instruction
--======================================================================
alter  table [Semester].[Instruction]
 add UserAuthorizationKey INT NOT NULL,
 DateAdded         datetime2   null default sysdatetime(),
 DateOfLastUpdate datetime2   null default sysdatetime()
 

--======================================================================
-- Author: Trisha Espejo
-- Create Date: 11/29/2020
-- Description: load [Project].[Load_Instruction]
--======================================================================

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Alter PROCEDURE [Project].[Load_Instruction]
	@GroupMemberUserAuthorityKey INT
AS
BEGIN	

	SET NOCOUNT ON;
	DECLARE @CurrentDateTime datetime2 = SYSDATETIME()
    ,@EndingDateTime datetime2
    ,@RowCount AS INT;

	INSERT INTO [Semester].[Instruction]
	(Method, UserAuthorizationKey, DateAdded, DateOfLastUpdate)
	
    SELECT DISTINCT [Mode of Instruction]
	, @GroupMemberUserAuthorityKey
	, @CurrentDateTime
    ,@CurrentDateTime
	FROM groupnUploadfile.CurrentSemesterCourseOfferings
    WHERE [Mode of Instruction] != ' ';
    SET @RowCount = 
        ( 
            SELECT Count(*) 
            FROM [Semester].[Instruction]
        ) 
	Set @EndingDateTime = SYSDATETIME();

    EXEC Project.TrackWorkFlow
	
	 @UserAuthorizationKey = @GroupMemberUserAuthorityKey
     , @StartingDateTime = @CurrentDateTime
	 ,@EndingDateTime = @EndingDateTime
	, @WorkFlowStepDescription = 'Load Instruction'
	, @WorkFlowStepTableRowCount = @RowCount
	
END;



SELECT * FROM Semester.Instruction

