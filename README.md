# SQL-RFM-CUSTOMER-SEGMENTATION
PostgreSQL-based RFM customer segmentation project analyzing customer value, activity status, churn risk, loyalty, and purchasing behavior for business decision-making.
SQL RFM Customer Segmentation Analysis

Project Overview

This project is a customer segmentation analysis using PostgreSQL. The main goal of this project is to segment customers based on their purchasing behavior using the RFM method.

RFM means:

* Recency: How recently a customer purchased
* Frequency: How often a customer purchased
* Monetary: How much money a customer spent

Using this analysis, customers were divided into different business segments such as Active Customer, Churned Customer, Lost Customer, Loyal Customer, Potential Customer, Sleeping Away, and Others.

This project helps an e-commerce business understand customer behavior, identify valuable customers, detect churn risk, and create better marketing strategies.

⸻

Business Problem

In an e-commerce business, all customers do not behave the same way. Some customers buy regularly, some spend more, some stop purchasing, and some may become loyal customers in the future.

If the company treats every customer the same way, it may waste marketing budget and miss important business opportunities.

The main business problems are:

* The company does not clearly know which customers are loyal.
* The company does not know which customers are inactive or churned.
* The company cannot easily identify potential customers.
* Marketing campaigns may not be targeted properly.
* Customer retention strategy becomes difficult without segmentation.

So, this project uses SQL-based RFM segmentation to classify customers into meaningful groups.

⸻

Project Objective

The main objectives of this project are:

* Calculate each customer’s last purchase date.
* Calculate each customer’s total number of orders.
* Calculate each customer’s total spending.
* Create Recency, Frequency, and Monetary scores.
* Combine RFM scores into one final RFM score.
* Segment customers based on their RFM score.
* Calculate customer count and percentage for each segment.
* Generate business insights and recommendations.

⸻

Tools Used

Tool	Purpose
PostgreSQL	Data cleaning, transformation, and RFM calculation
pgAdmin	Writing and running SQL queries
Excel	Result formatting and percentage visualization
GitHub	Project documentation and portfolio presentation

⸻

Dataset Information

The analysis was performed using an e-commerce retail dataset stored in the PostgreSQL table:

public.online_retail_data

Important columns used in this project:

Column Name	Description
customerid	Unique customer ID
invoiceno	Unique invoice or order number
invoicedate	Date of customer purchase
quantity	Number of products purchased
unitprice	Price per product

The total spending was calculated using:

quantity * unitprice

⸻

SQL Workflow

The full SQL analysis was completed using multiple CTEs.

A CTE means Common Table Expression. It helps break a complex SQL query into smaller and easier steps. In this project, each CTE was used for a specific stage of the RFM analysis.

The main SQL stages are:

1. rfm_seg CTE
2. rfm2 CTE
3. rfm3 CTE
4. rfm4 CTE
5. segment CTE
6. Final aggregation query

⸻

Step 1: Creating the rfm_seg CTE

The first CTE was named rfm_seg.

This CTE was used to calculate the basic RFM values for each customer.

The calculated values were:

* Last purchase date
* Purchase frequency
* Total monetary value

SQL logic used in this stage:

* MAX(invoicedate) was used to find the last purchase date of each customer.
* COUNT(DISTINCT invoiceno) was used to count how many orders each customer placed.
* SUM(quantity * unitprice) was used to calculate total customer spending.
* GROUP BY customerid was used because the analysis was done at customer level.

Why this CTE was used

This CTE was used to convert transaction-level data into customer-level data.

In the raw dataset, one customer may have many order rows. But for RFM analysis, each customer needs one final row with their recency, frequency, and monetary information.

Business meaning

This step helps the business understand:

* When each customer last purchased
* How many times each customer purchased
* How much each customer spent

⸻

Step 2: Creating the rfm2 CTE

The second CTE was named rfm2.

This CTE was used to calculate recency_days.

Recency_days means how many days have passed since the customer’s last purchase.

The logic used was:

CURRENT_DATE - last_date::date + 1

Why this CTE was used

The previous CTE only calculated the last purchase date. But for RFM analysis, the business needs to know how recent the customer is.

For example:

Customer	Last Purchase Behavior	Meaning
Purchased recently	Low recency days	Active or valuable customer
Purchased long ago	High recency days	Churned, lost, or inactive customer

Why +1 was used

The +1 was used to avoid zero-day values and make the calculation more practical.

Business meaning

This step helps identify whether a customer is still active or becoming inactive.

