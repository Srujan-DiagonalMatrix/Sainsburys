/************************************************************************************************************************************************
* Filename:  001_CREATE_NER-172.ddl
* Owner: Nectarine
* Author: Srujan K Alikanti
* Date: 11/01/2022
* Ticket Number: NER-172
* Description: Create DDL for occ_barcode_classification_br.
*************************************************************************************************************************************************/ 
USE ROLE RL_${ENV}_OBJECT_OWNER;

CREATE OR REPLACE TABLE "ADW_BDV"."OCC_BARCODE_CLASSIFICATION_BR"
(
    "COUPON_NK1" varchar(128) not null
    , "COUPON_NK2" varchar(128) not null
    , "COUPON_NK3" varchar(128) not null
    , "COUPON_APPORTIONMENT" varchar(50) not null
    , "COUPON_VALUE_TYPE" varchar(50) not null
    , "COUPON_FUNDING_CLASSIFICATION" varchar(20) not null
    , "COUPON_ACCOUNT_CD" varchar(20)
    , "COUPON_COST_CENTRE_CD" varchar(20)
    , "COUPON_TAG_CD" varchar(250)
    , "COUPON_NAME" varchar(50)
    , "COUPON_EAGLEEYE_CAMPAIGN_CD" varchar(50)
    , "COUPON_PROMOTION_ID" numeric(38)
    , "COUPON_REDEMPTION_TYPE" varchar(50)
    , "COUPON_REWARD_TYPE_CD" varchar(50)
    , "COUPON_STATUS" varchar(50)
    , "COUPON_SUPPLIER_NAME" varchar(50)
    , "COUPON_START_DT" timestamp_ntz(9)
    , "COUPON_END_DT" timestamp_ntz(9)
    , "COUPON_PRINT_START_DT" timestamp_ntz(9)
    , "TECHNICAL_METADATA" VARIANT not null
);

COMMENT ON TABLE "ADW_BDV"."OCC_BARCODE_CLASSIFICATION_BR"
IS 'Eagleeye Campaign data';

COMMENT ON COLUMN "ADW_BDV"."OCC_BARCODE_CLASSIFICATION_BR"."COUPON_APPORTIONMENT"
IS 'case 
           when COUPON_TAG_CD=''Deposit_Return_Points'' then ''Deposit Return Points''
           when COUPON_TAG_CD = ''DepositReturnTrial'' then ''Deposit Return Trial''
           when COUPON_ACCOUNT_CD = ''35040'' then ''Basket''
           when COUPON_REDEMPTION_TYPE=''5. Basket Value'' OR COUPON_REWARD_TYPE_CD=''pointsMultiplier'' and COUPON_TAG_CD !=''Deposit_Return_Points''then ''Basket''
           when COUPON_REDEMPTION_TYPE IN (''1. Item Quantity'',''3. Value of Qualifying Items'') and COUPON_TAG_CD !=''Deposit_Return_Points'' then ''Product''
           else ''Unknown''
       end  as COUPON_APPORTIONMENT';

COMMENT ON COLUMN "ADW_BDV"."OCC_BARCODE_CLASSIFICATION_BR"."COUPON_VALUE_TYPE"
IS 'case
when COUPON_NK1 IN(''9924959239995'',''9924959239996'') then ''Christmas Food to Order''
when COUPON_REWARD_TYPE_CD IN (''supplierMoneyOff'',''supplierFixedPoints'') then ''Tender''
when COUPON_REWARD_TYPE_CD IN (''pointsFixed'',''moneyOff'') and COUPON_ACCOUNT_CD=''48030'' then ''Deposit Return''
when COUPON_ACCOUNT_CD = ''35040'' then ''Car Park ticket''
when COUPON_REWARD_TYPE_CD =''moneyOff'' and COUPON_ACCOUNT_CD not in (''48030'',''35040'') and substr(COUPON_NK1,1,6) not between ''993014'' and ''993023'' then ''Marketing Discount Product or Basket''
when COUPON_REWARD_TYPE_CD IN (''pointsFixed'',''pointsMultiplier'') and COUPON_ACCOUNT_CD not in (''48030'') then ''Nectar Points Issuance Discount''
when substr(COUPON_NK1,1,6) between ''993014'' and ''993023'' then ''Nectar Price Refund''
else ''Unknown''
end as COUPON_VALUE_TYPE';

