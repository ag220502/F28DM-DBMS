#Creating table for Company branches to store the details of the branches in UK.
CREATE TABLE CompanyBranches
(
	branchId INT(11) PRIMARY KEY AUTO_INCREMENT NOT NULL,
	name VARCHAR(20) NOT NULL UNIQUE,
	phoneNumber VARCHAR(13) NOT NULL UNIQUE,
	mobileNumber VARCHAR(13),
	faxNumber VARCHAR(13),
	emailId VARCHAR(30) NOT NULL DEFAULT "contactus@hwmotors.uk",
	blockNumber VARCHAR(6), 
	streetName VARCHAR(30), 
	areaName VARCHAR(30), 
	cityName VARCHAR(30),
	stateName VARCHAR(30), 
	pincode VARCHAR(6), 
	openingDate DATE DEFAULT CURDATE(),
	openingTime TIME DEFAULT CURTIME(), 
	closingTime TIME,
	branchStatus ENUM('active', 'inActive') NOT NULL DEFAULT "active"
)ENGINE=INNODB;

#Creating table for storing the unique name of the departments so that we dont have to duplicate the names
CREATE TABLE DepartmentNames
(
	depId INT(11) PRIMARY KEY AUTO_INCREMENT NOT NULL,
	depName VARCHAR(20) NOT NULL UNIQUE
)ENGINE=INNODB;

#Creating table for departments of each branch in UK.
CREATE TABLE Departments
(
	bhdId INT(11) PRIMARY KEY AUTO_INCREMENT NOT NULL,
	depId INT(11),
	branchId INT(11) NOT NULL,
	openingDate DATE DEFAULT CURDATE(),
	closingDate DATE,
	openingTime TIME DEFAULT CURTIME(),
	closingTime TIME,
	depStatus ENUM('active', 'inActive') DEFAULT "active",
	FOREIGN KEY (depId) REFERENCES DepartmentNames(depId) ON DELETE SET NULL,
	FOREIGN KEY (branchId) REFERENCES CompanyBranches(branchId) ON DELETE CASCADE
)ENGINE=INNODB;

#Creating a table to define all the unique roles of an employee.
CREATE TABLE EmployeeRole
(
	roleId INT(11) PRIMARY KEY AUTO_INCREMENT NOT NULL,
	role VARCHAR(40) NOT NULL UNIQUE
)ENGINE=INNODB;

#Creating Employee table for storing details for each employee in all the branches and departments.
CREATE TABLE Employee
(
	empId INT(11) PRIMARY KEY AUTO_INCREMENT NOT NULL,
	firstName VARCHAR(20) NOT NULL,
	lastName VARCHAR(20),
	phoneNumber VARCHAR(13) NOT NULL UNIQUE,
	emailId VARCHAR(30) UNIQUE, 
	userName VARCHAR(20) NOT NULL UNIQUE, 
	password VARCHAR(30) NOT NULL DEFAULT "emp1234", 
	dateOfBirth DATE, 
	gender ENUM('M','F','O'),
	roleId INT(11),
	empDOJ DATE DEFAULT CURDATE(), 
	empDOL DATE,
	comingTime TIME DEFAULT CURTIME(),
	leavingTime TIME,
	supervisor INT(11),
	blockNumber VARCHAR(6), 
	streetName VARCHAR(30), 
	areaName VARCHAR(30), 
	cityName VARCHAR(30), 
	stateName VARCHAR(30), 
	pincode VARCHAR(30),
	status ENUM('active', 'inActive') NOT NULL DEFAULT "active",
	FOREIGN KEY (roleId) REFERENCES EmployeeRole(roleId) ON DELETE SET NULL,
    FOREIGN KEY (supervisor) REFERENCES Employee(empId) ON DELETE SET NULL
)ENGINE=INNODB;

#Creating table for storing data of employees working in each department. This table keep records of and employee in which he/she worked
CREATE TABLE WorksIn
(
	bheId INT(11) PRIMARY KEY AUTO_INCREMENT NOT NULL, 
	bhdId INT(11), 
	empId INT(11), 
	dateOfJoiningDep DATE DEFAULT CURDATE(),
	dateOfLeavingDep DATE,
	FOREIGN KEY (bhdId) REFERENCES Departments(bhdId) ON DELETE SET NULL,
	FOREIGN KEY (empId) REFERENCES Employee(empId) ON DELETE SET NULL
)ENGINE=INNODB;

#Creating a table to manage salaries of employees working in company.
CREATE TABLE EmployeeHasSalary
(
	ehsId INT(11) PRIMARY KEY AUTO_INCREMENT NOT NULL,  
	empId INT(11) NOT NULL, 
	basicSalary FLOAT DEFAULT 0, 
	bonus FLOAT DEFAULT 0, 
	totalSalary FLOAT DEFAULT 0, 
	dateOfSalaryAllotment DATE,
	FOREIGN KEY (empId) REFERENCES Employee(empId) ON DELETE CASCADE
)ENGINE=INNODB;

