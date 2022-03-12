 /***********************************************************************************************************************************************
* Filename:  003_CREATE_NER-189.sql
* Owner: Nectarine
* Author: Srujan K Alikanti
* Date: 25/01/2022
* Ticket Number: NER-189
* Description: Create - Load & Merge SAT data into BDV classifications. 
*************************************************************************************************************************************************/

CREATE OR REPLACE PROCEDURE "ADW_BDV"."FETCH_FROM_OCCDTL_SAT_TO_LOAD_BARCODE_CLASS_PROC_SP"()
returns string
language javascript
comment =
    '
		Procedure for loading the RDV SAT records into BDV Classification data

		This needs to be executed post the data load into BDV table - "ADW_RDV"."COUPON_OCCDTL_SAT".
		Records having barcode_status as valid will be loaded.
		Load mechanism used is DELETE and then INSERT, meaning only latest records will be available post loading

		i/p table - "ADW_RDV"."COUPON_OCCDTL_SAT"  - > o/p	- "ADW_BDV"."OCC_BARCODE_CLASSIFICATION_BR"
	'
as
'
try
{
    //empty string intialization
    var v_log_msg ="";//hold error message concatenated string

    //variable to hold the constructed query for insert overwrite into table "ADW_BDV"."OCC_BARCODE_CLASSIFICATION_BR"
  	var ins_overwrite_into_barcode_class=
		`
		INSERT OVERWRITE INTO "ADW_BDV"."OCC_BARCODE_CLASSIFICATION_BR"
		(
			COUPON_NK1,
			COUPON_NK2,
			COUPON_NK3,
			COUPON_APPORTIONMENT,
			COUPON_VALUE_TYPE,
			COUPON_FUNDING_CLASSIFICATION,
			COUPON_ACCOUNT_CD,
			COUPON_COST_CENTRE_CD,
			COUPON_TAG_CD,
			COUPON_NAME,
			COUPON_EAGLEEYE_CAMPAIGN_CD,
			COUPON_PROMOTION_ID,
			COUPON_REDEMPTION_TYPE,
			COUPON_REWARD_TYPE_CD,
			COUPON_STATUS,
			COUPON_SUPPLIER_NAME,
			COUPON_START_DT,
			COUPON_END_DT,
			COUPON_PRINT_START_DT,
			TECHNICAL_METADATA
		)
		SELECT
			COUPON_NK1,
			COUPON_NK2,
			COUPON_NK3,
			CASE
               WHEN COUPON_TAG_CD=''Deposit_Return_Points'' THEN ''Deposit Return Points''
               WHEN COUPON_TAG_CD = ''DepositReturnTrial'' THEN ''Deposit Return Trial''
               WHEN COUPON_ACCOUNT_CD = ''35040'' THEN ''Basket''
               WHEN COUPON_REDEMPTION_TYPE=''5. Basket Value'' OR COUPON_REWARD_TYPE_CD=''pointsMultiplier'' AND COUPON_TAG_CD !=''Deposit_Return_Points''THEN ''Basket''
               WHEN COUPON_REDEMPTION_TYPE IN (''1. Item Quantity'',''3. Value of Qualifying Items'') AND COUPON_TAG_CD !=''Deposit_Return_Points'' THEN ''Product''
               ELSE ''Unknown''
			END AS COUPON_APPORTIONMENT,
			CASE
                WHEN COUPON_NK1 IN(''9924959239995'',''9924959239996'') THEN ''Christmas Food to Order''
                WHEN COUPON_REWARD_TYPE_CD IN (''supplierMoneyOff'',''supplierFixedPoints'') THEN ''Tender''
                WHEN COUPON_REWARD_TYPE_CD IN (''pointsFixed'',''moneyOff'') AND COUPON_ACCOUNT_CD=''48030'' THEN ''Deposit Return''
                WHEN COUPON_ACCOUNT_CD = ''35040'' THEN ''Car Park ticket''
                WHEN COUPON_REWARD_TYPE_CD =''moneyOff'' AND COUPON_ACCOUNT_CD NOT IN (''48030'',''35040'') AND substr(COUPON_NK1,1,6) NOT BETWEEN ''993014'' AND ''993023'' THEN ''Marketing Discount Product OR Basket''
                WHEN COUPON_REWARD_TYPE_CD IN (''pointsFixed'',''pointsMultiplier'') AND COUPON_ACCOUNT_CD not in (''48030'') THEN ''Nectar Points Issuance Discount''
                WHEN substr(COUPON_NK1,1,6) BETWEEN ''993014'' AND ''993023'' THEN ''Nectar Price Refund''
                ELSE ''Unknown''
                END AS COUPON_VALUE_TYPE,
			CASE
			    WHEN COUPON_REWARD_TYPE_CD IN (''supplierMoneyOff'',''supplierFixedPoints'') THEN ''Supplier''
                WHEN COUPON_REWARD_TYPE_CD IN (''pointsFixed'',''moneyOff'',''pointsMultiplier'') OR COUPON_TAG_CD IN (''Deposit_Return_Points'',''DepositReturnTrial'') THEN ''Sainsburys''
                ELSE ''Unknown''
                END AS COUPON_FUNDING_CLASSIFICATION,
			COUPON_ACCOUNT_CD,
			COUPON_COST_CENTRE_CD,
			COUPON_TAG_CD,
			COUPON_NAME,
			COUPON_EAGLEEYE_CAMPAIGN_ID,
			COUPON_PROMOTION_ID,
			COUPON_REDEMPTION_TYPE,
			COUPON_REWARD_TYPE_CD,
			COUPON_STATUS_CD,
			COUPON_SUPPLIER_NAME,
			COUPON_START_DT,
			COUPON_END_DT,
			COUPON_PRINT_START_DT,
			PARSE_JSON(
				''{
				"EFFECTIVE_FROM_TS": "''||CURRENT_TIMESTAMP||''",
				"ETL_FRAMEWORK": "integration NECTARINE_${ENV}",
				"FUNCTIONAL_COMPONENT": "https://github.com/JSainsburyPLC/aspire-snowflake-deployment-finance-nectarine",
				"HASH_DIFF": "''||HASH_DIFF||''",
				"JOB_NAME": "rdv_coupon_occdtl_sat_to_bdv_occ_barcode_classification_br",
				"LOAD_TS": "''||CURRENT_TIMESTAMP||''",
				"REASON_CD": "",
				"RECORD_DELETED_FLAG": "",
				"RECORD_ID": "",
				"SOURCE_PATH": "s3://${S3_ENV}-raw-src-eagleeye/coupondetails/data/",
				"SOURCE_SYSTEM_CD": "OCCDTL"
				}''
			)
		FROM "ADW_RDV"."COUPON_OCCDTL_SAT"
		WHERE BARCODE_STATUS = ''valid''
    	`;

	//execute the statment for delete insert
	var stmt=snowflake.createStatement({ sqlText: ins_overwrite_into_barcode_class});

	var v_resExec  = stmt.execute();

    //number of records effectively added into the table
	var v_rowCnt = stmt.getNumRowsInserted();

	//add success log entry into pipeline table
    snowflake.createStatement( { sqlText: `call "ADW_STAGE"."ADD_LOG_SP"(:1,:2,:3)`, binds:[`INSERT RECORDS`,`INSERT DATA INTO TABLE: "ADW_BDV"."OCC_BARCODE_CLASSIFICATION_BR", Total Records inserted : ` + v_rowCnt , `Success`] } ).execute();
}//try block ends
catch(err)
{
	v_log_msg = `Unable to add records into Table "ADW_BDV"."OCC_BARCODE_CLASSIFICATION_BR" Error code : ` + err.code;
	v_log_msg += `\n Message : ` + err.message;
	v_log_msg += `\n Stack Trace:\n` + err.stackTraceTxt;

	//add error log entry
	snowflake.createStatement( { sqlText: `call "ADW_STAGE"."ADD_LOG_SP"(:1,:2,:3)`, binds:[`INSERT RECORDS`, v_log_msg , `Error`] } ).execute();

	throw err;
}

 return v_rowCnt;
 ';