⸻

Step 3: Creating the rfm3 CTE

The third CTE was named rfm3.

This CTE was used to create three individual scores:

* r_score
* f_score
* m_score

The NTILE(5) window function was used in this stage.

What NTILE(5) does

NTILE(5) divides customers into 5 groups based on their values.

The score range is from 1 to 5.

Score	Meaning
1	Low performance
2	Below average
3	Average
4	Good
5	Best performance

Recency Score

Recency score was created from recency_days.

Customers who purchased more recently are more valuable than customers who purchased long ago.

Frequency Score

Frequency score was created from total order count.

Customers with higher frequency purchased more often, so they are more valuable.

Monetary Score

Monetary score was created from total spending.

Customers with higher monetary value spent more money, so they are more valuable.

Why window function was used

Window functions allow scoring customers while keeping each customer row in the result.

This means the query can calculate scores without losing customer-level details.

Business meaning

This step helps rank customers based on:

* Recent activity
* Buying frequency
* Total spending power

⸻

Step 4: Creating the rfm4 CTE

The fourth CTE was named rfm4.

This CTE was used to combine the three RFM scores into one final RFM score.

The CONCAT function was used to combine:

* r_score
* f_score
* m_score

Example:

r_score	f_score	m_score	Final RFM Score
5	5	5	555
4	4	4	444
1	1	1	111

Why CONCAT was used

CONCAT was used to create one combined score from three different scores.

This makes it easier to classify customers into business segments.

Business meaning

Instead of analyzing three separate numbers, the business can use one RFM score to understand customer behavior.

⸻

Step 5: Creating the segment CTE

The fifth CTE was named segment.

This CTE was used to assign each customer into a final customer segment.

A CASE WHEN statement was used for segmentation.

The customer segments were:

* Active_Customer
* Churned_Customer
* Lost_Customer
* Loyal_Customer
* Potential_Customer
* Sleeping_Away
* Others

Why CASE WHEN was used

CASE WHEN was used to apply business rules inside SQL.

It converts numeric RFM scores into meaningful business categories.

For example:

RFM Score Pattern	Customer Segment
Low RFM score	Churned Customer or Lost Customer
Medium RFM score	Potential Customer or Active Customer
Strong RFM score	Loyal Customer
Other mixed scores	Others

Business meaning

This step converts technical SQL results into business-friendly customer groups.

Instead of saying customer has RFM score 333, the business can say this customer is an Active Customer.

⸻

Step 6: Final Aggregation Query

The final query was used to calculate:

* Number of customers in each segment
* Percentage of customers in each segment

COUNT(DISTINCT customerid) was used to count unique customers.

A subquery was used to calculate the total number of customers in the dataset.

The percentage formula was:

Segment Customer Count / Total Customer Count * 100

Why GROUP BY was used

GROUP BY was used to group customers by their segment name.

This allows the final output to show customer count and percentage for each segment.

Business meaning

This final stage shows the overall customer distribution of the business.

It helps the company understand which customer segment is large, which segment is risky, and which segment should be targeted.

⸻

Final Output
![rfm](images/rfm.JPG)


⸻

Business Insight Table

Customer Segment	Customer Count	Percentage	Business Insight
Others	2,164	or 49.50%	This is the largest group. Almost half of the customers are not clearly classified into the main segments. This group needs deeper analysis.
Potential_Customer	500 or	11.44%	These customers have future value. With proper offers and engagement, they can become active or loyal customers.
Churned_Customer	422	or 9.65%	These customers show weak recent activity and may have stopped purchasing. They need win-back campaigns.
Sleeping_Away	395	or 9.03%	These customers are not fully lost yet, but their purchasing activity is decreasing. They need quick reactivation.
Loyal_Customer	328	or 7.50%	These customers are valuable because they show strong purchase behavior. They should be retained with loyalty benefits.
Active_Customer	296	or 6.77%	These customers are currently engaged. The business can target them for upselling and cross-selling.
Lost_Customer	267 or	6.11%	These customers are likely inactive for a long time. The company should use low-cost remarketing or special win-back offers.

⸻

Key Findings

The largest customer segment is Others, representing 49.50% of total customers. This means many customers do not fall into the main predefined RFM groups. This segment should be studied further and divided into more specific groups in future analysis.

Potential customers represent 11.44% of the customer base. This is an important opportunity for the business because these customers can become active or loyal customers with the right marketing strategy.

Churned customers represent 9.65% of total customers. This shows that a noticeable portion of customers may have already stopped purchasing.

