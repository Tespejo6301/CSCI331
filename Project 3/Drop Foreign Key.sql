ALTER TABLE school.room
DROP FK_Room_BuildingID  


ALTER TABLE [Semester].[Course] 
DROP FK_Course_DepartmentID

ALTER TABLE Semester.Instructor
DROP FK_Instructor_DepartmentID

ALTER TABLE Project.DepartmentInstructor
DROP FK_DepartmentInstructor_DepartmentID


ALTER TABLE  Project.DepartmentInstructor
DROP FK_DepartmentInstructor_InstructorID 

ALTER TABLE Semester.Class
DROP FK_Class_InstructorID

ALTER TABLE Semester.Class
DROP FK_Class_DepartmentID

ALTER TABLE Semester.Class
DROP FK_Class_RoomID 

ALTER TABLE Semester.Class
DROP FK_Class_CourseID

ALTER TABLE Semester.Class
DROP FK_Class_BuildingID

ALTER TABLE Semester.Class
DROP FK_Class_ModeID