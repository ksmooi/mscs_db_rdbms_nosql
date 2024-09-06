-- Table to store customer information
CREATE TABLE Customers (
   CustomerID SERIAL PRIMARY KEY,        -- Unique identifier for each customer
   Name VARCHAR(100) NOT NULL,           -- Customer's name
   Email VARCHAR(100) NOT NULL UNIQUE,   -- Customer's email (must be unique)
   PhoneNumber VARCHAR(15),              -- Customer's phone number (optional)
   Address TEXT,                         -- Customer's address
   LoyaltyPoints INT DEFAULT 0           -- Loyalty points earned by the customer (default is 0)
);

-- Table to store book information
CREATE TABLE Books (
   ISBN VARCHAR(20) PRIMARY KEY,         -- Unique ISBN for each book (Primary Key)
   Title VARCHAR(255) NOT NULL,          -- Title of the book
   Genre VARCHAR(50),                    -- Genre of the book
   Price DECIMAL(10, 2) NOT NULL,        -- Price of the book
   StockQuantity INT NOT NULL,           -- Number of copies available in stock
   SupplierID INT,                       -- Supplier providing the book (Foreign Key)
   PublicationDate DATE,                 -- Date when the book was published
   CONSTRAINT fk_supplier FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID)
                                          -- Foreign key linking to the Suppliers table
);

-- Table to store supplier information
CREATE TABLE Suppliers (
   SupplierID SERIAL PRIMARY KEY,        -- Unique identifier for each supplier
   Name VARCHAR(100) NOT NULL,           -- Supplier's name
   ContactInformation TEXT,              -- Contact information for the supplier (phone/email)
   Address TEXT                          -- Supplier's physical address
);

-- Table to store order information
CREATE TABLE Orders (
   OrderID SERIAL PRIMARY KEY,           -- Unique identifier for each order
   OrderDate DATE NOT NULL,              -- Date when the order was placed
   CustomerID INT NOT NULL,              -- Customer who placed the order (Foreign Key)
   ShippingAddress TEXT,                 -- Address to ship the order (for online orders)
   TotalAmount DECIMAL(10, 2) NOT NULL,  -- Total amount of the order
   CONSTRAINT fk_customer FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
                                          -- Foreign key linking to the Customers table
);

-- Table to store the details of each order (many-to-many relationship between Orders and Books)
CREATE TABLE OrderDetails (
   OrderID INT NOT NULL,                 -- ID of the order (Foreign Key)
   ISBN VARCHAR(20) NOT NULL,            -- ISBN of the book (Foreign Key)
   Quantity INT NOT NULL,                -- Quantity of the book ordered
   PRIMARY KEY (OrderID, ISBN),          -- Composite primary key (OrderID and ISBN together)
   CONSTRAINT fk_order FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
                                          -- Foreign key linking to the Orders table
   CONSTRAINT fk_book FOREIGN KEY (ISBN) REFERENCES Books(ISBN)
                                          -- Foreign key linking to the Books table
);

-- Table to store customer reviews for books
CREATE TABLE Reviews (
   ReviewID SERIAL PRIMARY KEY,          -- Unique identifier for each review
   CustomerID INT NOT NULL,              -- Customer who left the review (Foreign Key)
   ISBN VARCHAR(20) NOT NULL,            -- Book being reviewed (Foreign Key)
   Rating INT CHECK (Rating >= 1 AND Rating <= 5),  
                                          -- Rating given to the book (between 1 and 5)
   Comment TEXT,                         -- Review comment
   ReviewDate DATE NOT NULL,             -- Date when the review was posted
   CONSTRAINT fk_review_customer FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
                                          -- Foreign key linking to the Customers table
   CONSTRAINT fk_review_book FOREIGN KEY (ISBN) REFERENCES Books(ISBN)
                                          -- Foreign key linking to the Books table
);

-- Table to store shipping details for online orders
CREATE TABLE Shipping (
   ShippingID SERIAL PRIMARY KEY,        -- Unique identifier for each shipping record
   OrderID INT NOT NULL,                 -- Order being shipped (Foreign Key)
   ShippingDate DATE NOT NULL,           -- Date when the order was shipped
   ShippingAddress TEXT NOT NULL,        -- Address where the order is shipped
   CONSTRAINT fk_shipping_order FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
                                          -- Foreign key linking to the Orders table
);
