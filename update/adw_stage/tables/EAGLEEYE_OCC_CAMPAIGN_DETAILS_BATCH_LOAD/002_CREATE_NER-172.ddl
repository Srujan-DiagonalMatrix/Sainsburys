 /***********************************************************************************************************************************************
* Filename:  002_CREATE_NER-172.ddl
* Owner: Nectarine
* Author: Srujan K Alikanti
* Date: 05/01/2022
* Ticket Number: NER-172
* Description: Create - Added a STAGE table that holds Human readable records.
*************************************************************************************************************************************************/ 
USE ROLE RL_${ENV}_OBJECT_OWNER;

CREATE OR REPLACE TABLE "ADW_STAGE"."EAGLEEYE_OCC_CAMPAIGN_DETAILS_BATCH_LOAD" (
COUPON_ID VARCHAR,
COUPON_NAME VARCHAR,
COUPON_TAG VARCHAR,
PRINTER_MESSAGE VARCHAR,
SHORT_DESC VARCHAR,
LONG_DESC VARCHAR,
OFFER_EFFECTIVE_DATE VARCHAR,
OFFER_EXPIRATION_DATE VARCHAR,
REWARD_VALUE_FIXED VARCHAR,
COUPON_PRINT_START_DATE VARCHAR,
ACCOUNT_CODE VARCHAR,
COST_CENTRE VARCHAR,
EST_DIST_QUANTITY VARCHAR,
EST_REDEMPTION_RATE VARCHAR,
THRESHOLD VARCHAR,
VALIDATION_TYPE VARCHAR,
THRESHOLD_UNITS VARCHAR,
PROMO_ID VARCHAR,
REWARD_VALUE_POINTMULTI VARCHAR,
NECTAR_PRODUCT_RANGE VARCHAR,
REWARD_VALUE_MONEY VARCHAR,
LOYALTY_CARD_REQUIRED VARCHAR,
INSTORE VARCHAR,
GOL VARCHAR,
ROLLING_DAYS_VALIDITY VARCHAR,
PHOEBUS_CODE VARCHAR,
SUPPLIER_NAME VARCHAR,
OC_ID VARCHAR,
UNIT VARCHAR,
OWNER VARCHAR,
REWARD_TYPE VARCHAR,
BARCODE VARCHAR,
CREATEDATE VARCHAR,
STATUS VARCHAR,
BATCH_ID INT DEFAULT 0,
LOAD_DATE TIMESTAMP_NTZ default current_timestamp()
);
