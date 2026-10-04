merge DwOlist.dbo.Fact_Payments as tgt
using (

select 
      do.sk_order             as sk_order
    , dpt.sk_payment_type     as sk_payment_type
    , op.payment_sequential   as payment_sequential
    , op.payment_installments as payment_installments
    , op.payment_value        as payment_value 
from 
    olist.order_payments op

    inner join DwOlist.dbo.Dim_Payment_Type dpt
        on op.payment_type = dpt.payment_type

    inner join DwOlist.dbo.Dim_Order do
        on do.bk_order_id = op.order_id

) as src
    on tgt.sk_order            = src.sk_order
    and tgt.payment_sequential = src.payment_sequential

when matched 
    and (
           tgt.sk_payment_type      is distinct from src.sk_payment_type
        or tgt.payment_installments is distinct from src.payment_installments
        or tgt.payment_value        is distinct from src.payment_value
    )
    then update set 
          tgt.sk_payment_type      = src.sk_payment_type
        , tgt.payment_installments = src.payment_installments
        , tgt.payment_value        = src.payment_value
when not matched then 
    insert (
          sk_order
        , sk_payment_type
        , payment_sequential
        , payment_installments
        , payment_value      
    )
    values(
          src.sk_order
        , src.sk_payment_type
        , src.payment_sequential
        , src.payment_installments
        , src.payment_value
    );