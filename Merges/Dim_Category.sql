merge DwOlist.dbo.Dim_Category as tgt 
using (

select distinct 
    ISNULL(NULLIF(product_category_name, ''), 'Unkown') as product_category_name
from 
    olist.products

) as src 
    on tgt.product_category_name = src.product_category_name

when 
    matched
    and 
        tgt.product_category_name is distinct from src.product_category_name
    then 
        update set 
            tgt.product_category_name = src.product_category_name

when not matched then
    insert (
        product_category_name
    )
    values (
        src.product_category_name
    );