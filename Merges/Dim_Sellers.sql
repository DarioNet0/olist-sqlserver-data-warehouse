merge DwOlist.dbo.Dim_Sellers as tgt 
using (

select 
      seller_id    as Bk_Seller_id
    , Seller_state as Seller_state
    , Seller_city  as Seller_city
from 
    olist.sellers

) as src 
    on tgt.Bk_Seller_id = src.Bk_Seller_id

when matched 
    and (
           tgt.Seller_state is distinct from src.Seller_state
        or tgt.Seller_city  is distinct from src.Seller_city       
    )
    then update set 
      tgt. Seller_state = src.Seller_state
    , tgt. Seller_city  = src.Seller_city

when not matched then 
    insert (
          Bk_Seller_id
        , Seller_state
        , Seller_city
    ) 
    values (
           src.Bk_Seller_id
         , src.Seller_state
         , src.Seller_city
    );