#Creating table to store categories of vehicles like sports, luxury and all.
CREATE TABLE VehicleCategories
(
	catId INT(11) PRIMARY KEY AUTO_INCREMENT NOT NULL,
	catName VARCHAR(40) NOT NULL UNIQUE,
	minUserAge INT(3) NOT NULL DEFAULT 21
)ENGINE=INNODB;

#Creating table for storing the types of vehicles in company.
CREATE TABLE VehicleType
(
	vehCatId INT(11) PRIMARY KEY AUTO_INCREMENT NOT NULL, 
	vehCatName VARCHAR(40) NOT NULL UNIQUE, 
	hirePrice FLOAT DEFAULT 0,
	noOfSeats INT(2), 
	catId INT(11),
	transmissionType ENUM('manual', 'automatic', 'autopilot') DEFAULT "automatic", 
	engineSize VARCHAR(20), 
	fuelType ENUM('diesel', 'petrol', 'electric'),
	FOREIGN KEY (catId) REFERENCES VehicleCategories(catId) ON DELETE SET NULL
)ENGINE=INNODB;

#Creating table for storing vehicle car images for displaying on website
CREATE TABLE VehicleCarImages
(
	vehCatId INT(11) NOT NULL,
	carImage VARCHAR(50) NOT NULL UNIQUE,
	PRIMARY KEY(vehCatId,carImage),
	FOREIGN KEY (vehCatId) REFERENCES VehicleType(vehCatId) ON DELETE CASCADE
)ENGINE=INNODB;

#Creating table for vehicles showing information of the vehicle.
CREATE TABLE Vehicles
(
	vehId INT(11) PRIMARY KEY AUTO_INCREMENT NOT NULL,  
	vehCatId INT(11), 
	vehNumberPlate VARCHAR(20) UNIQUE,
	vehIndNum VARCHAR(16) NOT NULL UNIQUE,
	homeBranchId INT(11),
	isAvailable BOOLEAN DEFAULT 1,
	FOREIGN KEY (vehCatId) REFERENCES VehicleType(vehCatId) ON DELETE SET NULL,
	FOREIGN KEY (homeBranchId) REFERENCES CompanyBranches(branchId) ON DELETE SET NULL
)ENGINE=INNODB;

#Creating table for carrier service which sends vehicles from one branch to other
CREATE TABLE CarrierServices
(
	vehIndNum VARCHAR(16) NOT NULL, 
	movingFrom INT(11), 
	movingTo INT(11),
	movingDate DATE NOT NULL DEFAULT CURDATE(),
	PRIMARY KEY(vehIndNum,movingFrom,movingTo,movingDate),
	FOREIGN KEY (vehIndNum) REFERENCES Vehicles(vehIndNum) ON DELETE CASCADE,
	FOREIGN KEY (movingFrom) REFERENCES CompanyBranches(branchId) ON DELETE CASCADE,
	FOREIGN KEY (movingTo) REFERENCES CompanyBranches(branchId) ON DELETE CASCADE
)ENGINE=INNODB;

#Creating table for services as the vehicles have services
CREATE TABLE Services
(
	serviceId INT(11) PRIMARY KEY AUTO_INCREMENT NOT NULL, 
	vehIndNum VARCHAR(16) NOT NULL, 
	isWashed BOOLEAN DEFAULT 0,
	isMotTested BOOLEAN DEFAULT 0,
	isOiled BOOLEAN DEFAULT 0,
	other BOOLEAN DEFAULT 0,
	serviceDate DATE DEFAULT CURDATE(),
	status ENUM('atService', 'completed') DEFAULT "atService", 
	nextDue DATE,
	FOREIGN KEY (vehIndNum) REFERENCES Vehicles(vehIndNum) ON DELETE CASCADE
)ENGINE=INNODB;

#Creating table for users showing all their details and information.
CREATE TABLE Users
( 
	userId INT(11) PRIMARY KEY AUTO_INCREMENT NOT NULL,
	firstName VARCHAR(20) NOT NULL,
	lastName VARCHAR(20),
	phoneNumber VARCHAR(13) NOT NULL UNIQUE,
	emailId VARCHAR(30) UNIQUE, 
	userName VARCHAR(20) NOT NULL UNIQUE, 
	password VARCHAR(30) NOT NULL DEFAULT "user@123", 
	dateOfBirth DATE, 
	gender ENUM('M', 'F', 'O'),
	blockNumber VARCHAR(6), 
	streetName VARCHAR(30), 
	areaName VARCHAR(30), 
	cityName VARCHAR(30), 
	stateName VARCHAR(30), 
	pincode VARCHAR(30),
	licenseNumber VARCHAR(40) UNIQUE, 
	isEmailVerified BOOLEAN NOT NULL DEFAULT 0, 
	isMobileVerified BOOLEAN NOT NULL DEFAULT 0, 
	dateOfRegistration DATE NOT NULL DEFAULT CURDATE()
)ENGINE=INNODB;

