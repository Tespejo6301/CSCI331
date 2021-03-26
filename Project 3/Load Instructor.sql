--======================================================================
-- Author: Trisha Espejo
-- Create Date: 11/29/2020
-- Description: add three columns to [Semester].[Instructor]
--======================================================================
alter  table [Semester].[Instructor]
add UserAuthorizationKey INT NOT NULL,
 DateAdded         datetime2   null default sysdatetime(),
 DateOfLastUpdate datetime2   null default sysdatetime()


--======================================================================
-- Author: Trisha Espejo
-- Create Date: 11/29/2020
-- Description: load [Project].[Load_Instructor]
--======================================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [Project].[Load_Instructor]
	@GroupMemberUserAuthorityKey INT
AS
BEGIN	

	SET NOCOUNT ON;
	DECLARE @CurrentDateTime datetime2 = SYSDATETIME()
    ,@EndingDateTime datetime2
    ,@RowCount AS INT;
	INSERT INTO [Semester].[Instructor]
	(
      DepartmentID
      , FirstName
      , LastName
      , FullName
      , UserAuthorizationKey
      , DateAdded
      , DateOfLastUpdate
    )
	
    Select Distinct Department.ID
    , Firstname = SUBSTRING(orig.Instructor, CHARINDEX(', ', orig.Instructor) + 1, LEN(orig.Instructor))
    , Lastname = SUBSTRING(orig.Instructor, 0, CHARINDEX(', ', orig.Instructor))
    , FullName = CONCAT(SUBSTRING(orig.Instructor, CHARINDEX(', ', orig.Instructor) + 1, LEN(orig.Instructor)), 
         ' ', SUBSTRING(Instructor, 0, CHARINDEX(', ', orig.Instructor)))
    , @GroupMemberUserAuthorityKey
	, @CurrentDateTime
    , @CurrentDateTime     
    FROM groupnUploadfile.CurrentSemesterCourseOfferings As orig
    INNER JOIN School.Department AS Department
        ON  SUBSTRING(orig.[Course (hr, crd)], 0,  CHARINDEX(' ', orig.[Course (hr, crd)])) = Department.Name 
    WHERE orig.Instructor != ',';
    SET @RowCount = ( 
            SELECT Count(*) 
            FROM [Semester].[Instructor]
        ) 
	Set @EndingDateTime = SYSDATETIME();
    EXEC Project.TrackWorkFlow
	
	 @UserAuthorizationKey = @GroupMemberUserAuthorityKey
     , @StartingDateTime = @CurrentDateTime
	 , @EndingDateTime = @EndingDateTime
	 , @WorkFlowStepDescription = 'Load Instructor'
	 , @WorkFlowStepTableRowCount = @RowCount
	
END;


TRUNCATE Table School.Department
Alter Table Semes
EXEC [Project].[Load_Instruction] 2;
EXEC [Project].[Load_Department] 2;
Select*From Semester.Instructor

DROP