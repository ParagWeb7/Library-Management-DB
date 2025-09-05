CREATE DATABASE LibraryDB;
GO
USE LibraryDB;
GO

CREATE TABLE Book_Authors (
    AuthorID INT IDENTITY PRIMARY KEY,
    Name NVARCHAR(50) NOT NULL
    
);

INSERT INTO Book_Authors (Name) VALUES
('J.K. Rowling'),
('George Orwell'),
('Agatha Christie'),
('Chetan Bhagat'),
('Paulo Coelho');

CREATE TABLE Books (
    BookID INT IDENTITY PRIMARY KEY,
    Title NVARCHAR(50) NOT NULL,
    AuthorID INT NOT NULL,
	PublishedYear INT,
    CONSTRAINT FK_Books_Authors FOREIGN KEY (AuthorID) REFERENCES Book_Authors(AuthorID)
);

INSERT INTO Books (Title, AuthorID,  PublishedYear) VALUES
('Harry Potter and the Philosopher''s Stone', 1,  1997),
('1984', 2,  1949),
('Murder on the Orient Express', 3,  1934),
('Five Point Someone', 4,  2004),
('The Alchemist', 5,  1988);

CREATE TABLE BookCopies (
    CopyID INT IDENTITY PRIMARY KEY,
    BookID INT NOT NULL,
    Status NVARCHAR(50) DEFAULT 'Available',
    CONSTRAINT FK_BookCopies_Books FOREIGN KEY (BookID) REFERENCES Books(BookID) 
);

INSERT INTO BookCopies (BookID, Status) VALUES
(1, 'Available'),
(2, 'Available'),
(3, 'Available'),
(4, 'Available'),
(5, 'Available');



CREATE TABLE Members (
    MemberID INT IDENTITY PRIMARY KEY,
    FullName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) UNIQUE,
	Phone NVARCHAR(15),
    Address NVARCHAR(70)
);

INSERT INTO Members (FullName, Email, Phone, Address) VALUES
('Rahul Sharma', 'rahul.sharma@example.com', '9876543210', 'Pune, Maharashtra'),
('Sneha Patel', 'sneha.patel@example.com', '9876501234', 'Ahmedabad, Gujarat'),
('Amit Desai', 'amit.desai@example.com', '9123456780', 'Mumbai, Maharashtra'),
('Priya Nair', 'priya.nair@example.com', '9988776655', 'Kochi, Kerala'),
('Rohan Kulkarni', 'rohan.kulkarni@example.com', '9898989898', 'Nagpur, Maharashtra');



CREATE TABLE Staff (
    StaffID INT IDENTITY PRIMARY KEY,
    FullName NVARCHAR(100) NOT NULL,
    Role NVARCHAR(50)
);

INSERT INTO Staff (FullName, Role) VALUES
('Priya Mehta', 'Librarian'),
('Rohan Joshi', 'Assistant'),
('Meena Shah', 'Librarian'),
('Aakash Verma', 'Assistant'),
('Neha Desai', 'Admin');


CREATE TABLE BorrowTransactions (
    TransactionID INT IDENTITY PRIMARY KEY,
    MemberID INT NOT NULL,
    CopyID INT NOT NULL,
    StaffID INT NOT NULL,
    IssueDate DATE DEFAULT GETDATE(),
    DueDate DATE,
    ReturnDate DATE NULL,
    CONSTRAINT FK_Borrow_Members FOREIGN KEY (MemberID) REFERENCES Members(MemberID),
    CONSTRAINT FK_Borrow_Copies FOREIGN KEY (CopyID) REFERENCES BookCopies(CopyID),
    CONSTRAINT FK_Borrow_Staff FOREIGN KEY (StaffID) REFERENCES Staff(StaffID)
);

INSERT INTO BorrowTransactions (MemberID, CopyID, StaffID, DueDate) VALUES
(1, 1, 1, DATEADD(DAY, 14, GETDATE())),
(2, 2, 2, DATEADD(DAY, 10, GETDATE())),
(3, 3, 3, DATEADD(DAY, 7, GETDATE())),
(4, 4, 4, DATEADD(DAY, 15, GETDATE())),
(5, 5, 5, DATEADD(DAY, 12, GETDATE()));


select * from BorrowTransactions

SELECT 
    bc.CopyID,
    b.Title,
    a.Name AS Author,
    bc.Status
FROM BookCopies bc
JOIN Books b ON bc.BookID = b.BookID
JOIN Book_Authors a ON b.AuthorID = a.AuthorID
WHERE bc.Status = 'Available';
 

UPDATE BorrowTransactions
SET ReturnDate = GETDATE()
WHERE TransactionID = 1;  -- change TransactionID as per your record

UPDATE BorrowTransactions
SET ReturnDate = GETDATE()
WHERE TransactionID = 2; 

UPDATE BookCopies
SET Status = 'Available'
WHERE CopyID = 1; -- copy returned by member


INSERT INTO BorrowTransactions (MemberID, CopyID, StaffID, DueDate)
VALUES (3, 4, 2, DATEADD(DAY, 14, GETDATE())); -- sets due date 14 days from now

UPDATE BookCopies
SET Status = 'Issued'
WHERE CopyID = 4;

SELECT 
    bt.TransactionID,
    m.FullName,
    b.Title,
    bt.DueDate
FROM BorrowTransactions bt
JOIN Members m ON bt.MemberID = m.MemberID
JOIN BookCopies bc ON bt.CopyID = bc.CopyID
JOIN Books b ON bc.BookID = b.BookID
WHERE bt.ReturnDate IS NULL;

