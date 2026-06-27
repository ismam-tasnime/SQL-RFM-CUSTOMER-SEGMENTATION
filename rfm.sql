select * from public.online_retail_data
where customerid='18283'
-- rfm segmentation
create view rfm_seg as
with rfm3 as 
(select 
customerid,
max(invoicedate) as last_date,
count(distinct invoiceno) as frequency,
round((sum(quantity*unitprice)::numeric),2) as monetary,
(select max(invoicedate) from public.online_retail_data) as bld
from public.online_retail_data
group by 1
order by 1 desc),
 rfm2 as
 (	
select 
customerid,
((bld::date)-(last_date::date)+1) as recency_days,
frequency,
monetary
from rfm3
order by 4 asc),
rfm as (
select 
*,
ntile(5) over(order by recency_days desc) as r_score,
ntile(5) over(order by frequency asc) as f_score,
ntile(5) over(order by monetary asc) as m_score
from rfm2
),
segment as 
(
select
*,
concat(r_score,f_score,m_score) as RFM_Score
from rfm
),
percentage as
(select
*, 
case when RFM_Score in ('111','112','121','113','114','131','141') then 'Churned_Custmer'
		 when RFM_Score in ('123','124','122','133','134','144','334') then 'Slepping_Away'
         when RFM_Score in ('311','411','331','321')then 'Lost_Custmer'
         when RFM_Score in ('211','222','232','233','234','244') then 'Potential_Custmer'
         when RFM_Score in ('322','323','333','324','344','334') then 'Active_Custmer'
         when RFM_Score in ('421','422','423','434','444','433') then 'Loyal_Custmer'
	else 'Others' end as RFM_Seg
	from segment
)
select 
RFM_Seg,
count(distinct customerid),
round(count(distinct customerid)::numeric/(select count(distinct customerid)::numeric 
from public.online_retail_data)*100,2) as percentage_value
from percentage
group by 1

select * from public.rfm_seg