#Creating table for extra drivers showing their names and details.
CREATE TABLE ExtraDrivers
(
	edId INT(11) PRIMARY KEY AUTO_INCREMENT NOT NULL, 
	licenseNumber VARCHAR(40) NOT NULL UNIQUE, 
	firstName VARCHAR(20) NOT NULL,
	lastName VARCHAR(20),
	phoneNumber VARCHAR(13) NOT NULL UNIQUE,
	emailId VARCHAR(30) UNIQUE
)ENGINE=INNODB;

#Creating table for creating offers that can be used in booking to avail discount.
CREATE TABLE Offers
(
	offerId INT(11) PRIMARY KEY AUTO_INCREMENT NOT NULL,  
	couponCode VARCHAR(10) NOT NULL UNIQUE, 
	startDate DATE DEFAULT CURDATE(), 
	endDate DATE, 
	discountPercent FLOAT DEFAULT 0, 
	maxDiscount FLOAT DEFAULT 0, 
	empId INT(11),
	FOREIGN KEY (empId) REFERENCES Employee(empId) ON DELETE SET NULL
)ENGINE=INNODB;

#Creating table for bookings taking all the deatils and information of all the bookings.
CREATE TABLE Bookings
(
	bookingId BIGINT(11) PRIMARY KEY AUTO_INCREMENT NOT NULL,   
	vehIndNum VARCHAR(16), 
	userPhoneNum VARCHAR(13), 
	bookingDate DATE DEFAULT CURDATE(),
	startDate DATE DEFAULT CURDATE(),
	endDate DATE, 
	actualEndDate DATE, 
	haveInsurance BOOLEAN DEFAULT 1, 
	pickUpBranchId INT(11), 
	leavingBranchId INT(11), 
	pickUpTime TIME,
	droppingTime TIME, 
	bookingStatus ENUM('booked', 'active', 'completed') DEFAULT "booked", 
	startingKmReading FLOAT DEFAULT 0, 
	leavingKmReading FLOAT DEFAULT 0, 
	amount FLOAT DEFAULT 0, 
	couponCode VARCHAR(10), 
	discAmount FLOAT DEFAULT 0, 
	totalAmount FLOAT DEFAULT 0,
	FOREIGN KEY (vehIndNum) REFERENCES Vehicles(vehIndNum) ON DELETE SET NULL,
	FOREIGN KEY (userPhoneNum) REFERENCES Users(phoneNumber) ON DELETE SET NULL,
	FOREIGN KEY (pickUpBranchId) REFERENCES CompanyBranches(branchId) ON DELETE SET NULL,
	FOREIGN KEY (leavingBranchId) REFERENCES CompanyBranches(branchId) ON DELETE SET NULL,
	FOREIGN KEY (couponCode) REFERENCES Offers(couponCode) ON DELETE SET NULL
)ENGINE=INNODB;

#Creating table for additional drivers, as some bookings have additional drivers.
CREATE TABLE AdditionalDrivers
(
	edId INT(11) NULL,
	bookingId BIGINT(11) NOT NULL,
	userId INT(11) NULL,
	PRIMARY KEY(edId,bookingId,userId),
	FOREIGN KEY (edId) REFERENCES ExtraDrivers(edId) ON DELETE CASCADE,
	FOREIGN KEY (bookingId) REFERENCES Bookings(bookingId) ON DELETE CASCADE,
	FOREIGN KEY (userId) REFERENCES Users(userId) ON DELETE CASCADE
)ENGINE=INNODB;

#Creating table for storing car images that show car images while user makes booking.
CREATE TABLE BookingCarImages
(
	bookingId BIGINT(11) NOT NULL,
	carImage VARCHAR(50) NOT NULL UNIQUE,
	PRIMARY KEY(bookingId,carImage),
    FOREIGN KEY (bookingId) REFERENCES Bookings(bookingId) ON DELETE CASCADE
)ENGINE=INNODB;

#--------------------INDEXES--------------------

#Index for Offers Table
CREATE INDEX OfferName ON Offers(couponCode);

#Index for Vehicle Type
CREATE INDEX ModelName ON VehicleType(vehCatName);

#Index for Vehicles
CREATE INDEX VIN ON Vehicles(vehIndNum);

#Index for Number plate
CREATE INDEX VehicleNumberPlate ON Vehicles(vehNumberPlate);

#Index for company branches
CREATE INDEX BranchName ON CompanyBranches(name);

#Index for Extra Drivers
CREATE INDEX ExtraDriverLicense ON ExtraDrivers(licenseNumber);

#Index for Works in table to find the employee
CREATE INDEX EmployeeDetails ON WorksIn(empId);

#Indexes for users table
CREATE INDEX UserPhoneNumber ON Users(phoneNumber);
CREATE INDEX UserLoginName ON Users(userName);

#Indexes for Bookings table
CREATE INDEX UserDetails ON Bookings(userPhoneNum);
CREATE INDEX VehicleDetails ON Bookings(vehIndNum);

#Indexes for Employee table
CREATE INDEX EmpPhoneNumber ON Employee(phoneNumber);
CREATE INDEX EmpUserName ON Employee(userName);