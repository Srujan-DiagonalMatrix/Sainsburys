/***********************************************************************************************************************************************
* Filename:  001_CREATE_NER-172.ddl
* Owner: Nectarine
* Author: Srujan K Alikanti
* Date: 18/01/2022
* Ticket Number: NER-172
* Description: Create - Added a RDV table that holds satallite datasets.
*************************************************************************************************************************************************/ 
USE ROLE RL_${ENV}_OBJECT_OWNER;

CREATE OR REPLACE TABLE "ADW_RDV"."COUPON_OCCDTL_SAT"(
    "COUPON_NK1" varchar(128) not null unique
    , "COUPON_NK2" varchar(128) not null unique
    , "COUPON_NK3" varchar(128) not null unique
    , "LOAD_TS" timestamp_ntz(9) not null unique
    , "COUPON_NAME" varchar(50)
    , "COUPON_TAG_CD" varchar(250)
    , "COUPON_PRINTER_MESSAGE_TEXT" varchar(50)
    , "COUPON_SHORT_DESC" varchar(255)
    , "COUPON_LONG_DESC" varchar(255)
    , "COUPON_START_DT" timestamp_ntz(9)
    , "COUPON_END_DT" timestamp_ntz(9)
    , "COUPON_REWARD_VALUE_NECTAR_PTS" varchar(50)
    , "COUPON_PRINT_START_DT" timestamp_ntz(9)
    , "COUPON_ACCOUNT_CD" varchar(20)
    , "COUPON_COST_CENTRE_CD" varchar(20)
    , "COUPON_ESTIMATED_QTY" numeric(38)
    , "COUPON_ESTIMATED_REDEMPTION_QTY" numeric(38)
    , "COUPON_THRESHOLD_NUM" numeric(7,2)
    , "COUPON_REDEMPTION_TYPE" varchar(50)
    , "COUPON_THRESHOLD_UNITS" numeric(38)
    , "COUPON_PROMOTION_ID" numeric(38)
    , "COUPON_REWARD_POINTS_MULTIPLIER_NUM" numeric(38)
    , "NECTAR_PRODUCT_RANGE_CD" varchar(100)
    , "COUPON_REWARD_VALUE_AMT" numeric(7,2)
    , "LOYALTY_CARD_REQUIRED_IND" varchar(3)
    , "COUPON_INSTORE_IND" varchar(3)
    , "COUPON_ONLINE_ORDER_IND" varchar(3)
    , "COUPON_ROLLING_VALIDITY_DAYS_NUM" numeric(38)
    , "COUPON_PHOEBUS_CD" numeric(38)
    , "COUPON_SUPPLIER_NAME" varchar(50)
    , "COUPON_EAGLEEYE_CAMPAIGN_ID" varchar(50)
    , "COUPON_STORE_UNIT_CD" varchar(100)
    , "COUPON_OWNER_CD" varchar(50)
    , "COUPON_REWARD_TYPE_CD" varchar(50)
    , "COUPON_CREATE_DT" timestamp_ntz(9)
    , "COUPON_STATUS_CD" varchar(50)
    , "HASH_DIFF" varchar(32)
    , "SOURCE_SYSTEM_CD" varchar(6) not null
    , "BARCODE_STATUS" varchar(10)
    , "TECHNICAL_METADATA" variant not null
    , PRIMARY KEY ("COUPON_NK1", "COUPON_NK2", "COUPON_NK3", "LOAD_TS")
);

COMMENT ON TABLE "ADW_RDV"."COUPON_OCCDTL_SAT"
IS 'Definition:-

Historised reference data about a Coupon from a EGEDET source system as defined in the Source System Code.

Remarks:-';

COMMENT ON COLUMN "ADW_RDV"."COUPON_OCCDTL_SAT"."COUPON_NK1"
IS 'Definition : The Barcode. industry GS1 standard barcode which will be printed on the voucher
Remarks :
Prefixes can determine the type of voucher
"28" - fixed points voucher
"29" - points multiplier voucher
"99" - money off voucher (follows GS1 standards)';

COMMENT ON COLUMN "ADW_RDV"."COUPON_OCCDTL_SAT"."COUPON_NK2"
IS 'Definition : The Barcode. industry GS1 standard barcode which will be printed on the voucher
Remarks :';

