create schema pharmacy_schema;
set search_path to pharmacy_schema;

CREATE TABLE Country (
    CountryID SERIAL PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Code VARCHAR(10) NOT NULL UNIQUE
);


CREATE TABLE DrugCategories (
    CategoryID SERIAL PRIMARY KEY,
    CategoryName VARCHAR(255) NOT NULL UNIQUE
);


CREATE TABLE Manufacturers (
    ManufacturerID SERIAL PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Address VARCHAR(255) NOT NULL,
    Contact VARCHAR(255) NOT NULL,
    CountryID INT NOT NULL,
    FOREIGN KEY (CountryID) REFERENCES Country(CountryID)
);


CREATE TABLE Positions (
    PositionID SERIAL PRIMARY KEY,
    Title VARCHAR(255) NOT NULL UNIQUE,
    Salary DECIMAL(10, 2) NOT NULL DEFAULT 0 CHECK (Salary >= 0)
);


CREATE TABLE Pharmacies (
    PharmacyID SERIAL PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Address VARCHAR(255) NOT NULL,
    CountryID INT NOT NULL,
    FOREIGN KEY (CountryID) REFERENCES Country(CountryID)
);


CREATE TABLE Clients (
    ClientID SERIAL PRIMARY KEY,
    FirstName VARCHAR(255) NOT NULL,
    LastName VARCHAR(255) NOT NULL,
    Phone VARCHAR(20) NOT NULL
);


CREATE TABLE Doctors (
    DoctorID SERIAL PRIMARY KEY,
    FirstName VARCHAR(255) NOT NULL,
    LastName VARCHAR(255) NOT NULL,
    Phone VARCHAR(20) NOT NULL,
    CountryID INT NOT NULL,
    Specialty VARCHAR(255) NOT NULL,
    FOREIGN KEY (CountryID) REFERENCES Country(CountryID)
);


CREATE TABLE Drugs (
    DrugID SERIAL PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Dose VARCHAR(50),
    Price DECIMAL(10, 2) NOT NULL CHECK (Price > 0),
    PrescriptionRequired BOOLEAN NOT NULL DEFAULT false,
    ManufacturerID INT NOT NULL,
    CategoryID INT NOT NULL,
    FOREIGN KEY (ManufacturerID) REFERENCES Manufacturers(ManufacturerID),
    FOREIGN KEY (CategoryID) REFERENCES DrugCategories(CategoryID)
);

CREATE TABLE Employees (
    EmployeeID SERIAL PRIMARY KEY,
    FirstName VARCHAR(255) NOT NULL,
    LastName VARCHAR(255) NOT NULL,
    Phone VARCHAR(20) NOT NULL,
    PositionID INT NOT NULL,
    PharmacyID INT NOT NULL,
    FOREIGN KEY (PositionID) REFERENCES Positions(PositionID),
    FOREIGN KEY (PharmacyID) REFERENCES Pharmacies(PharmacyID)
);

CREATE TABLE Prescriptions (
    PrescriptionID SERIAL PRIMARY KEY,
    ClientID INT NOT NULL,
    DrugID INT NOT NULL,
    DoctorID INT NOT NULL,
    IssueDate DATE NOT NULL DEFAULT CURRENT_DATE,
    ExpiryDate DATE NOT NULL,
    FOREIGN KEY (ClientID) REFERENCES Clients(ClientID),
    FOREIGN KEY (DrugID) REFERENCES Drugs(DrugID),
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID),
    CHECK (IssueDate <= ExpiryDate)
);

CREATE TABLE Payments (
    PaymentID SERIAL PRIMARY KEY,
    Amount DECIMAL(10, 2) NOT NULL CHECK (Amount >= 0),
    PaymentMethod VARCHAR(50) NOT NULL
);

CREATE TABLE Sales (
    SaleID SERIAL PRIMARY KEY,
    PharmacyID INT NOT NULL,
    ClientID INT NOT NULL,
    EmployeeID INT NOT NULL,
    SaleDate DATE NOT NULL DEFAULT CURRENT_DATE,
    PaymentID INT NOT NULL,
    PrescriptionID INT,
    FOREIGN KEY (PharmacyID) REFERENCES Pharmacies(PharmacyID),
    FOREIGN KEY (ClientID) REFERENCES Clients(ClientID),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
    FOREIGN KEY (PaymentID) REFERENCES Payments(PaymentID),
    FOREIGN KEY (PrescriptionID) REFERENCES Prescriptions(PrescriptionID)
);

