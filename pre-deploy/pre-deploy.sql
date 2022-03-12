/*****
Truncate & drop tables which are unwanted - ONE time
****/

USE ROLE RL_${ENV}_OBJECT_OWNER;

ALTER TABLE "ADW_${ENV}"."ADW_BDV"."OCC_BARCODE_CLASSIFICATION_BR" set CHANGE_TRACKING = TRUE;
ALTER TABLE "ADW_${ENV}"."ADW_RDV"."COUPON_OCCDTL_SAT" set CHANGE_TRACKING = TRUE;
