--======================================================================
-- Author: Trisha Espejo
-- Create Date: 11/29/2020
-- Description: add three columns to School.Department
--======================================================================
alter  table [School].[Department]
add UserAuthorizationKey INT NOT NULL,
 DateAdded         datetime2   null default sysdatetime(),
 DateOfLastUpdate datetime2   null default sysdatetime()
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--======================================================================
-- Author: Trisha Espejo
-- Create Date: 11/29/2020
-- Description: load [Project].[Load_Department]
--======================================================================



ALTER PROCEDURE [Project].[Load_Department]
	@GroupMemberUserAuthorityKey INT
AS
BEGIN	

	SET NOCOUNT ON;
	DECLARE @CurrentDateTime datetime2 = SYSDATETIME()
    ,@EndingDateTime datetime2
    ,@RowCount AS INT;

	INSERT INTO [School].[Department]
	( Name, UserAuthorizationKey, DateAdded, DateOfLastUpdate)
	
    SELECT DISTINCT Department = SUBSTRING([Course (hr, crd)], 0,  CHARINDEX(' ', [Course (hr, crd)]))
	, @GroupMemberUserAuthorityKey
	, @CurrentDateTime
    ,@CurrentDateTime
	FROM groupnUploadfile.CurrentSemesterCourseOfferings
    WHERE [Course (hr, crd)]!= ' ';
    SET @RowCount = ( 
            SELECT Count(*) 
            FROM [School].[Department]
        ) 
	Set @EndingDateTime = SYSDATETIME();

    EXEC Project.TrackWorkFlow
	
	 @UserAuthorizationKey = @GroupMemberUserAuthorityKey
     , @StartingDateTime = @CurrentDateTime
	 ,@EndingDateTime = @EndingDateTime
	, @WorkFlowStepDescription = 'Load Department'
	, @WorkFlowStepTableRowCount = @RowCount
	
END;

SELECT * FROM School.department;
SELECT * FROM Semester.Instructor
