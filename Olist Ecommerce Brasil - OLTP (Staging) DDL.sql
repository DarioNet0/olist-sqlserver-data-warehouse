CREATE TABLE olist.customers (
  customer_id varchar(50),
  customer_unique_id varchar(50),
  customer_zip_code_prefix char(5),
  customer_city varchar(255),
  customer_state char(2),
)
GO

CREATE TABLE olist.order_items (
  order_id varchar(50),
  order_item_id int,
  product_id varchar(50),
  seller_id varchar(50),
  shipping_limit_date datetime,
  price decimal(10,2),
  freight_value decimal(10,2),
)
GO

CREATE TABLE olist.order_payments (
  order_id varchar(50),
  payment_sequential int,
  payment_type varchar(50),
  payment_installments int,
  payment_value decimal(10,2),
)
GO

CREATE TABLE olist.order_reviews (
  review_id varchar(50),
  order_id varchar(50),
  review_score int,
  review_comment_title nvarchar(300),
  review_content_message nvarchar(1000),
  review_creation_date date,
  review_answer_timestamp datetime,
)
GO

CREATE TABLE olist.orders (
  order_id varchar(50),
  customer_id varchar(50),
  order_status varchar(50),
  order_purchase_timestamp varchar(50),
  order_approved_at varchar(50),
  order_deliver_carrier_date varchar(50),
  order_delivered_customer_date varchar(50),
  order_estimated_delivery_date date,
)
GO

CREATE TABLE olist.products (
  product_id varchar(50),
  product_category_name varchar(80),
  product_name_lenght varchar(30),
  product_description_lenght varchar(30),
  product_photos_qty varchar(30),
  product_weight_g varchar(30),
  prodcut_lenght_cm varchar(30),
  product_height_cm varchar(30),
  product_width_cm varchar(30),
)
GO

CREATE TABLE olist.sellers (
  seller_id varchar(50),
  seller_zip_code_prefix char(5),
  seller_state char(2),
  seller_city varchar(255),
)
GO