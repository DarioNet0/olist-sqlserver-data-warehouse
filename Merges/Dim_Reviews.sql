merge DwOlist.dbo.Dim_Reviews as tgt 
using (

select 
      review_id                                         as bk_review_id
    , isnull(review_comment_title, 'Not provided')      as review_comment_title      
    , isnull(review_content_message, 'Not provided')    as review_content_message
    , isnull(review_creation_date,  '1900-01-01')       as review_creation_date
    , isnull(review_answer_timestamp, '1900-01-01')     as review_answer_timestamp
    , isnull(review_score, -1)                          as review_score
from 
    olist.order_reviews 

) as src 
    on tgt.bk_review_id = src.bk_review_id

when 
    matched 
    and (
           tgt.review_comment_title    <> src.review_comment_title
        or tgt.review_content_message  <> src.review_content_message
        or tgt.review_creation_date    <> src.review_creation_date
        or tgt.review_answer_timestamp <> src.review_answer_timestamp
        or tgt.review_score            <> src.review_score
    ) 

    then update set 
          tgt.review_comment_title    = src.review_comment_title
        , tgt.review_content_message  = src.review_content_message
        , tgt.review_creation_date    = src.review_creation_date
        , tgt.review_answer_timestamp = src.review_answer_timestamp
        , tgt.review_score            = src.review_score    

when not matched then 
    insert (
          bk_review_id
        , review_comment_title
        , review_content_message
        , review_creation_date
        , review_answer_timestamp
        , review_score
    )
    values(
          src.bk_review_id
        , src.review_comment_title
        , src.review_content_message
        , src.review_creation_date
        , src.review_answer_timestamp
        , src.review_score
    );

