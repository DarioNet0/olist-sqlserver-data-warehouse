merge DwOlist.dbo.Dim_Order as tgt 
using (

select  
      order_id                                                  as bk_order_id
    , isnull(
        try_convert(datetime, order_purchase_timestamp, 101),
        cast('' as datetime)
    )                                                           as order_purchase_timestamp
    , isnull(
        try_convert(datetime, order_approved_at, 101),
        cast('' as datetime)
    )                                                           as order_approved_at
    , isnull(
        try_convert(date, order_deliver_carrier_date, 101),
        cast('' as date)
    )                                                           as order_deliver_carrier_date
    , isnull(
        try_convert(date, order_delivered_customer_date, 101),
        cast('' as date)
    )                                                           as order_delivered_customer_date
    , isnull(
        try_convert(date, order_estimated_delivery_date, 101),
        cast('' as date)
    )                                                           as order_estimated_delivery_date
from 
    olist.orders

) as src 
    on tgt.bk_order_id = src.bk_order_id

when matched 
    and (
           tgt.order_purchase_timestamp      is distinct from src.order_purchase_timestamp
        or tgt.order_approved_at             is distinct from src.order_approved_at
        or tgt.order_deliver_carrier_date    is distinct from src.order_deliver_carrier_date
        or tgt.order_delivered_customer_date is distinct from src.order_delivered_customer_date
        or tgt.order_estimated_delivery_date is distinct from src.order_estimated_delivery_date   
    )
    then update set 
          tgt.order_purchase_timestamp      = src.order_purchase_timestamp
        , tgt.order_approved_at             = src.order_approved_at
        , tgt.order_deliver_carrier_date    = src.order_deliver_carrier_date
        , tgt.order_delivered_customer_date = src.order_delivered_customer_date
        , tgt.order_estimated_delivery_date = src.order_estimated_delivery_date

when not matched then 
    insert (
          bk_order_id
        , order_purchase_timestamp
        , order_approved_at
        , order_deliver_carrier_date
        , order_delivered_customer_date
        , order_estimated_delivery_date
    ) 
    values (
          src.bk_order_id
        , src.order_purchase_timestamp
        , src.order_approved_at
        , src.order_deliver_carrier_date
        , src.order_delivered_customer_date
        , src.order_estimated_delivery_date
    );