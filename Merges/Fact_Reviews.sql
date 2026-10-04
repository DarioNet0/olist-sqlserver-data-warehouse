merge DwOlist.dbo.Fact_Reviews tgt
using (

select 
      do.sk_order       as sk_order
    , dr.sk_review      as sk_review
    , [or].review_score as review_score
from
    olist.order_reviews [or] 

    inner join DwOlist.dbo.Dim_Order do
        on [or].order_id = do.bk_order_id
    
    inner join DwOlist.dbo.Dim_Reviews dr
        on dr.bk_review_id = [or].review_id

) as src 
    on tgt.sk_review = src.sk_review

when matched and tgt.review_score is distinct from src.review_score
    then update set tgt.review_score = src.review_score

when not matched then 
    insert (
          sk_review
        , review_score       
    )
    values (
          src.sk_review
        , src.review_score
    );