COMMENT ON COLUMN "ADW_RDV"."COUPON_OCCDTL_SAT"."COUPON_NK3"
IS 'Third part of the Natural Key of the Hub entry.';

COMMENT ON COLUMN "ADW_RDV"."COUPON_OCCDTL_SAT"."COUPON_NAME"
IS 'Name of the campaign';

COMMENT ON COLUMN "ADW_RDV"."COUPON_OCCDTL_SAT"."COUPON_TAG_CD"
IS 'A tag used to identify a related group of campaigns e.g. "Deposit_Return_Points" is used to tag approximately 50 return deposit coupons';

COMMENT ON COLUMN "ADW_RDV"."COUPON_OCCDTL_SAT"."COUPON_PRINTER_MESSAGE_TEXT"
IS 'The message which will be printed out at the till on issuance of the voucher';

COMMENT ON COLUMN "ADW_RDV"."COUPON_OCCDTL_SAT"."COUPON_SHORT_DESC"
IS 'The message which will be printed out at the till on issuance of the voucher';

COMMENT ON COLUMN "ADW_RDV"."COUPON_OCCDTL_SAT"."COUPON_LONG_DESC"
IS 'Long description of campaign (usually the same as short description)';

COMMENT ON COLUMN "ADW_RDV"."COUPON_OCCDTL_SAT"."COUPON_START_DT"
IS 'Date the campaign offer will be active from';

COMMENT ON COLUMN "ADW_RDV"."COUPON_OCCDTL_SAT"."COUPON_END_DT"
IS 'Date the campaign offer will expire';

COMMENT ON COLUMN "ADW_RDV"."COUPON_OCCDTL_SAT"."COUPON_REWARD_VALUE_NECTAR_PTS"
IS 'Defined the number of nectar points awarded for points campaigns';

COMMENT ON COLUMN "ADW_RDV"."COUPON_OCCDTL_SAT"."COUPON_PRINT_START_DT"
IS 'Date the coupons should start to be printed at the tills via Catalina';

COMMENT ON COLUMN "ADW_RDV"."COUPON_OCCDTL_SAT"."COUPON_ACCOUNT_CD"
IS 'Account codes represent the subsection cost centre in the general ledger - more granular than the GL';

COMMENT ON COLUMN "ADW_RDV"."COUPON_OCCDTL_SAT"."COUPON_COST_CENTRE_CD"
IS 'Business cost centre funding the campaign';

COMMENT ON COLUMN "ADW_RDV"."COUPON_OCCDTL_SAT"."COUPON_ESTIMATED_QTY"
IS 'Estimate of the number of campaign coupons we expect to be issued';

COMMENT ON COLUMN "ADW_RDV"."COUPON_OCCDTL_SAT"."COUPON_ESTIMATED_REDEMPTION_QTY"
IS 'Estimate of the number of campaign coupons we expect to be redeemed';

COMMENT ON COLUMN "ADW_RDV"."COUPON_OCCDTL_SAT"."COUPON_THRESHOLD_NUM"
IS 'Basket spend or item number threshold required for trigger the coupon.';

COMMENT ON COLUMN "ADW_RDV"."COUPON_OCCDTL_SAT"."COUPON_REDEMPTION_TYPE"
IS 'How coupon validated, can be either:
1. Item Quantity
3. Value of Qualifying Items
5. Basket Value';

COMMENT ON COLUMN "ADW_RDV"."COUPON_OCCDTL_SAT"."COUPON_THRESHOLD_UNITS"
IS 'Sets the qualifying number of units for the campaign.';

COMMENT ON COLUMN "ADW_RDV"."COUPON_OCCDTL_SAT"."COUPON_PROMOTION_ID"
IS 'Promotional ID - we need to understand if this is used from other systems or is set by Eagle Eye, or campaign operations';

COMMENT ON COLUMN "ADW_RDV"."COUPON_OCCDTL_SAT"."COUPON_REWARD_POINTS_MULTIPLIER_NUM"
IS 'For point multiplier campaigns - sets the multiplier i.e. 3x points - always for entire basket';

COMMENT ON COLUMN "ADW_RDV"."COUPON_OCCDTL_SAT"."NECTAR_PRODUCT_RANGE_CD"
IS 'Only applicable to points multiplier
01 - goods
02- fuel
03- goods or fuel';