CREATE TABLE SaleDetails (
    SaleDetailID SERIAL PRIMARY KEY,
    SaleID INT NOT NULL,
    DrugID INT NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity > 0),
    UnitPrice DECIMAL(10, 2) NOT NULL CHECK (UnitPrice >= 0),
    FOREIGN KEY (SaleID) REFERENCES Sales(SaleID),
    FOREIGN KEY (DrugID) REFERENCES Drugs(DrugID)
);

CREATE TABLE Inventory (
    InventoryID SERIAL PRIMARY KEY,
    PharmacyID INT NOT NULL,
    DrugID INT NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity >= 0),
    FOREIGN KEY (PharmacyID) REFERENCES Pharmacies(PharmacyID),
    FOREIGN KEY (DrugID) REFERENCES Drugs(DrugID)
);











INSERT INTO Country (Name, Code) VALUES
('Kazakhstan', 'KZ'),
('United States', 'USA'),
('Canada', 'CA'),
('Germany', 'DE'),
('United Kingdom', 'UK'),
('Japan', 'JP'),
('China', 'CN'),
('France', 'FR'),
('Australia', 'AU'),
('South Korea', 'KR');

INSERT INTO DrugCategories (CategoryName) VALUES
('Antibiotics'),
('Pain Relievers'),
('Cardiovascular Medications'),
('Antidiabetics'),
('Antihistamines'),
('Vitamins and Supplements'),
('Gastrointestinal Medications'),
('Respiratory Medications'),
('Neurological Medications'),
('Dermatological Medications');

INSERT INTO Manufacturers (Name, Address, Contact, CountryID) VALUES
('PharmaKZ', 'Almaty, Abay Ave 123', '+7 727 333 4455', 1),
('GlobalPharma Corp', 'New York, 5th Ave 10', '+1 212 555 1212', 2),
('MediCan Ltd', 'Toronto, Queen St 200', '+1 416 222 3344', 3),
('DeutscheMed GmbH', 'Berlin, Hauptstr. 50', '+49 30 9876 5432', 4),
('BritishPharma PLC', 'London, Oxford St 77', '+44 20 7946 0123', 5),
('NipponYakuhin Co.', 'Tokyo, Ginza 3-2-1', '+81 3 3567 8901', 6),
('ChinaDrug Inc.', 'Beijing, ChangAn Ave 88', '+86 10 6543 2109', 7),
('FranceSante SA', 'Paris, Champs-Élysées 99', '+33 1 4567 8910', 8),
('AussiePharma Pty', 'Sydney, George St 45', '+61 2 9234 5678', 9),
('KoreaMeds Co.', 'Seoul, Gangnam-daero 150', '+82 2 3456 7890', 10),
('LocalKazMed', 'Astana, Kenesary Khan St 5', '+7 7172 778899', 1);

INSERT INTO Positions (Title, Salary) VALUES
('Pharmacist', 4500.00),
('Pharmacy Technician', 2800.00),
('Pharmacy Manager', 5500.00),
('Cashier', 2000.00),
('Inventory Specialist', 3000.00),
('Head Pharmacist', 6000.00),
('Trainee Pharmacist', 3500.00),
('Senior Technician', 3200.00),
('Sales Assistant', 2200.00),
('Logistics Coordinator', 3300.00);

INSERT INTO Pharmacies (Name, Address, CountryID) VALUES
('MedCity Pharmacy', 'Almaty, Dostyk Ave 52', 1),
('GreenCross Pharma', 'Astana, Republic Ave 24', 1),
('Shifa Pharmacy', 'Shymkent, Tauke Khan Ave 10', 1),
('Daru Pharmacy', 'Karaganda, Bukhar-Zhyrau Ave 30', 1),
('Aybolit Pharmacy', 'Aktobe, Abulkhair Khan Ave 7', 1),
('VitaPlus Pharmacy', 'Taraz, Tole Bi Ave 15', 1),
('Zerde Pharmacy', 'Pavlodar, Nazarbayev Ave 80', 1),
('Emir Pharmacy', 'Semey, Abay St 2', 1),
('Birlik Pharmacy', 'Kyzylorda, Korkyt Ata Ave 40', 1),
('Salamat Pharmacy', 'Kostanay, Baytursynov St 20', 1),
('Central Pharmacy', 'Almaty, Kunaev St 1', 1);

