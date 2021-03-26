ALTER TABLE Semester.Instruction
ADD CONSTRAINT UC_INSTRUCTION UNIQUE (Method);

ALTER TABLE Semester.Instructor
ADD CONSTRAINT UC_Instructor UNIQUE (DepartmentID, Fullname);

ALTER TABLE [Semester].[Instructor]  WITH CHECK ADD CONSTRAINT [FK_Semester_Instructor] FOREIGN KEY([DepartmentID])
REFERENCES [School].[Department] ([ID])
GO