COMMENT ON COLUMN "ADW_RDV"."COUPON_OCCDTL_SAT"."COUPON_REWARD_VALUE_AMT"
IS 'For monetary rewards sets the value of the reward in pounds and pence';

COMMENT ON COLUMN "ADW_RDV"."COUPON_OCCDTL_SAT"."LOYALTY_CARD_REQUIRED_IND"
IS 'Determines if the campaign requires a nectar loyalty card swipe to be valid';

COMMENT ON COLUMN "ADW_RDV"."COUPON_OCCDTL_SAT"."COUPON_INSTORE_IND"
IS 'Flag for in campaigns valid in-store';

COMMENT ON COLUMN "ADW_RDV"."COUPON_OCCDTL_SAT"."COUPON_ONLINE_ORDER_IND"
IS 'Flag for campaigns valid for Groceries On Line';

COMMENT ON COLUMN "ADW_RDV"."COUPON_OCCDTL_SAT"."COUPON_ROLLING_VALIDITY_DAYS_NUM"
IS 'For campaigns which coupons are valid for a number of days after they are issued to the customer, sets the number of days valid i.e. Save £5 on soap if used in the next 14 days.';

COMMENT ON COLUMN "ADW_RDV"."COUPON_OCCDTL_SAT"."COUPON_PHOEBUS_CD"
IS 'Supplier identifier for when the data gets exported to Vallasys
This is a Vallasys system.';

COMMENT ON COLUMN "ADW_RDV"."COUPON_OCCDTL_SAT"."COUPON_SUPPLIER_NAME"
IS 'Contact of the campaign owner including external suppliers';

COMMENT ON COLUMN "ADW_RDV"."COUPON_OCCDTL_SAT"."COUPON_EAGLEEYE_CAMPAIGN_ID"
IS 'Sequential 6 digit number which eagle eye applies to a campaign_id';

COMMENT ON COLUMN "ADW_RDV"."COUPON_OCCDTL_SAT"."COUPON_STORE_UNIT_CD"
IS 'Name of supplier for supplier funded campaigns';

COMMENT ON COLUMN "ADW_RDV"."COUPON_OCCDTL_SAT"."COUPON_OWNER_CD"
IS 'Login who created the coupon';

COMMENT ON COLUMN "ADW_RDV"."COUPON_OCCDTL_SAT"."COUPON_REWARD_TYPE_CD"
IS 'Identifies the type of coupon, the currently supported types in the Eagle Eye dashboard are:
pointsFixed
moneyOff
pointsMultiplier
supplierFixedPoints
supplierMoneyOff';

COMMENT ON COLUMN "ADW_RDV"."COUPON_OCCDTL_SAT"."COUPON_CREATE_DT"
IS 'Date/Time the coupon was created i
Format is dd/mm/yyyy hh:mm:ss';

COMMENT ON COLUMN "ADW_RDV"."COUPON_OCCDTL_SAT"."COUPON_STATUS_CD"
IS 'ACTIVE = campaign is live
READY = campaign is approve to go-live but is not yet live
NULL = campaign is not approved';

COMMENT ON COLUMN "ADW_RDV"."COUPON_OCCDTL_SAT"."HASH_DIFF"
IS 'This is used to compare the records for Change data capture within the ETL process.';

COMMENT ON COLUMN "ADW_RDV"."COUPON_OCCDTL_SAT"."SOURCE_SYSTEM_CD"
IS 'Identifier short code to denote the source system.';

COMMENT ON COLUMN "ADW_RDV"."COUPON_OCCDTL_SAT"."BARCODE_STATUS"
IS 'ETL Genereted Active / InActive';

COMMENT ON COLUMN "ADW_RDV"."COUPON_OCCDTL_SAT"."TECHNICAL_METADATA"
IS 'A JSON message of support fields. See Aspire modelling standards. Can be any of these:  EFFECTIVE_FROM_TS, ETL_FRAMEWORK, FUNCTIONAL_COMPONENT, HASH_DIFF, JOB_NAME, LOAD_TS, REASON_CD, RECORD_DELETED_FLAG, RECORD_ID, SOURCE_PATH, SOURCE_SYSTEM_CD';
