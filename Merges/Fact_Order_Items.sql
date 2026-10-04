merge DwOlist.dbo.Fact_Order_Items as tgt
using(

select
      do.sk_order                          as sk_order
    , oi.order_item_id                     as order_item_id
    , ds.sk_status                         as sk_status
    , dc.sk_customer                       as sk_customer
    , dp.sk_product                        as sk_product
    , dcat.Sk_Category                     as Sk_Category
    , dsell.Sk_Seller                      as Sk_Seller
    , p.product_weight_g                   as product_weight_g
    , p.prodcut_lenght_cm                  as prodcut_lenght_cm
    , p.product_height_cm                  as product_height_cm
    , p.product_width_cm                   as product_width_cm
    , oi.price                             as price
    , oi.freight_value                     as freight_value
    , cast(oi.shipping_limit_date as date) as Shopping_limit_date
from 
    olist.orders o

    inner join olist.order_items oi 
        on o.order_id = oi.order_id
    
    inner join DwOlist.dbo.Dim_Order do
        on do.bk_order_id = o.order_id

    inner join DwOlist.dbo.Dim_Status ds
        on ds.order_status = o.order_status

    inner join DwOlist.dbo.Dim_Customer dc
        on dc.bk_customer_Id = o.customer_id

    inner join DwOlist.dbo.Dim_Product dp
        on dp.Bk_Product_Id = oi.product_id
    
    inner join olist.products p
        on oi.product_id = p.product_id

    inner join DwOlist.dbo.Dim_Category dcat
        on dcat.product_category_name = p.product_category_name

    inner join DwOlist.dbo.Dim_Sellers dsell
        on dsell.Bk_Seller_id = oi.seller_id 

) as src 
    on tgt.sk_order       = src.sk_order
    and tgt.order_item_id = src.order_item_id

when matched 
    and (
           tgt.sk_status           is distinct from src.sk_status
        or tgt.sk_customer         is distinct from src.sk_customer
        or tgt.sk_product          is distinct from src.sk_product
        or tgt.Sk_Category         is distinct from src.Sk_Category
        or tgt.Sk_Seller           is distinct from src.Sk_Seller
        or tgt.product_weight_g    is distinct from src.product_weight_g
        or tgt.product_lenght_cm   is distinct from src.prodcut_lenght_cm
        or tgt.product_height_cm   is distinct from src.product_height_cm
        or tgt.product_width_cm    is distinct from src.product_width_cm
        or tgt.price               is distinct from src.price
        or tgt.freight_value       is distinct from src.freight_value
        or tgt.Shopping_limit_date is distinct from src.Shopping_limit_date
    ) 
    then update set 
          tgt.sk_status           = src.sk_status
        , tgt.sk_customer         = src.sk_customer
        , tgt.Sk_Category         = src.Sk_Category
        , tgt.Sk_Seller           = src.Sk_Seller
        , tgt.product_weight_g    = src.product_weight_g
        , tgt.product_lenght_cm   = src.prodcut_lenght_cm
        , tgt.product_height_cm   = src.product_height_cm
        , tgt.product_width_cm    = src.product_width_cm
        , tgt.price               = src.price
        , tgt.freight_value       = src.freight_value
        , tgt.Shopping_limit_date = src.Shopping_limit_date
        , tgt.sk_product          = src.sk_product

when not matched then 
    insert (
          sk_order
        , sk_status
        , sk_customer
        , sk_product
        , sk_category
        , sk_seller
        , product_weight_g
        , product_lenght_cm
        , product_height_cm
        , product_width_cm
        , price
        , freight_value
        , Shopping_limit_date  
        , order_item_id
    )
    values (
          src.sk_order
        , src.sk_status
        , src.sk_customer
        , src.sk_product
        , src.sk_category
        , src.sk_seller
        , src.product_weight_g
        , src.prodcut_lenght_cm
        , src.product_height_cm
        , src.product_width_cm
        , src.price
        , src.freight_value
        , src.Shopping_limit_date
        , src.order_item_id
    );