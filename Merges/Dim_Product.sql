merge DwOlist.dbo.Dim_Product as tgt 
using (

select 
      product_id                     as bk_product_id                 
    , isnull(try_convert(int, nullif(product_name_lenght, '')), 0)          as product_name_lenght
    , isnull(try_convert(int, nullif(product_description_lenght, '')), 0)   as product_description_lenght
    , isnull(try_convert(int, nullif(product_photos_qty, '')), 0)           as product_photos_qty
from 
    olist.products

) as src 
    on tgt.bk_product_id = src.bk_product_id

when matched 
    and (
           tgt.product_name_lenght        is distinct from src.product_name_lenght
        or tgt.product_description_lenght is distinct from src.product_description_lenght
        or tgt.product_photos_qty         is distinct from src.product_photos_qty  
    )
    then update set 
          tgt.product_name_lenght        = src.product_name_lenght
        , tgt.product_description_lenght = src.product_description_lenght
        , tgt.product_photos_qty         = src.product_photos_qty

when not matched then 
    insert (
          bk_product_id
        , product_name_lenght
        , product_description_lenght
        , product_photos_qty    
    )
    values (
          src.bk_product_id
        , src.product_name_lenght
        , src.product_description_lenght
        , src.product_photos_qty
    );