INSERT INTO Clients (FirstName, LastName, Phone) VALUES
('Aisulu', 'Seitzhanova', '+7 701 111 2233'),
('Bakytzhan', 'Omarov', '+7 702 222 3344'),
('Gulnaz', 'Asanova', '+7 705 333 4455'),
('Darkhan', 'Kassenov', '+7 707 444 5566'),
('Zarina', 'Abylaikhanova', '+7 708 555 6677'),
('Yerzhan', 'Saparov', '+7 700 666 7788'),
('Aigerim', 'Tulegenova', '+7 706 777 8899'),
('Marat', 'Zhaxylykov', '+7 709 888 9900'),
('Dinara', 'Mukhtarova', '+7 704 999 0011'),
('Ruslan', 'Iskakov', '+7 703 000 1122'),
('Aliya', 'Nurgalieva', '+7 701 123 4567');

INSERT INTO Doctors (FirstName, LastName, Phone, CountryID, Specialty) VALUES
('Arman', 'Suleimenov', '+7 777 111 2233', 1, 'General Practitioner'),
('Laura', 'Khamitova', '+7 778 222 3344', 1, 'Cardiologist'),
('Bauyrzhan', 'Rakhimov', '+7 775 333 4455', 1, 'Pediatrician'),
('Aida', 'Muratova', '+7 771 444 5566', 1, 'Dermatologist'),
('Kanat', 'Serikov', '+7 772 555 6677', 1, 'Neurologist'),
('Zhanna', 'Orazbekova', '+7 776 666 7788', 1, 'Endocrinologist'),
('Asset', 'Tursynov', '+7 779 777 8899', 1, 'Surgeon'),
('Madina', 'Abdykalykova', '+7 774 888 9900', 1, 'Ophthalmologist'),
('Yerbolat', 'Zhumabekov', '+7 773 999 0011', 1, 'ENT Specialist'),
('Saltanat', 'Kuanysheva', '+7 770 000 1122', 1, 'Pulmonologist'),
('Dias', 'Amangeldy', '+7 778 123 5678', 1, 'Oncologist');

INSERT INTO Drugs (Name, Dose, Price, PrescriptionRequired, ManufacturerID, CategoryID) VALUES
('Amoxicillin', '250mg', 5.50, true, 1, 1),
('Paracetamol', '500mg', 2.00, false, 2, 2),
('Aspirin', '100mg', 1.50, false, 3, 2),
('Lisinopril', '10mg', 7.00, true, 4, 3),
('Metformin', '500mg', 6.00, true, 5, 4),
('Cetirizine', '10mg', 4.00, false, 6, 5),
('Vitamin C', '500mg', 3.00, false, 7, 6),
('Omeprazole', '20mg', 8.50, false, 8, 7),
('Salbutamol', '100mcg', 9.00, true, 9, 8),
('Diazepam', '5mg', 12.00, true, 10, 9),
('Hydrocortisone Cream', '1%', 4.50, false, 11, 10),
('Ibuprofen', '400mg', 2.50, false, 1, 2),
('Ciprofloxacin', '500mg', 6.80, true, 2, 1),
('Amlodipine', '5mg', 7.50, true, 3, 3);


INSERT INTO Employees (FirstName, LastName, Phone, PositionID, PharmacyID) VALUES
('Nurgul', 'Amirbekova', '+7 777 123 4567', 1, 1),
('Yerlan', 'Bekturov', '+7 776 234 5678', 2, 1),
('Aizhan', 'Sadykova', '+7 775 345 6789', 3, 2),
('Maksat', 'Tolegenov', '+7 774 456 7890', 1, 2),
('Gulmira', 'Kuanyshbayeva', '+7 773 567 8901', 2, 3),
('Almas', 'Zhantasov', '+7 772 678 9012', 4, 3),
('Zhanar', 'Omarova', '+7 771 789 0123', 1, 4),
('Askhat', 'Kenzhebayev', '+7 770 890 1234', 5, 4),
('Saule', 'Rysmendieva', '+7 779 901 2345', 1, 5),
('Rinat', 'Valiev', '+7 778 012 3456', 2, 5),
('Dana', 'Serikova', '+7 777 987 6543', 6, 1),
('Timur', 'Sarsenov', '+7 776 876 5432', 7, 2);

