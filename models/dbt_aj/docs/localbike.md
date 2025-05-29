Local Bike Data Model Documentation

Overview

The Local Bike data model is designed to support the analysis of sales data for a bicycle retailer. The model includes tables for customers, orders, products, staff, and stores.

Tables

Brands
Description: Product brands
Columns:
brand_id: Unique brand identifier
brand_name: Brand name
Tests:
unique: brand_id
not_null: brand_id
Categories
Description: Product categories
Columns:
category_id: Unique category identifier
category_name: Category name
Tests:
unique: category_id
not_null: category_id
Customers
Description: Customers
Columns:
customer_id: Unique customer identifier
first_name: Customer first name
last_name: Customer last name
phone: Customer phone number
email: Customer email
street: Customer street address
city: Customer city
state: Customer state or region
zip_code: Customer zip code
Tests:
unique: customer_id
not_null: customer_id
Orders
Description: Orders
Columns:
order_id: Unique order identifier
customer_id: Customer identifier
order_status: Order status
order_date: Order date
required_date: Required date
shipped_date: Shipped date
store_id: Store identifier
staff_id: Staff identifier
Tests:
unique: order_id
not_null: order_id
not_null: customer_id
relationships: customer_id to customers
Order Items
Description: Order items details
Columns:
order_id: Order identifier
item_id: Item identifier
product_id: Product identifier
quantity: Ordered quantity
list_price: Unit price
discount: Applied discount
Tests:
not_null: order_id
relationships: order_id to orders
not_null: product_id
relationships: product_id to products
Products
Description: Product catalog
Columns:
product_id: Unique product identifier
product_name: Product name
brand_id: Brand identifier
category_id: Category identifier
model_year: Model year
list_price: List price
Tests:
unique: product_id
not_null: product_id
not_null: brand_id
relationships: brand_id to brands
not_null: category_id
relationships: category_id to categories
Staff
Description: Sales staff
Columns:
staff_id: Staff identifier
first_name: First name
last_name: Last name
email: Email
phone: Phone number
active: Active status (0/1)
store_id: Assigned store
manager_id: Manager identifier
Tests:
unique: staff_id
not_null: staff_id
not_null: store_id
relationships: store_id to stores
Stocks
Description: Store inventory
Columns:
store_id: Store identifier
product_id: Product identifier
quantity: Quantity in stock
Tests:
not_null: store_id
relationships: store_id to stores
not_null: product_id
relationships: product_id to products
Stores
Description: Stores
Columns:
store_id: Store identifier
store_name: Store name
phone: Phone number
email: Email
street: Street address
city: City
state: State/Region
zip_code: Zip code
Tests:
unique: store_id
not_null: store_id