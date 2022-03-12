
 /***********************************************************************************************************************************************
* Filename:  002_CREATE_NER-172.ddl
* Owner: Nectarine
* Author: Srujan K Alikanti
* Date: 05/01/2022
* Ticket Number: NER-172
* Description: Create - Added a ADW_PRODUCT_TRAN table that fetches delta records only.
*************************************************************************************************************************************************/ 
 USE ROLE RL_${ENV}_OBJECT_OWNER;
 
 CREATE OR REPLACE VIEW "ADW_PRODUCT_TRAN"."FINANCE_OCCDTL_VW" as 
 select 
  COUPON_ID::NUMERIC as COUPON_ID,
  COUPON_NAME::varchar(50) as COUPON_NAME ,
  COUPON_TAG::varchar(250) as COUPON_TAG,
  PRINTER_MESSAGE::varchar(50) as PRINTER_MESSAGE ,
  SHORT_DESC::varchar(30) as SHORT_DESC  ,
  LONG_DESC::varchar(50) as LONG_DESC,
  to_timestamp(OFFER_EFFECTIVE_DATE,'dd/MM/yyyy HH:MI') as OFFER_EFFECTIVE_DATE,
  to_timestamp(OFFER_EXPIRATION_DATE,'dd/MM/yyyy HH:MI') as OFFER_EXPIRATION_DATE,
  REWARD_VALUE_FIXED::NUMERIC as REWARD_VALUE_FIXED,
  to_date(COUPON_PRINT_START_DATE,'dd/MM/yyyy') as COUPON_PRINT_START_DATE,
  ACCOUNT_CODE::varchar(5) as ACCOUNT_CODE,
  COST_CENTRE::varchar(5) as COST_CENTRE,
  EST_DIST_QUANTITY::NUMERIC as EST_DIST_QUANTITY,
  EST_REDEMPTION_RATE::NUMERIC as EST_REDEMPTION_RATE,
  THRESHOLD::NUMERIC as THRESHOLD,
  VALIDATION_TYPE::varchar(50) as VALIDATION_TYPE,
  THRESHOLD_UNITS::NUMERIC as THRESHOLD_UNITS,
  PROMO_ID::NUMERIC as PROMO_ID,
  REWARD_VALUE_POINTMULTI::NUMERIC as REWARD_VALUE_POINTMULTI,
  NECTAR_PRODUCT_RANGE::varchar(2) as NECTAR_PRODUCT_RANGE,
  REWARD_VALUE_MONEY::NUMERIC(7,2) as REWARD_VALUE_MONEY,
  LOYALTY_CARD_REQUIRED::varchar(3) as LOYALTY_CARD_REQUIRED,
  INSTORE::varchar(3) as INSTORE,
  GOL::varchar(3) as GOL,
  ROLLING_DAYS_VALIDITY::NUMERIC as ROLLING_DAYS_VALIDITY,
  PHOEBUS_CODE::NUMERIC as PHOEBUS_CODE,
  SUPPLIER_NAME::varchar(30) as SUPPLIER_NAME,
  OC_ID::NUMERIC as OC_ID,
  UNIT,
  OWNER::varchar(50) as OWNER,
  REWARD_TYPE::varchar(50) as REWARD_TYPE,
  BARCODE::NUMERIC as BARCODE,
  to_timestamp(CREATEDATE,'dd/MM/yyyy HH:MI') as CREATEDATE,
  STATUS::varchar(10) as STATUS,
  BATCH_ID
  from "ADW_STAGE"."EAGLEEYE_OCC_CAMPAIGN_DETAILS_BATCH_LOAD"
  having BATCH_ID=(select max(BATCH_ID) from "ADW_STAGE"."EAGLEEYE_OCC_CAMPAIGN_DETAILS_BATCH_LOAD"); 
