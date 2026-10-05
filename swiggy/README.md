# Swiggy Customer & Order Analytics

A portfolio project demonstrating practical **PostgreSQL SQL analysis and Power BI dashboarding** using a Swiggy-style food delivery dataset.

## Project Objective

The objective is to analyze order performance and customer behavior and turn the analysis into actionable business insights.

The project focuses on:

- Revenue and order KPIs
- Average Order Value (AOV)
- Customer activation
- Customer revenue contribution
- Customer value segmentation
- Restaurant performance
- Monthly revenue trends
- Customer-level analysis

## Tools Used

- **PostgreSQL** — data validation, transformation and analysis
- **SQL** — aggregations, CTEs, CASE statements, window functions and date handling
- **Power BI** — interactive dashboard and business reporting

## Database Schema

Main tables:

- `users` — registered customers
- `orders` — order-level transaction data
- `order_details` — food items associated with orders
- `restaurants` — restaurant information
- `food` — food/item information
- `menu` — restaurant menu mapping
- `delivery_partner` — delivery partner information

### Important Data Grain

`orders` is the central transaction table and contains **one row per order**.

`order_details` contains food-item-level records. Joining these two tables and summing `orders.amount` without controlling the grain can double-count revenue.

## Key Results

| KPI | Result |
|---|---:|
| Total Orders | 25 |
| Total Revenue | ₹10,490 |
| Average Order Value | ₹419.60 |
| Registered Customers | 7 |
| Purchasing Customers | 5 |
| Customer Activation Rate | 71.43% |
| Minimum Order Value | ₹180 |
| Maximum Order Value | ₹950 |

## Customer Analysis

The analysis identified three AOV-based customer value groups plus registered users with no orders.

| Segment | Customers | Revenue |
|---|---:|---:|
| High Value | 2 | ₹5,705 |
| Mid Value | 2 | ₹3,465 |
| Low Value | 1 | ₹1,320 |
| No Orders | 2 | ₹0 |

The two High Value customers represent **40% of purchasing customers and 54.38% of total revenue**.

### Important Observation

All five purchasing customers have exactly **5 orders** in this dataset.

Therefore, frequency does not provide meaningful differentiation between customers. The project deliberately avoids making unsupported frequency-based loyalty claims or forcing an RFM model onto the data.

## Dashboard

### Page 1 — Executive Overview

The executive dashboard contains:

- Total Orders
- Total Revenue
- Average Order Value
- Registered Customers
- Customer Activation Rate
- Monthly Revenue Trend
- Restaurant Revenue Performance
- Customer Segmentation
- Customer Revenue

### Page 2 — Customer Analytics

The customer analytics page provides customer-level:

- Order count
- Revenue
- AOV
- Customer segment

## Business Insights

### 1. Revenue concentration

High-value customers contribute a disproportionately large share of revenue. This suggests that retaining and engaging high-value customers should be a priority.

### 2. Customer activation opportunity

5 of 7 registered users have placed an order, giving an activation rate of 71.43%.

The two registered users with no orders represent an opportunity for first-order conversion.

### 3. AOV varies significantly

Customer AOV ranges from ₹264 to ₹607.

This indicates that understanding what drives larger baskets could help improve overall order value.

### 4. Frequency cannot be used as a differentiator

Every purchasing customer has five orders in the available dataset. More advanced frequency-based customer segmentation would therefore not be reliable here.

## Recommendations

1. Focus retention and engagement efforts on high-value customers.
2. Investigate the factors associated with higher AOV, such as restaurant, cuisine or item mix.
3. Create first-order activation initiatives for registered users who have not ordered.
4. Collect more historical transactions before implementing meaningful frequency/RFM segmentation.
5. Use customer and restaurant performance together to investigate revenue drivers.

## Project Limitations

- The dataset contains only 25 orders and 7 registered customers.
- The data appears structured/synthetic and should not be interpreted as actual Swiggy business performance.
- Customer frequency is not sufficiently varied for meaningful frequency-based segmentation.
- The analysis is descriptive rather than predictive.
- The project does not claim causal relationships.

## Repository Structure

```text
swiggy-customer-order-analytics/
│
├── README.md
├── sql/
│   └── swiggy_analysis.sql
├── powerbi/
│   └── Swiggy_Customer_Order_Analytics.pbix
├── dashboard/
│   ├── executive_overview.png
│   └── customer_analytics.png
└── data/
    └── README.md
```

## Portfolio Skills Demonstrated

**SQL**
- PostgreSQL
- Aggregations
- JOINs
- GROUP BY
- CTEs
- CASE statements
- Window functions
- Date conversion
- Customer segmentation
- Revenue contribution analysis

**Power BI**
- PostgreSQL data connection
- Power Query data type transformation
- Data modeling and relationships
- DAX measures
- Calculated columns
- KPI cards
- Interactive charts
- Customer analytics dashboard

## Author

**Mayukh Dutta**

This project was created as a practical data analytics portfolio project to demonstrate SQL and Power BI skills.
