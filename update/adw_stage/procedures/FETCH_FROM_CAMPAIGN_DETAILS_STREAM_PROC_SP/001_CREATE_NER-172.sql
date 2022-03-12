 /***********************************************************************************************************************************************
* Filename:  003_CREATE_NER-172.sql
* Owner: Nectarine
* Author: Srujan K Alikanti
* Date: 13/01/2022
* Ticket Number: NER-172
* Description: Create - fetch CSV data from S3 table EAGLEEYE_OCC_CAMPAIGN_DETAILS_BATCH_LOAD.
*************************************************************************************************************************************************/ 

CREATE or REPLACE PROCEDURE "ADW_STAGE"."FETCH_FROM_CAMPAIGN_DETAILS_STREAM_PROC_SP"()
    returns string
    language javascript
    comment =
    '
        procedure for adding records into table "ADW_STAGE"."EAGLEEYE_OCC_CAMPAIGN_DETAILS_BATCH_LOAD"
        Proc will be caled via TASK which will be running as per the schedule
        it will check for the new records added into the stream "ADW_STAGE"."EAGLEEYE_OCC_CAMPAIGN_DETAILS_STREAM
        if records are available then it will increment the batch load id by 1 and load the
        records into table "ADW_STAGE"."EAGLEEYE_OCC_CAMPAIGN_DETAILS_BATCH_LOAD".
    '
    as
    '
    try
    {
        //empty string for log message
        var v_log_msg = "";
		var v_sql_fetch_bat_id = `
							 SELECT COALESCE(MAX(BATCH_ID),0)+1 AS NXT_BATCH_ID
							  FROM "ADW_STAGE"."EAGLEEYE_OCC_CAMPAIGN_DETAILS_BATCH_LOAD";
							`;
		//execute select statement
		var SelStatement = snowflake.createStatement({ sqlText: v_sql_fetch_bat_id});
		var selRes = SelStatement.execute();
		//fetch the result set data record
		selRes.next();
		//variable to hold the next batch_id
		var v_batch_id = selRes.getColumnValue(1);
        //variable to hold the sql dml statement
        var insert_query=
        `
			COPY INTO "ADW_STAGE"."EAGLEEYE_OCC_CAMPAIGN_DETAILS_BATCH_LOAD"
				(
				  COUPON_ID,
				  COUPON_NAME,
				  COUPON_TAG,
				  PRINTER_MESSAGE,
				  SHORT_DESC,
				  LONG_DESC,
				  OFFER_EFFECTIVE_DATE,
				  OFFER_EXPIRATION_DATE,
				  REWARD_VALUE_FIXED,
				  COUPON_PRINT_START_DATE,
				  ACCOUNT_CODE,
				  COST_CENTRE,
				  EST_DIST_QUANTITY,
				  EST_REDEMPTION_RATE,
				  THRESHOLD,
				  VALIDATION_TYPE,
				  THRESHOLD_UNITS,
				  PROMO_ID,
				  REWARD_VALUE_POINTMULTI,
				  NECTAR_PRODUCT_RANGE,
				  REWARD_VALUE_MONEY,
				  LOYALTY_CARD_REQUIRED,
				  INSTORE,
				  GOL,
				  ROLLING_DAYS_VALIDITY,
				  PHOEBUS_CODE,
				  SUPPLIER_NAME,
				  OC_ID,
				  UNIT,
				  OWNER,
				  REWARD_TYPE,
				  BARCODE,
				  CREATEDATE,
				  STATUS,
				  BATCH_ID,
				  LOAD_DATE
				)
				FROM
				(
				  SELECT
					sn.$1,
					sn.$2,
					sn.$3,
					sn.$4,
					sn.$5,
					sn.$6,
					sn.$7,
					sn.$8,
					sn.$9,
					sn.$10,
					sn.$11,
					sn.$12,
					sn.$13,
					sn.$14,
					sn.$15,
					sn.$16,
					sn.$17,
					sn.$18,
					sn.$19,
					sn.$20,
					sn.$21,
					sn.$22,
					sn.$23,
					sn.$24,
					sn.$25,
					sn.$26,
					sn.$28,
					sn.$29,
					sn.$30,
					sn.$31,
					sn.$32,
					sn.$33,
					sn.$34,
					sn.$35,
					`+ v_batch_id
                    +`,
					current_timestamp()
				FROM
				  @STAGE_EAGLEYE_OCC_CAMPAIGN_DETAILS sn
				) `;
	//end of the stage copy dml into the load table
    //execute insert statement
    var Statement=snowflake.createStatement({ sqlText: insert_query});
    var result=Statement.execute();
    //number of records effectively added into the table
    var v_rowCnt = Statement.getNumRowsInserted();
    //add the success log
    //check if there is any record got added as part of operation then add logs
    if(v_rowCnt != 0)
    {
        //add log after addition of new records into table
        snowflake.createStatement( { sqlText: `call "ADW_STAGE"."ADD_LOG_SP"(:1,:2,:3)`, binds:[`INSERT RECORDS`,`INSERT JSON DATA INTO TABLE:"ADW_STAGE"."EAGLEEYE_OCC_CAMPAIGN_DETAILS_BATCH_LOAD", Total Records ingested : `+ v_rowCnt , `Success`] } ).execute() ;
    }
    else
    {
        //no new record is avilable for ingestation
        snowflake.createStatement( { sqlText: `call "ADW_STAGE"."ADD_LOG_SP"(:1,:2,:3)`, binds:[`INSERT RECORDS`,`No new JSON DATA avilable for ingesation into TABLE:"ADW_STAGE"."EAGLEEYE_OCC_CAMPAIGN_DETAILS_BATCH_LOAD", Total Records ingested : `+ v_rowCnt, `Success`] } ).execute() ;
    }
    }//try block ends
    catch(err)
    {
        v_log_msg = `Unable to add records into Table "ADW_STAGE"."EAGLEEYE_OCC_CAMPAIGN_DETAILS_BATCH_LOAD" Error code : ` + err.code;
		v_log_msg += `\n Message : ` + err.message;
		v_log_msg += `\n Stack Trace:\n` + err.stackTraceTxt;
        //add logf or failure
        snowflake.createStatement( { sqlText: `call "ADW_STAGE"."ADD_LOG_SP"(:1,:2,:3)`, binds:[`INSERT RECORDS`,v_log_msg, `Error`] } ).execute() ;
        //failure message returned to calling block
        throw err;
    }
    //final return statement of successful execution of procedure
    return v_rowCnt;
    ';