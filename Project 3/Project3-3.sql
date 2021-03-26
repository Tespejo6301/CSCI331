Use test;
GO

-- Auth
Create Schema DbSecurity;
Go

-- Use for Workflow and small procedures
Create Schema Project;
Go

-- Use for dept, buildings and room
Create Schema School;
GO

-- Use for classes, teachers,courses
Create Schema Semester;
Go

-- Use for sequence objects
Create Schema PKSequence;
GO


-- ============================================= 
--Author: Trisha Espejo 
--Procedure restart the sequence
--Create Date: 11/19/2020 
-- ============================================= 
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE
	OR

ALTER PROCEDURE Project.RestartSequence @GroupMemberUserAuthorityKey INT
AS
BEGIN

	DROP sequence IF Exists PkSequence.WorkflowStepsSequenceObject

	DROP sequence IF Exists PkSequence.UserAuthorizationSequenceObject

	DROP sequence IF Exists PkSequence.BuildingIDSequenceObject

	DROP sequence IF Exists PkSequence.DepartmentIDSequenceObject

	DROP sequence IF Exists PkSequence.RoomIDSequenceObject

	DROP sequence IF Exists PkSequence.CourseIDSequenceObject

	DROP sequence IF Exists PkSequence.InstructionModeIDSequenceObject

	DROP sequence IF Exists PkSequence.InstructorIDSequenceObject

	DROP sequence IF Exists PkSequence.ClassIDSequenceObject

	CREATE sequence PkSequence.WorkflowStepsSequenceObject AS INT minvalue 1;

	CREATE sequence PkSequence.UserAuthorizationSequenceObject AS INT minvalue 1;

	CREATE sequence PkSequence.BuildingIDSequenceObject AS INT minvalue 1;

	CREATE sequence PkSequence.DepartmentIDSequenceObject AS INT minvalue 1;

	CREATE sequence PkSequence.RoomIDSequenceObject AS INT minvalue 1;

	CREATE sequence PkSequence.CourseIDSequenceObject AS INT minvalue 1;

	CREATE sequence PkSequence.InstructionModeIDSequenceObject AS INT minvalue 1;

	CREATE sequence PkSequence.InstructorIDSequenceObject AS INT minvalue 1;

	CREATE sequence PkSequence.ClassIDSequenceObject AS INT minvalue 1;
END;

--=============================================
--Author: Trisha Espejo
--Procedure: Project.LoadModesOfInstruction
--Create Date: 12/04/2020
--Description: Will load ModesOfInstruction DB from data uploaded
--=============================================
GO

CREATE
	OR

ALTER PROCEDURE Project.LoadModesOfInstruction @UserAuthorizationKey INT
AS
BEGIN
	DECLARE @StartingDateTime AS DATETIME2(7) = SYSDATETIME()
		, @EndingDateTime AS DATETIME2(7)
		, @Rowcount AS INT

	SET NOCOUNT ON

	INSERT INTO Semester.Instruction (
		[Method]
		, UserAuthorizationKey
		, DateAdded
		, DateOfLastUpdate
		)
	SELECT DISTINCT [Mode of Instruction]
		, @UserAuthorizationKey
		, @StartingDateTime
		, @StartingDateTime
	FROM groupnUploadfile.CurrentSemesterCourseOfferings

	SET @Rowcount = (
			SELECT Count(*)
			FROM Semester.Instruction
			)
	SET @EndingDateTime = SYSDATETIME();

	EXEC Project.TrackWorkFlow @UserAuthorizationKey = @UserAuthorizationKey
		, @WorkFlowStepDescription = 'Setting up the Mode table using LoadModesOfInstruction'
		, @WorkFlowStepTableRowCount = @Rowcount
		, @StartingDateTime = @StartingDateTime
		, @EndingDateTime = @EndingDateTime
END;
--======================================================================
-- Author: Trisha Espejo
-- Create Date: 11/14/2020
-- Description: load [Project].[LoadDepartment]
--======================================================================
GO

CREATE
	OR

ALTER PROCEDURE [Project].[LoadDepartment] @GroupMemberUserAuthorityKey INT
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @CurrentDateTime DATETIME2 = SYSDATETIME()
		, @EndingDateTime DATETIME2
		, @RowCount AS INT;

	INSERT INTO [School].[Department] (
		Name
		, UserAuthorizationKey
		, DateAdded
		, DateOfLastUpdate
		)
	SELECT DISTINCT Department = SUBSTRING([Course (hr, crd)], 0, CHARINDEX(' ', [Course (hr, crd)]))
		, @GroupMemberUserAuthorityKey
		, @CurrentDateTime
		, @CurrentDateTime
	FROM groupnUploadfile.CurrentSemesterCourseOfferings
	WHERE [Course (hr, crd)] != ' ';

	SET @RowCount = (
			SELECT Count(*)
			FROM [School].[Department]
			)
	SET @EndingDateTime = SYSDATETIME();

	EXEC Project.TrackWorkFlow @UserAuthorizationKey = @GroupMemberUserAuthorityKey
		, @WorkFlowStepDescription = 'Setting up the Department table using LoadDepartment'
		, @WorkFlowStepTableRowCount = @RowCount
		, @StartingDateTime = @CurrentDateTime
		, @EndingDateTime = @EndingDateTime
END;

--======================================================================
-- Author: Trisha Espejo
-- Create Date: 11/14/2020
-- Description: load [Project].[LoadInstructor]
--======================================================================
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE
	OR

ALTER PROCEDURE [Project].[LoadInstructor] @GroupMemberUserAuthorityKey INT
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @CurrentDateTime DATETIME2 = SYSDATETIME()
		, @EndingDateTime DATETIME2
		, @RowCount AS INT;

	INSERT INTO [Semester].[Instructor] (
		DepartmentID
		, FirstName
		, LastName
		, FullName
		, UserAuthorizationKey
		, DateAdded
		, DateOfLastUpdate
		)
	SELECT DISTINCT Department.ID
		, Firstname = SUBSTRING(orig.Instructor, CHARINDEX(' ', orig.Instructor) + 1, LEN(orig.Instructor))
		, Lastname = SUBSTRING(orig.Instructor, 0, CHARINDEX(', ', orig.Instructor))
		, FullName = CONCAT (
			SUBSTRING(orig.Instructor, CHARINDEX(' ', orig.Instructor) + 1, LEN(orig.Instructor))
			, ' '
			, SUBSTRING(Instructor, 0, CHARINDEX(', ', orig.Instructor))
			)
		, @GroupMemberUserAuthorityKey
		, @CurrentDateTime
		, @CurrentDateTime
	FROM groupnUploadfile.CurrentSemesterCourseOfferings AS orig
	INNER JOIN School.Department AS Department ON SUBSTRING(orig.[Course (hr, crd)], 0, CHARINDEX(' ', orig.[Course (hr, crd)])) = Department.Name
	WHERE orig.Instructor != ',';

	SET @RowCount = (
			SELECT Count(*)
			FROM [Semester].[Instructor]
			)
	SET @EndingDateTime = SYSDATETIME();

	EXEC Project.TrackWorkFlow @UserAuthorizationKey = @GroupMemberUserAuthorityKey
		, @WorkFlowStepDescription = 'Loading Instructor table using LoadInstructor'
		, @WorkFlowStepTableRowCount = @RowCount
		, @StartingDateTime = @CurrentDateTime
		, @EndingDateTime = @EndingDateTime
END;
