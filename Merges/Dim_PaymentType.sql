merge DwOlist.dbo.Dim_Payment_Type as tgt 
using (

select distinct
    payment_type 
from 
    olist.order_payments
) as src 
    on tgt.payment_type = src.payment_type

when 
    matched
    and 
        tgt.payment_type is distinct from src.payment_type
    then 
        update set 
            tgt.payment_type = src.payment_type

when not matched then
    insert (
        payment_type
    )
    values (
        src.payment_type
    );