COMMENT ON COLUMN "ADW_BDV"."OCC_BARCODE_CLASSIFICATION_BR"."COUPON_FUNDING_CLASSIFICATION"
IS 'case 
    when COUPON_REWARD_TYPE_CD IN (''supplierMoneyOff'',''supplierFixedPoints'') then ''Supplier''
    when COUPON_REWARD_TYPE_CD IN (''pointsFixed'',''moneyOff'',''pointsMultiplier'') OR COUPON_TAG_CD IN (''Deposit_Return_Points'',''DepositReturnTrial'') then ''Sainsburys'' 
         else ''Unknown''
       end  as COUPON_FUNDING_CLASSIFICATION';

COMMENT ON COLUMN "ADW_BDV"."OCC_BARCODE_CLASSIFICATION_BR"."COUPON_ACCOUNT_CD"
IS 'Account codes represent the subsection cost centre in the general ledger - more granular than the GL';

COMMENT ON COLUMN "ADW_BDV"."OCC_BARCODE_CLASSIFICATION_BR"."COUPON_COST_CENTRE_CD"
IS 'Business cost centre funding the campaign';

COMMENT ON COLUMN "ADW_BDV"."OCC_BARCODE_CLASSIFICATION_BR"."COUPON_TAG_CD"
IS 'A tag used to identify a related group of campaigns e.g. "Deposit_Return_Points" is used to tag approximately 50 return deposit coupons';

COMMENT ON COLUMN "ADW_BDV"."OCC_BARCODE_CLASSIFICATION_BR"."COUPON_NAME"
IS 'Name of the campaign';

COMMENT ON COLUMN "ADW_BDV"."OCC_BARCODE_CLASSIFICATION_BR"."COUPON_EAGLEEYE_CAMPAIGN_CD"
IS 'Sequential 6 digit number which eagle eye applies to a campaign';

COMMENT ON COLUMN "ADW_BDV"."OCC_BARCODE_CLASSIFICATION_BR"."COUPON_PROMOTION_ID"
IS 'Promotional ID - we need to understand if this is used from other systems or is set by Eagle Eye, or campaign operations';

COMMENT ON COLUMN "ADW_BDV"."OCC_BARCODE_CLASSIFICATION_BR"."COUPON_REDEMPTION_TYPE"
IS 'Sets the qualifying logic for the campaign to a quantity of items, the value of qualifying items, or the value of a basket';

COMMENT ON COLUMN "ADW_BDV"."OCC_BARCODE_CLASSIFICATION_BR"."COUPON_REWARD_TYPE_CD"
IS 'Determines the type of reward for the campaign';

COMMENT ON COLUMN "ADW_BDV"."OCC_BARCODE_CLASSIFICATION_BR"."COUPON_STATUS"
IS 'ACTIVE = campaign is live
READY = campaign is approve to go-live but is not yet live
NULL = campaign is not approved';

COMMENT ON COLUMN "ADW_BDV"."OCC_BARCODE_CLASSIFICATION_BR"."COUPON_SUPPLIER_NAME"
IS 'Name of supplier for supplier funded campaigns';

COMMENT ON COLUMN "ADW_BDV"."OCC_BARCODE_CLASSIFICATION_BR"."COUPON_START_DT"
IS 'Date the campaign offer will be active from';

COMMENT ON COLUMN "ADW_BDV"."OCC_BARCODE_CLASSIFICATION_BR"."COUPON_END_DT"
IS 'Date the campaign offer will expire';

COMMENT ON COLUMN "ADW_BDV"."OCC_BARCODE_CLASSIFICATION_BR"."COUPON_PRINT_START_DT"
IS 'Date the coupons should start to be printed at the tills via Catalina';

COMMENT ON COLUMN "ADW_BDV"."OCC_BARCODE_CLASSIFICATION_BR"."TECHNICAL_METADATA"
IS 'A JSON message of support fields. See Aspire modelling standards. Can be any of these:  EFFECTIVE_FROM_TS, ETL_FRAMEWORK, FUNCTIONAL_COMPONENT, HASH_DIFF, JOB_NAME, LOAD_TS, REASON_CD, RECORD_DELETED_FLAG, RECORD_ID, SOURCE_PATH, SOURCE_SYSTEM_CD';