Sleeping Away customers represent 9.03%. These customers are at risk but may still be easier to recover than fully lost customers.

Lost customers represent 6.11%. These customers may be difficult to recover, so the business should not spend too much marketing budget on them unless they had high past value.

Loyal customers represent 7.50%. This group is small but highly important because loyal customers usually generate repeated revenue.

Active customers represent 6.77%. These customers are currently engaged and should be targeted before they become inactive.

The combined percentage of Churned Customer, Sleeping Away, and Lost Customer is:

9.65% + 9.03% + 6.11% = 24.79%

This means almost one-fourth of customers are inactive, declining, or already lost. This is an important warning sign for the business.

⸻

Business Recommendations

Customer Segment	Recommended Action
Loyal_Customer	Provide loyalty rewards, membership benefits, early access offers, and personalized discounts.
Active_Customer	Use upselling and cross-selling strategies to increase average order value and repeat purchases.
Potential_Customer	Send personalized offers, product recommendations, and limited-time discounts to convert them into active customers.
Sleeping_Away	Run reactivation campaigns such as reminder emails, special discounts, and “We miss you” offers.
Churned_Customer	Use win-back campaigns, feedback surveys, and strong return incentives.
Lost_Customer	Use low-cost remarketing only. Avoid spending high marketing budget unless they were high-value customers in the past.
Others	Further segment this group into smaller categories such as New Customer, One-Time Buyer, Recent Low Spender, and Big Spender.

⸻

Strategic Business Actions

1. Improve Customer Retention

Around 24.79% of customers are churned, sleeping away, or lost. This means the company should focus more on retention.

Recommended actions:

* Send personalized email campaigns
* Offer discount coupons
* Create loyalty points
* Provide special return offers
* Ask inactive customers for feedback

⸻

2. Increase Revenue from Loyal and Active Customers

Loyal and active customers are already engaged with the business. They are more likely to purchase again.

Recommended actions:

* Recommend premium products
* Offer bundle deals
* Use cross-selling campaigns
* Provide exclusive membership offers
* Give early access to new products

⸻

3. Convert Potential Customers

Potential customers are a strong growth opportunity. They may not be loyal yet, but their behavior shows future value.

Recommended actions:

* Send personalized product suggestions
* Offer first loyalty reward
* Give limited-time discounts
* Encourage repeat purchases
* Use targeted remarketing

⸻

4. Investigate the Others Segment

The Others segment is very large at 49.50%. This means the current segmentation logic can be improved further.

Recommended actions:

* Create more specific RFM segment groups
* Add categories such as New Customer, Big Spender, Recent Low Spender, and One-Time Buyer
* Analyze average order value by segment
* Analyze revenue contribution by segment
* Analyze monthly customer movement between segments

⸻

Project Workflow

Raw Transaction Data
↓
Customer-Level Aggregation
↓
Calculate Recency, Frequency, and Monetary Value
↓
Create RFM Scores Using NTILE
↓
Combine RFM Scores
↓
Create Customer Segments
↓
Calculate Segment Count and Percentage
↓
Generate Business Insights and Recommendations

⸻

SQL Concepts Used

CTE	Used to divide the full analysis into smaller readable stages
GROUP BY	Used to aggregate data at customer and segment level
MAX	Used to find each customer’s last purchase date
COUNT DISTINCT	Used to count unique orders and unique customers
SUM	Used to calculate total customer spending
ROUND	Used to format monetary values and percentage values
NTILE	Used to divide customers into scoring groups
Window Function	Used to calculate RFM scores while keeping customer-level rows
CONCAT	Used to combine recency, frequency, and monetary scores
CASE WHEN	Used to assign customer segment names
Subquery	Used to calculate total customer count for percentage calculation

⸻

Business Value of This Project

This project helps an e-commerce company to:

* Identify loyal customers
* Detect churned customers
* Find customers with future potential
* Improve customer retention strategy
* Reduce unnecessary marketing costs
* Increase repeat purchases
* Support data-driven marketing decisions
* Build targeted customer campaigns


⸻
Conclusion

This RFM Customer Segmentation project shows how SQL can be used to transform raw transaction data into meaningful business insights.

Using PostgreSQL, customers were segmented based on recency, frequency, and monetary value. The final result helps the business understand customer behavior and take better marketing, retention, and revenue growth decisions.

This project demonstrates practical skills in SQL, customer analytics, business analysis, and data-driven decision-making.
