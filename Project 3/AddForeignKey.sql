
SET ANSI_NULLS ON 
GO 
  
SET QUOTED_IDENTIFIER ON 
GO 
  
ALTER PROCEDURE [Project].[AddForeignKeys] 
@GroupMemberUserAuthorityKey INT 
AS 
BEGIN 
    DECLARE @CurrentDateTime AS DATETIME2(7) = SYSDATETIME(),
	@EndingDateTime as datetime2;    
    SET NOCOUNT ON ;
    ALTER TABLE [School].[Room]  WITH CHECK ADD CONSTRAINT FK_Room_BuildingID FOREIGN KEY (BuildingID)
    REFERENCES School.Building(ID)

    ALTER TABLE [Semester].[Course]  WITH CHECK ADD CONSTRAINT FK_Course_DepartmentID FOREIGN KEY (DepartmentID)
    REFERENCES School.Department(ID)


    ALTER TABLE Semester.Instructor  WITH CHECK ADD CONSTRAINT FK_Instructor_DepartmentID  FOREIGN KEY (DepartmentID)
    REFERENCES School.Department(ID)


    ALTER TABLE Project.DepartmentInstructor  WITH CHECK ADD CONSTRAINT FK_DepartmentInstructor_DepartmentID FOREIGN KEY (DepartmentID)
    REFERENCES School.Department(ID) 


    ALTER TABLE Project.DepartmentInstructor  WITH CHECK ADD CONSTRAINT FK_DepartmentInstructor_InstructorID FOREIGN KEY (InstructorID) 
    REFERENCES Semester.Instructor(ID)



    ALTER TABLE Semester.Class  WITH CHECK ADD CONSTRAINT FK_Class_InstructorID FOREIGN KEY (InstructorID) 
    REFERENCES Semester.Instructor(ID)


    ALTER TABLE Semester.Class  WITH CHECK ADD CONSTRAINT FK_Class_DepartmentID FOREIGN KEY (DepartmentID) 
    REFERENCES School.Department(ID)



    ALTER TABLE Semester.Class  WITH CHECK ADD CONSTRAINT FK_Class_RoomID FOREIGN KEY (RoomID) 
    REFERENCES School.Room(ID)


    ALTER TABLE Semester.Class  WITH CHECK ADD CONSTRAINT FK_Class_CourseID FOREIGN KEY (CourseID) 
    REFERENCES Semester.Course(ID)


    ALTER TABLE Semester.Class WITH CHECK ADD CONSTRAINT FK_Class_BuildingID FOREIGN KEY (BuildingID) 
    REFERENCES School.Building(ID)


    ALTER TABLE Semester.Class WITH CHECK ADD CONSTRAINT FK_Class_ModeID FOREIGN KEY (ModeID) 
    REFERENCES Semester.Instruction(ID)


    Set @EndingDateTime = SYSDATETIME();

    EXEC Project.TrackWorkFlow
         @UserAuthorizationKey = @GroupMemberUserAuthorityKey
        , @StartingDateTime = @CurrentDateTime
        ,@EndingDateTime = @EndingDateTime
        , @WorkFlowStepDescription = 'Add Foreign Key'
        , @WorkFlowStepTableRowCount = @@RowCount
End;
