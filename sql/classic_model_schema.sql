-- Create the ClassicModels database
-- CREATE DATABASE ClassicModels;

-- Connect to the ClassicModels database
-- \c ClassicModels;

-- -----------------------------------------------------
-- Schema classicmodels
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS ClassicModels;

-- -----------------------------------------------------
-- Table {schema}.{table} ClassicModels.Offices
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS ClassicModels.Offices (
	officeCode VARCHAR(10) PRIMARY KEY,
	city VARCHAR(50) NOT NULL,
	phone VARCHAR(50) NOT NULL,
	addressLine1 VARCHAR(50) NOT NULL,
	addressLine2 VARCHAR(50),
	state VARCHAR(50),
	country VARCHAR(50) NOT NULL,
	postalCode VARCHAR(15) NOT NULL,
	territory VARCHAR(10) NOT NULL
);

-- -----------------------------------------------------
-- Table {schema}.{table} ClassicModels.Employees
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS ClassicModels.Employees (
  employeeNumber INTEGER PRIMARY KEY,
  lastName VARCHAR(50) NOT NULL,
  firstName VARCHAR(50) NOT NULL,
  extension VARCHAR(10) NOT NULL,
  email VARCHAR(100) NOT NULL,
  reportsTo INTEGER,
  jobTitle VARCHAR(50) NOT NULL,
  officeCode VARCHAR(10) NOT NULL,
  CONSTRAINT fk_Employees_Employees
  	FOREIGN KEY (reportsTo)
	REFERENCES ClassicModels.Employees (employeeNumber)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION,
  CONSTRAINT fk_Employees_Offices
  	FOREIGN KEY (officeCode)
	REFERENCES ClassicModels.Offices (officeCode)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION
);

CREATE INDEX IF NOT EXISTS fk_Employees_Employees_idx ON ClassicModels.Employees
(
    reportsTo ASC
);

CREATE INDEX IF NOT EXISTS fk_Employees_Offices_idx ON ClassicModels.Employees
(
    officeCode ASC
);

-- -----------------------------------------------------
-- Table {schema}.{table} ClassicModels.Customers
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS ClassicModels.Customers (
  customerNumber INTEGER PRIMARY KEY,
  customerName VARCHAR(50) NOT NULL,
  contactLastName VARCHAR(50) NOT NULL,
  contactFirstName VARCHAR(50) NOT NULL,
  phone VARCHAR(50) NOT NULL,
  addressLine1 VARCHAR(50) NOT NULL,
  addressLine2 VARCHAR(50),
  city VARCHAR(50) NOT NULL,
  state VARCHAR(50),
  postalCode VARCHAR(15),
  country VARCHAR(50) NOT NULL,
  salesRepEmployeeNumber INTEGER NULL,
  creditLimit NUMERIC,
  CONSTRAINT fk_fk_Customers_Employees
  	FOREIGN KEY (salesRepEmployeeNumber)
	REFERENCES ClassicModels.Employees (employeeNumber)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION
);

CREATE INDEX IF NOT EXISTS fk_Customers_Employees_idx ON ClassicModels.Customers
(
    salesRepEmployeeNumber ASC
);

-- -----------------------------------------------------
-- Table {schema}.{table} ClassicModels.ProductLines
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS ClassicModels.ProductLines (
  productLine VARCHAR(50) PRIMARY KEY,
  textDescription VARCHAR(4000),
  htmlDescription TEXT,
  image BYTEA
);

-- -----------------------------------------------------
-- Table {schema}.{table} ClassicModels.Products
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS ClassicModels.Products (
  productCode VARCHAR(15) PRIMARY KEY,
  productName VARCHAR(70) NOT NULL,
  productScale VARCHAR(10) NOT NULL,
  productVendor VARCHAR(50) NOT NULL,
  productDescription TEXT NOT NULL,
  quantityInStock SMALLINT NOT NULL,
  buyPrice NUMERIC NOT NULL,
  MSRP NUMERIC NOT NULL,
  productLine VARCHAR(50) NULL,
  CONSTRAINT fk_Products_ProductLines
  	FOREIGN KEY (productLine)
	REFERENCES ClassicModels.ProductLines (productLine)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION
);

CREATE INDEX IF NOT EXISTS fk_Products_ProductLines_idx ON ClassicModels.Products
(
    productLine ASC
);

-- -----------------------------------------------------
-- Table {schema}.{table} ClassicModels.Orders
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS ClassicModels.Orders (
  orderNumber INTEGER PRIMARY KEY,
  orderDate TIMESTAMP NOT NULL,
  requiredDate TIMESTAMP NOT NULL,
  shippedDate TIMESTAMP,
  status VARCHAR(15) NOT NULL,
  comments TEXT,
  customerNumber INTEGER NOT NULL,
  CONSTRAINT fk_Orders_Customers
  	FOREIGN KEY (customerNumber)
	REFERENCES ClassicModels.Customers (customerNumber)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION
);

CREATE INDEX IF NOT EXISTS fk_Orders_Customers_idx ON ClassicModels.Orders
(
    customerNumber ASC
);

-- -----------------------------------------------------
-- Table {schema}.{table} ClassicModels.OrderDetails
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS ClassicModels.OrderDetails (
  orderNumber INTEGER NOT NULL,
  productCode VARCHAR(15) NOT NULL,
  quantityOrdered INTEGER NOT NULL,
  priceEach NUMERIC NOT NULL,
  orderLineNumber SMALLINT NOT NULL,
  PRIMARY KEY (productCode, orderNumber),
  CONSTRAINT fk_OrderDetails_Products
  	FOREIGN KEY (productCode)
	REFERENCES ClassicModels.Products (productCode)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION,
  CONSTRAINT fk_OrderDetails_Orders
  	FOREIGN KEY (orderNumber)
	REFERENCES ClassicModels.Orders (orderNumber)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION
);

CREATE INDEX IF NOT EXISTS fk_OrderDetails_Products_idx ON ClassicModels.OrderDetails
(
    productCode ASC
);

CREATE INDEX IF NOT EXISTS fk_OrderDetails_Orders_idx ON ClassicModels.OrderDetails
(
    orderNumber ASC
);

-- -----------------------------------------------------
-- Table {schema}.{table} ClassicModels.Payments
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS ClassicModels.Payments (
  checkNumber VARCHAR(50) PRIMARY KEY,
  paymentDate TIMESTAMP NOT NULL,
  amount NUMERIC NOT NULL,
  customerNumber INTEGER NOT NULL,
  CONSTRAINT fk_Payments_Customers
  	FOREIGN KEY (customerNumber)
	REFERENCES ClassicModels.Customers (customerNumber)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION
);

CREATE INDEX IF NOT EXISTS fk_Payments_Customers_idx ON ClassicModels.Payments
(
    customerNumber ASC
);