INSERT INTO Prescriptions (ClientID, DrugID, DoctorID, IssueDate, ExpiryDate) VALUES
(1, 1, 1, '2024-01-15', '2024-01-22'),
(2, 4, 2, '2024-01-20', '2024-01-27'),
(3, 5, 6, '2024-02-01', '2024-02-08'),
(4, 9, 10, '2024-02-10', '2024-02-17'),
(5, 10, 5, '2024-02-15', '2024-02-22'),
(6, 1, 1, '2024-03-01', '2024-03-08'),
(7, 4, 2, '2024-03-05', '2024-03-12'),
(8, 5, 6, '2024-03-10', '2024-03-17'),
(9, 9, 10, '2024-03-15', '2024-03-22'),
(10, 10, 5, '2024-03-20', '2024-03-27'),
(1, 13, 2, '2024-04-01', '2024-04-08'),
(2, 14, 1, '2024-04-05', '2024-04-12');

INSERT INTO Payments (Amount, PaymentMethod) VALUES
(25.00, 'Cash'),
(42.50, 'Credit Card'),
(18.00, 'Debit Card'),
(65.20, 'Insurance'),
(12.75, 'Cash'),
(30.00, 'Credit Card'),
(55.90, 'Insurance'),
(9.50, 'Debit Card'),
(78.15, 'Insurance'),
(22.30, 'Cash');

INSERT INTO Sales (PharmacyID, ClientID, EmployeeID, SaleDate, PaymentID, PrescriptionID) VALUES
(1, 1, 1, '2024-01-16', 1, 1),
(1, 2, 2, '2024-01-21', 2, 2),
(2, 3, 4, '2024-02-02', 3, 3),
(3, 4, 6, '2024-02-11', 4, 4),
(4, 5, 8, '2024-02-16', 5, 5),
(5, 6, 10, '2024-03-02', 6, 6),
(1, 7, 1, '2024-03-06', 7, 7),
(2, 8, 4, '2024-03-11', 8, 8),
(3, 9, 6, '2024-03-16', 9, 9),
(4, 10, 8, '2024-03-21', 10, 10),
(5, 1, 10, '2024-04-02', 1, 11),
(1, 2, 2, '2024-04-06', 2, 12),
(2, 3, 4, '2024-01-17', 3, NULL),
(3, 4, 6, '2024-01-22', 4, NULL),
(4, 5, 8, '2024-02-03', 5, NULL),
(5, 6, 10, '2024-02-09', 6, NULL),
(1, 7, 1, '2024-02-17', 7, NULL),
(2, 8, 4, '2024-02-23', 8, NULL),
(3, 9, 6, '2024-03-03', 9, NULL),
(4, 10, 8, '2024-03-09', 10, NULL),
(5, 1, 10, '2024-03-17', 1, NULL),
(1, 2, 2, '2024-03-23', 2, NULL),
(2, 3, 4, '2024-03-29', 3, NULL),
(3, 4, 6, '2024-04-04', 4, NULL),
(4, 5, 8, '2024-04-10', 5, NULL),
(5, 6, 10, '2024-04-16', 6, NULL),
(1, 7, 1, '2024-01-25', 7, NULL),
(2, 8, 4, '2024-01-31', 8, NULL),
(3, 9, 6, '2024-02-06', 9, NULL),
(4, 10, 8, '2024-02-12', 10, NULL),
(5, 1, 10, '2024-02-18', 1, NULL),
(1, 2, 2, '2024-02-24', 2, NULL),
(2, 3, 4, '2024-03-02', 3, NULL),
(3, 4, 6, '2024-03-08', 4, NULL),
(4, 5, 8, '2024-03-14', 5, NULL),
(5, 6, 10, '2024-03-20', 6, NULL),
(1, 7, 1, '2024-03-26', 7, NULL),
(2, 8, 4, '2024-04-01', 8, NULL),
(3, 9, 6, '2024-04-07', 9, NULL),
(4, 10, 8, '2024-04-13', 10, NULL);

