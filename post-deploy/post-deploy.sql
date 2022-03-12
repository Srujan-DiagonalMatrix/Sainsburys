SELECT count(1) FROM "ADW_STAGE"."EAGLEEYE_OCC_CAMPAIGN_DETAILS";
SELECT count(1) FROM "ADW_STAGE"."EAGLEEYE_OCC_CAMPAIGN_DETAILS_BATCH_LOAD";
SELECT count(1) FROM "ADW_PRODUCT_TRAN"."FINANCE_OCCDTL_VW";
SELECT count(1) FROM "ADW_RDV"."COUPON_HUB";
SELECT count(1) FROM "ADW_RDV"."COUPON_OCCDTL_SAT";
SELECT count(1) FROM "ADW_BDV"."OCC_BARCODE_CLASSIFICATION_BR";
SELECT count(1) FROM "ADW_STAGE"."EAGLEEYE_OCC_CAMPAIGN_DETAILS";

SHOW PROCEDURES LIKE 'CAMPAIGN_DETAILS_STREAM';
SHOW PROCEDURES LIKE 'FETCH_FROM_CAMPAIGN_DETAILS_STREAM_PROC';
SHOW PROCEDURES LIKE 'FETCH_FROM_FINANCE_OCCDTL_VW';
SHOW PROCEDURES LIKE 'FETCH_FROM_OCCDTL_SAT_TO_LOAD_BARCODE_CLASS_PROC';

SHOW TASKS LIKE 'FETCH_FROM_CAMPAIGN_DETAILS_STREAM_TASK';
SHOW TASKS LIKE 'FETCH_FROM_FINANCE_OCCDTL_VW_TASK';
SHOW TASKS LIKE 'FETCH_FROM_OCCDTL_SAT_TO_LOAD_BARCODE_CLASS_TASK';
