merge DwOlist.dbo.Dim_Status as tgt 
using (

select  distinct
    order_status
from 
    olist.orders

) as src 
    on tgt.order_status = src.order_status

when 
    matched
    and 
        tgt.order_status is distinct from src.order_status
    then 
        update set 
            tgt.order_status = src.order_status

when not matched then
    insert (
        order_status
    )
    values (
        src.order_status
    );