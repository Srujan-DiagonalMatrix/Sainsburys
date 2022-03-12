-- truncate all tables ----------
truncate "SCRATCH"."WORKSPACE"."COUPON_OCCDTL_SAT";
truncate "SCRATCH"."WORKSPACE"."COUPON_HUB";
truncate  "SCRATCH"."WORKSPACE"."EAGLEEYE_OCC_CAMPAIGN_DETAILS_BATCH_LOAD";
truncate  "SCRATCH"."WORKSPACE"."EAGLEEYE_OCC_CAMPAIGN_DETAILS";    
truncate  "SCRATCH"."WORKSPACE"."OCC_BARCODE_CLASSIFICATION_BR";

----- insert 50 records ---------
insert into "SCRATCH"."WORKSPACE"."EAGLEEYE_OCC_CAMPAIGN_DETAILS"  
select * from  "SCRATCH"."WORKSPACE"."EAGLEEYE_OCC_CAMPAIGN_DETAILS_TEMP" LIMIT 50;

---- check the status -----------       
select * from  "SCRATCH"."WORKSPACE"."EAGLEEYE_OCC_CAMPAIGN_DETAILS";
select * from "SCRATCH"."WORKSPACE"."EAGLEEYE_OCC_CAMPAIGN_DETAILS_STREAM";
select * from "SCRATCH"."WORKSPACE"."EAGLEEYE_OCC_CAMPAIGN_DETAILS_BATCH_LOAD";
select  * from "SCRATCH"."WORKSPACE"."FINANCE_OCCDTL_VW";
select * from "SCRATCH"."WORKSPACE"."COUPON_OCCDTL_SAT";
select * from "SCRATCH"."WORKSPACE"."COUPON_HUB";
select * from "SCRATCH"."WORKSPACE"."OCC_BARCODE_CLASSIFICATION_BR";

