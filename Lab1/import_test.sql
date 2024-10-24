-- Creation of a test base...

CCREATE DATABASE ElectricBank;
USE ElectricBank;

CREATE TABLE Borrowers (
    borrowerId INT PRIMARY KEY AUTO_INCREMENT,
    inn VARCHAR(20),
    isCompany BOOLEAN,
    address TEXT,
    amount DECIMAL(15,2),
    terms TEXT,
    legalNotes TEXT,
    contractList TEXT
);

CREATE TABLE Individuals (
    id INT PRIMARY KEY AUTO_INCREMENT,
    borrowerId INT,
    firstName VARCHAR(50),
    lastName VARCHAR(50),
    middleName VARCHAR(50),
    passport VARCHAR(20),
    inn VARCHAR(20),
    snils VARCHAR(20),
    driversLicense VARCHAR(20),
    additionalDocuments TEXT,
    notes TEXT,
    FOREIGN KEY (borrowerId) REFERENCES Borrowers(borrowerId)
);

CREATE TABLE Loans (
    id INT PRIMARY KEY AUTO_INCREMENT,
    borrowerId INT,
    individualId INT,
    amount DECIMAL(15,2),
    interestRate DECIMAL(5,2),
    duration INT,
    terms TEXT,
    notes TEXT,
    FOREIGN KEY (individualId) REFERENCES Individuals(id),
    FOREIGN KEY (borrowerId) REFERENCES Borrowers(borrowerId)
);

CREATE TABLE CompanyLoans (
    id INT PRIMARY KEY AUTO_INCREMENT,
    borrowerId INT,
    companyId INT,
    individualId INT,
    amount DECIMAL(15,2),
    duration INT,
    interestRate DECIMAL(5,2),
    terms TEXT,
    notes TEXT,
    FOREIGN KEY (individualId) REFERENCES Individuals(id),
    FOREIGN KEY (borrowerId) REFERENCES Borrowers(borrowerId)
);