INSERT INTO SaleDetails (SaleID, DrugID, Quantity, UnitPrice) VALUES
(1, 1, 2, 5.50),
(1, 7, 1, 3.00),
(2, 4, 1, 7.00),
(3, 5, 3, 6.00),
(4, 9, 1, 9.00),
(5, 10, 2, 12.00),
(6, 1, 2, 5.50),
(7, 4, 1, 7.00),
(8, 5, 3, 6.00),
(9, 9, 1, 9.00),
(10, 10, 2, 12.00),
(11, 13, 1, 6.80),
(12, 14, 1, 7.50),
(13, 2, 1, 2.00),
(14, 3, 2, 1.50),
(15, 6, 1, 4.00),
(16, 7, 3, 3.00),
(17, 8, 1, 8.50),
(18, 11, 1, 4.50),
(19, 12, 2, 2.50),
(20, 2, 1, 2.00),
(21, 3, 2, 1.50),
(22, 6, 1, 4.00),
(23, 7, 3, 3.00),
(24, 8, 1, 8.50),
(25, 11, 1, 4.50),
(26, 12, 2, 2.50),
(27, 2, 1, 2.00),
(28, 3, 2, 1.50),
(29, 6, 1, 4.00),
(30, 7, 3, 3.00),
(31, 8, 1, 8.50),
(32, 11, 1, 4.50),
(33, 12, 2, 2.50),
(34, 2, 1, 2.00),
(35, 3, 2, 1.50),
(36, 6, 1, 4.00),
(37, 7, 3, 3.00),
(38, 8, 1, 8.50),
(39, 11, 1, 4.50),
(40, 12, 2, 2.50);

INSERT INTO Inventory (PharmacyID, DrugID, Quantity) VALUES
(1, 1, 100),
(1, 2, 200),
(1, 3, 150),
(1, 4, 50),
(1, 5, 75),
(1, 6, 120),
(1, 7, 250),
(1, 8, 80),
(1, 9, 40),
(1, 10, 30),
(1, 11, 100),
(1, 12, 180),
(1, 13, 60),
(1, 14, 55),
(2, 1, 90),
(2, 2, 180),
(2, 3, 130),
(2, 4, 45),
(2, 5, 65),
(2, 6, 110),
(2, 7, 230),
(2, 8, 70),
(2, 9, 35),
(2, 10, 25),
(3, 1, 80),
(3, 2, 160),
(3, 3, 110),
(3, 4, 40),
(3, 5, 55),
(3, 6, 100),
(3, 7, 210),
(3, 8, 60),
(3, 9, 30),
(3, 10, 20);





--Roles and Users

create role pharmacy_admin_role;
create role pharmacy_manager_role;
create role pharmacy_pharmacist_role;
create role pharmacy_reader_role;


grant all privileges on schema public to pharmacy_admin_role;
grant all privileges on all tables in schema public to pharmacy_admin_role;
grant all privileges on all sequences in schema public to pharmacy_admin_role;

grant select, insert, update, delete on table manufacturers, pharmacies,
    employees, inventory, sales, saledetails, positions, drugcategories,
    drugs to pharmacy_manager_role;
grant select on table country, clients, prescriptions, payments to pharmacy_manager_role;

grant select, insert, update, delete on table sales, saledetails, prescriptions, payments, clients to pharmacy_pharmacist_role;
grant select, update on table inventory to pharmacy_pharmacist_role;

grant select on all tables in schema public to pharmacy_reader_role;

create user admin_user with password 'admin123';
create user manager_user with password 'manager123';
create user pharmacist_user with password 'pharmacist123';
create user reader_user with password 'reader123';

grant pharmacy_admin_role to admin_user;
grant pharmacy_manager_role to manager_user;
grant pharmacy_pharmacist_role to manager_user;
grant pharmacy_reader_role to reader_user;



--creating views

create view pharmacy_client_employee as
    select s.saleid, p.name as "Pharmacy name", c.firstname || ' ' || c.lastname as "Client Name",
       e.firstname || ' ' || e.lastname as "Employee name" from sales s
join pharmacies p on s.pharmacyid = p.pharmacyid
join employees e on p.pharmacyid = e.pharmacyid
join clients c on s.clientid = c.clientid;

create view totaldrugs_avgprice_per_drugcategories as
    select dc.categoryname, count(d.drugid) as TotalDrugs, avg(d.price) as AveragePrice  from drugcategories dc
join drugs d on dc.categoryid = d.categoryid
group by dc.categoryname
having avg(d.price) > 5
order by AveragePrice desc;

