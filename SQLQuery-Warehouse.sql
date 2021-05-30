use warehouse;

CREATE TABLE Customer
(
	CustomersID int identity(1,1) NOT NULL,
	CompanyName nvarchar(45) NOT NULL,
	ContactName nvarchar(45) NOT NULL,
	Address nvarchar(45) NOT NULL,
	City nvarchar(45) NOT NULL,
	Province nvarchar(45) NOT NULL,
	Country nvarchar(45) NOT NULL,
	Phone nvarchar(45) NOT NULL,
	constraint PK_CustID PRIMARY KEY (CustomersID)
)
;

select * from Customer;

CREATE TABLE Vendor
(
	VendorID int identity(1,1) NOT NULL,
	VendorName nvarchar(45) NOT NULL,
	ContactName nvarchar(45) NOT NULL,
	Address nvarchar(100) NOT NULL,
	City nvarchar(45) NOT NULL,
	Province nvarchar(45) NOT NULL,
	Country nvarchar(45) NOT NULL,
	Phone nvarchar(45) NOT NULL,
	constraint PK_VendID PRIMARY KEY (VendorID)
)
;

select * from Vendor;

CREATE TABLE Product
(
	ProductID int identity(1,1) NOT NULL,
	Description nvarchar(100) NOT NULL,
	UnitOfMeasure nvarchar(45) NOT NULL,
	SellingPrice money NOT NULL,
	CostPrice money NOT NULL,
	VendorID int NOT NULL,
	ProductImage varbinary(max) NOT NULL,
	constraint PK_ProdID PRIMARY KEY (ProductID),
	CONSTRAINT FK_PRD_VND FOREIGN KEY (VendorID) 
			REFERENCES Vendor (VendorID),
	CONSTRAINT CK_PRD_UOM CHECK 
		(UnitOfMeasure IN ('Kg', 'Litre', 'Each', 'Case'))
)
;

select * from Product;

CREATE TABLE Inventory
(
	LocationID int identity(1,1) NOT NULL,
	ProductID int NOT NULL,
	Quantity int NOT NULL,
	WarehouseID int NOT NULL,
	constraint PK_LocID PRIMARY KEY (LocationID),
	constraint FK_Prd_Inv_ProdID FOREIGN KEY (ProductID)
		REFERENCES Product (ProductID)
)
;

ALTER TABLE Inventory 
	ADD constraint FK_Prd_Inv_ProdID FOREIGN KEY (ProductID)
		REFERENCES Product (ProductID);

ALTER TABLE Inventory 
	DROP constraint FK_ProdID;

select * from Inventory;

CREATE TABLE Purchase_Order
(
	PurchaseOrderID int identity(1,1) NOT NULL,
	ProductID int NOT NULL,
	VendorID int NOT NULL,
	Description nvarchar(100) NOT NULL,
	PurchaseQuantity int NOT NULL,
	UnitOfMeasure nvarchar(45) NOT NULL,
	CostPrice money NOT NULL,
	ShipMethod nvarchar(45) NOT NULL,
	PurchaseDate datetime NOT NULL,
	ShipDate datetime NOT NULL,
	OrderStatus nvarchar(45) NOT NULL,
	constraint PK_PurID PRIMARY KEY (PurchaseOrderID),
	constraint FK_Prd_Prch_Ord_ProdID FOREIGN KEY (ProductID)
		REFERENCES Product (ProductID),
	constraint FK_VendID FOREIGN KEY (VendorID)
		REFERENCES Vendor (VendorID),
	CONSTRAINT CK_PRCH_ORD_UOM CHECK 
		(UnitOfMeasure IN ('Kg', 'Litre', 'Each', 'Case')),
	CONSTRAINT CK_PRCH_ORD_SHP_MTHD CHECK 
		(ShipMethod IN ('Standard', 'Express')),
	CONSTRAINT CK_PRCH_ORD_ORD_STS CHECK 
		(OrderStatus IN ('Canceled','Declined','Pending','Shipped','In Transit','Complete'))
)
;

ALTER TABLE Purchase_Order 
	ADD constraint FK_VNDR_Prch_Ord_VendID FOREIGN KEY (VendorID)
		REFERENCES Vendor (VendorID);

ALTER TABLE Purchase_Order 
	DROP constraint FK_VendID ;

select * from Purchase_Order;

CREATE TABLE Sale_Order
(
	SaleOrderID int identity(1,1) NOT NULL,
	ProductID int NOT NULL,
	CustomersID int NOT NULL,
	Description nvarchar(100) NOT NULL,
	SaleQuantity int NOT NULL,
	UnitOfMeasure nvarchar(45) NOT NULL,
	SellingPrice money NOT NULL,
	ShipMethod nvarchar(45) NOT NULL,
	OrderDate datetime NOT NULL,
	ShipDate datetime NOT NULL,
	OrderStatus nvarchar(45) NOT NULL,
	constraint PK_SaleID PRIMARY KEY (SaleOrderID),
	constraint FK_Prd_Sale_Ord_ProdID FOREIGN KEY (ProductID)
		REFERENCES Product (ProductID),
	constraint FK_Cust_Sale_Ord_CustID FOREIGN KEY (CustomersID)
		REFERENCES Customer (CustomersID),
	CONSTRAINT CK_SALE_ORD_UOM CHECK 
		(UnitOfMeasure IN ('Kg', 'Litre', 'Each', 'Case')),
	CONSTRAINT CK_SALE_ORD_SHP_MTHD CHECK 
		(ShipMethod IN ('Standard', 'Express')),
	CONSTRAINT CK_SALE_ORD_ORD_STS CHECK 
		(OrderStatus IN ('Canceled','Declined','Pending','Shipped','In Transit','Complete'))
)
;

select * from Sale_Order;
