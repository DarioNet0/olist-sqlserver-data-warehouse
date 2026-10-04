/*
================================================================================
 Olist Brazilian E-commerce — Analytical Queries (DwOlist)
--------------------------------------------------------------------------------
 Three business questions answered from the star schema:
   1. Which product categories have the best average review score?
   2. What is the average delivery time by customer state?
   3. Which payment method is the most used?
================================================================================
*/

use DwOlist;
go


/* -----------------------------------------------------------------------------
 Q1. Best-rated product categories
     Grain: one row per category.
     Only categories with at least 100 reviewed orders are ranked, so a
     category with 3 perfect reviews doesn't top the list.
----------------------------------------------------------------------------- */
with order_category as (
    select distinct
          foi.sk_order
        , foi.sk_category
    from
        dbo.Fact_Order_Items foi
)
select
      dense_rank() over (order by avg(cast(fr.review_score as decimal(4,2))) desc) as ranking
    , dc.product_category_name                                                   as category
    , count(distinct fr.sk_review)                                               as total_reviews
    , cast(avg(cast(fr.review_score as decimal(4,2))) as decimal(4,2))           as avg_review_score
    , cast(
        100.0 * sum(case when fr.review_score >= 4 then 1 else 0 end) / count(*)
        as decimal(5,2)
      )                                                                          as pct_positive_reviews
from
    order_category oc

    inner join dbo.Fact_Reviews fr
        on fr.sk_order = oc.sk_order

    inner join dbo.Dim_Category dc
        on dc.Sk_Category = oc.sk_category
group by
    dc.product_category_name
having
    count(distinct fr.sk_review) >= 100
order by
    avg_review_score desc;
go


/* -----------------------------------------------------------------------------
 Q2. Average delivery time by customer state
     Grain: one row per state.
     Delivery time = purchase -> delivered to customer, in days.
     Also compares against the estimated date the customer was promised.
----------------------------------------------------------------------------- */
with delivered_orders as (
    select distinct
          foi.sk_order
        , foi.sk_customer
    from
        dbo.Fact_Order_Items foi

        inner join dbo.Dim_Status ds
            on ds.sk_status = foi.sk_status
    where
        ds.order_status = 'delivered'
)
select
      dcu.customer_state                                                          as customer_state
    , count(*)                                                                    as delivered_orders
    , cast(avg(1.0 * datediff(day, do.order_purchase_timestamp
                                 , do.order_delivered_customer_date)) as decimal(6,1)) as avg_delivery_days
    , cast(avg(1.0 * datediff(day, do.order_delivered_customer_date
                                 , do.order_estimated_delivery_date)) as decimal(6,1)) as avg_days_ahead_of_estimate
    , cast(
        100.0 * sum(case when do.order_delivered_customer_date > do.order_estimated_delivery_date
                         then 1 else 0 end) / count(*)
        as decimal(5,2)
      )                                                                           as pct_late_orders
from
    delivered_orders dlo

    inner join dbo.Dim_Order do
        on do.sk_order = dlo.sk_order

    inner join dbo.Dim_Customer dcu
        on dcu.sk_customer = dlo.sk_customer
where
        do.order_purchase_timestamp      > '1900-01-01'
    and do.order_delivered_customer_date > '1900-01-01'
    and do.order_estimated_delivery_date > '1900-01-01'
group by
    dcu.customer_state
order by
    avg_delivery_days desc;
go


/* -----------------------------------------------------------------------------
 Q3. Most used payment methods
     Grain: one row per payment type.
     "Most used" is measured three ways: number of orders, number of
     payment transactions, and total value paid.
----------------------------------------------------------------------------- */
select
      dpt.payment_type                                                            as payment_type
    , count(distinct fp.sk_order)                                                 as total_orders
    , count(*)                                                                    as total_transactions
    , sum(fp.payment_value)                                                       as total_value
    , cast(avg(fp.payment_value) as decimal(10,2))                                as avg_ticket
    , cast(avg(1.0 * fp.payment_installments) as decimal(5,2))                    as avg_installments
    , cast(100.0 * count(*) / sum(count(*)) over () as decimal(5,2))              as pct_of_transactions
    , cast(100.0 * sum(fp.payment_value) / sum(sum(fp.payment_value)) over ()
           as decimal(5,2))                                                       as pct_of_value
from
    dbo.Fact_Payments fp

    inner join dbo.Dim_Payment_Type dpt
        on dpt.sk_payment_type = fp.sk_payment_type
group by
    dpt.payment_type
order by
    total_transactions desc;
go
