E-commerce Database Project
Overview
This project implements a MySQL database for an e-commerce platform, designed to optimize query performance and provide insights through customer segmentation and sales analysis.
Features

Optimized database schema for an e-commerce platform
Strategic indexing for improved query performance
SQL views for key performance indicators (KPIs)
Customer segmentation analysis
Integration with Power BI for data visualization

Database Structure
The database consists of the following main tables:

Users
Products
Categories
Orders
OrderItems


Key SQL Views

vw_customer_segmentation: Segments customers based on their order history
vw_sales_by_category: Provides sales data grouped by product categories

Performance Optimization

Implemented strategic indexing on frequently queried columns
Optimized JOIN operations in complex queries
Created materialized views for frequently accessed aggregated data

Power BI Integration

Connect Power BI to the MySQL database
Use the provided .pbix file to visualize key metrics and customer segments


Technologies Used

MySQL
MySQL Workbench
Power BI

