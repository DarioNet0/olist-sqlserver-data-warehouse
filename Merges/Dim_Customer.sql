merge DwOlist.dbo.Dim_Customer as tgt
using (

select 
      c.customer_id                as bk_customer_id
    , c.customer_unique_id         as customer_unique_id
    , c.customer_zip_code_prefix   as customer_zip_code_prefix
    , c.customer_city              as customer_city
    , c.customer_state             as customer_state
    , 1                            as is_current
from 
    olist.customers c

) as src 
    on tgt.bk_customer_id = src.bk_customer_id

when matched 
    and (
            tgt.customer_unique_id       is distinct from src.customer_unique_id
        or tgt.customer_zip_code_prefix  is distinct from src.customer_zip_code_prefix
        or tgt.customer_city             is distinct from src.customer_city
        or tgt.customer_state            is distinct from src.customer_state
        or tgt.is_current                is distinct from src.is_current
    )
then update set is_current = 0

when not matched then 
    insert(
          bk_customer_id
        , customer_unique_id
        , customer_zip_code_prefix
        , customer_city
        , customer_state
        , is_current
    )
    values (
         src.bk_customer_id
        , src.customer_unique_id
        , src.customer_zip_code_prefix
        , src.customer_city
        , src.customer_state
        , src.is_current
    );


insert into DwOlist.dbo.Dim_Customer (
      bk_customer_id
    , customer_unique_id
    , customer_zip_code_prefix
    , customer_city
    , customer_state
    , is_current
)
select 
    *
from 
    (
        select 
              c.customer_id                as bk_customer_id
            , c.customer_unique_id         as customer_unique_id
            , c.customer_zip_code_prefix   as customer_zip_code_prefix
            , c.customer_city              as customer_city
            , c.customer_state             as customer_state
            , 1                            as is_current
        from 
            olist.customers c
        where  exists (
            select 
                1 
            from 
                DwOlist.dbo.Dim_Customer dc
            where 
                dc.bk_customer_Id = c.customer_id
                and dc.is_current = 0
        )
    ) as src