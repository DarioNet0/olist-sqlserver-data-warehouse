CREATE TABLE Fact_Order_Items (
  sk_order int,
  order_item_id int,
  sk_status int,
  sk_customer int,
  sk_product int,
  sk_category int,
  sk_seller int,
  product_weight_g int,
  product_lenght_cm int,
  product_height_cm int,
  product_width_cm int,
  price decimal(10,2),
  freight_value int,
  Shopping_limit_date date

  PRIMARY KEY(sk_order, order_item_id)
)
GO

CREATE TABLE Fact_Payments (
  sk_order int,
  sk_payment_type int,
  payment_sequential int,
  payment_installments int,
  payment_value decimal(10,2)

  PRIMARY KEY(sk_order, payment_sequential)
)
GO

CREATE TABLE Fact_Reviews (
  sk_review int identity,
  sk_order int,
  bk_review_id varchar(32),
  review_score int

  PRIMARY KEY (sk_review)
)
GO

CREATE TABLE Dim_Reviews (
  sk_review int identity,
  bk_review_id varchar(32),
  review_comment_title varchar(255),
  review_content_message varchar(255),
  review_creation_date date,
  review_answer_timestamp datetime,
  review_score int,
  PRIMARY KEY (sk_review)
)
GO

CREATE TABLE Dim_Payment_Type (
  sk_payment_type int identity,
  bk_payment_type varchar(255),
  PRIMARY KEY (sk_payment_type)
)
GO

CREATE TABLE Dim_Order (
  sk_order int identity,
  bk_order_id varchar(32),
  order_purchase_timestamp datetime,
  order_approved_at datetime,
  order_deliver_carrier_date date,
  order_delivered_customer_date date,
  order_estimated_delivery_date date,
  PRIMARY KEY (sk_order)
)
GO

CREATE TABLE Dim_Status (
  sk_status int identity,
  bk_status varchar(25),
  PRIMARY KEY (sk_status)
)
GO

CREATE TABLE Dim_Customer (
  sk_customer int identity,
  bk_customer_Id varchar(32),
  customer_unique_id varchar(32),
  customer_zip_code_prefix char(5),
  customer_city varchar(255),
  customer_state varchar(255),
  is_current int 
  PRIMARY KEY (sk_customer)
)
GO

CREATE TABLE Dim_Product (
  sk_product int identity,
  Bk_Product_Id varchar(32),
  product_name_lenght int,
  product_description_lenght int,
  product_photos_qty int,
  PRIMARY KEY (sk_product)
)
GO

CREATE TABLE Dim_Category (
  Sk_Category int identity,
  product_category_name varchar(255),
  PRIMARY KEY (Sk_Category)
)
GO

CREATE TABLE Dim_Sellers (
  Sk_Seller int identity,
  Bk_Seller_id varchar(32),
  Seller_state char(2),
  Seller_city varchar(255),
  PRIMARY KEY (Sk_Seller)
)
GO

ALTER TABLE Fact_Order_Items ADD FOREIGN KEY (sk_order) REFERENCES Dim_Order (sk_order)
GO

ALTER TABLE Fact_Order_Items ADD FOREIGN KEY (sk_status) REFERENCES Dim_Status (sk_status)
GO

ALTER TABLE Fact_Order_Items ADD FOREIGN KEY (sk_customer) REFERENCES Dim_Customer (sk_customer)
GO

ALTER TABLE Fact_Order_Items ADD FOREIGN KEY (sk_product) REFERENCES Dim_Product (sk_product)
GO

ALTER TABLE Fact_Order_Items ADD FOREIGN KEY (sk_category) REFERENCES Dim_Category (Sk_Category)
GO

ALTER TABLE Fact_Order_Items ADD FOREIGN KEY (sk_seller) REFERENCES Dim_Sellers (Sk_Seller)
GO

ALTER TABLE Fact_Payments ADD FOREIGN KEY (sk_order) REFERENCES Dim_Order (sk_order)
GO

ALTER TABLE Fact_Payments ADD FOREIGN KEY (sk_payment_type) REFERENCES Dim_Payment_Type (sk_payment_type)
GO

ALTER TABLE Fact_Reviews ADD FOREIGN KEY (sk_order) REFERENCES Dim_Order (sk_order)
GO

ALTER TABLE Fact_Reviews ADD FOREIGN KEY (sk_review) REFERENCES Dim_Reviews (sk_review)
GO
