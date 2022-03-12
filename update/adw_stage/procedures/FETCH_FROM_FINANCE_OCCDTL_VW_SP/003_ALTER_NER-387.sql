 /***********************************************************************************************************************************************
* Filename:  003_ALTER_NER-387.sql
* Owner: Nectarine
* Author: Srujan K Alikanti
* Date: 09/03/2022
* Ticket Number: NER-387
* Description: Create - fetch from a view FETCH_FROM_FINANCE_OCCDTL_VW & insert into HUB/SAT
*************************************************************************************************************************************************/ 

USE ROLE RL_${ENV}_NECTARINE_ETL;

CREATE or REPLACE PROCEDURE "ADW_PRODUCT_TRAN"."FETCH_FROM_FINANCE_OCCDTL_VW_SP"()
    returns string
    language javascript
	comment =
		'
			procedure is to Merge records into tables "ADW_RDV"."COUPON_HUB" and "ADW_RDV"."COUPON_OCCDTL_SAT"
			any not exisitng records synced from view "ADW_STAGE"."FINANCE_OCCDTL_VW"will be added to those tables.
		'
    as
    '
	try{

        //empty string for holding the concatenated err message
        var v_log_msg ="";

        //holds table name which is being updated
		var v_tbl_nm  ="";

		//variable to hold the number of records added as part of execution of DMLs
		v_rowInsCnt ="";
		v_rowCnt    ="";
        v_rowUpdCnt ="";

		//variable to hold sql statement into "ADW_RDV"."COUPON_HUB"
		var insert_into_COUPON_HUB =
		`merge into "ADW_RDV"."COUPON_HUB" T1
		using "ADW_PRODUCT_TRAN"."FINANCE_OCCDTL_VW" T2
		ON T1.COUPON_NK1=T2.BARCODE
		when not matched then insert (COUPON_NK1,COUPON_NK2,COUPON_NK3,BATCH_ID,LOAD_TS,SOURCE_SYSTEM_CD)
		values (BARCODE,''~~'',''~~'',BATCH_ID,current_timestamp(),''OCCDTL'')`;

		//variable to hold sql statement into COUPON_OCCDTL_SAT
		var update_COUPON_OCCDTL_SAT=
		` merge into "ADW_RDV"."COUPON_OCCDTL_SAT" T1
		using (select distinct BARCODE,
		MD5(
			coalesce(COUPON_NAME ,''"~~"'')||''"~"''||
			coalesce(COUPON_TAG ,''"~~"'')||''"~"''||
			coalesce(PRINTER_MESSAGE ,''"~~"'')||''"~"''||
			coalesce(SHORT_DESC ,''"~~"'')||''"~"''||
			coalesce(LONG_DESC ,''"~~"'')||''"~"''||
			coalesce(OFFER_EFFECTIVE_DATE ,''"~~"'')||''"~"''||
			coalesce(OFFER_EXPIRATION_DATE ,''"~~"'')||''"~"''||
			coalesce(REWARD_VALUE_FIXED ,0)||''"~"''||
			coalesce(COUPON_PRINT_START_DATE ,''"~~"'')||''"~"''||
			coalesce(ACCOUNT_CODE ,''"~~"'')||''"~"''||
			coalesce(COST_CENTRE ,''"~~"'')||''"~"''||
			coalesce(EST_DIST_QUANTITY ,0)||''"~"''||
			coalesce(EST_REDEMPTION_RATE ,0)||''"~"''||
			coalesce(THRESHOLD ,0)||''"~"''||
			coalesce(VALIDATION_TYPE ,''"~~"'')||''"~"''||
			coalesce(THRESHOLD_UNITS ,0)||''"~"''||
			coalesce(PROMO_ID ,0)||''"~"''||
			coalesce(REWARD_VALUE_POINTMULTI ,0)||''"~"''||
			coalesce(NECTAR_PRODUCT_RANGE ,''"~~"'')||''"~"''||
			coalesce(REWARD_VALUE_MONEY ,0)||''"~"''||
			coalesce(LOYALTY_CARD_REQUIRED ,''"~~"'')||''"~"''||
			coalesce(INSTORE ,''"~~"'')||''"~"''||
			coalesce(GOL ,''"~~"'')||''"~"''||
			coalesce(ROLLING_DAYS_VALIDITY ,0)||''"~"''||
			coalesce(PHOEBUS_CODE ,0)||''"~"''||
			coalesce(SUPPLIER_NAME ,''"~~"'')||''"~"''||
			coalesce(OC_ID ,0)||''"~"''||
			coalesce(UNIT ,''"~~"'')||''"~"''||
			coalesce(OWNER ,''"~~"'')||''"~"''||
			coalesce(REWARD_TYPE ,''"~~"'')||''"~"''||
			coalesce(CREATEDATE ,''"~~"'')||''"~"''||
			coalesce(STATUS ,''"~~"'')||''"~"''||
			''N''
		   ) AS HASH_DIFF
				from
				"ADW_PRODUCT_TRAN"."FINANCE_OCCDTL_VW") AS T2
		ON T1.COUPON_NK1=T2.BARCODE and T1.HASH_DIFF!=T2.HASH_DIFF
		when matched then
		update set
				COUPON_END_DT=CURRENT_TIMESTAMP , BARCODE_STATUS =''invalid''
		 `;

		//variable to hold merge records into "ADW_RDV"."COUPON_OCCDTL_SAT"
		var insert_into_COUPON_OCCDTL_SAT=
		`merge into "ADW_RDV"."COUPON_OCCDTL_SAT" T1
		using (select distinct
				COUPON_ID ,
				COUPON_NAME ,
				COUPON_TAG ,
				PRINTER_MESSAGE ,
				SHORT_DESC ,
				LONG_DESC ,
				OFFER_EFFECTIVE_DATE ,
				OFFER_EXPIRATION_DATE ,
				REWARD_VALUE_FIXED ,
				COUPON_PRINT_START_DATE ,
				ACCOUNT_CODE ,
				COST_CENTRE ,
				EST_DIST_QUANTITY ,
				EST_REDEMPTION_RATE ,
				THRESHOLD ,
				VALIDATION_TYPE ,
				THRESHOLD_UNITS ,
				PROMO_ID ,
				REWARD_VALUE_POINTMULTI ,
				NECTAR_PRODUCT_RANGE ,
				REWARD_VALUE_MONEY ,
				LOYALTY_CARD_REQUIRED ,
				INSTORE ,
				GOL ,
				ROLLING_DAYS_VALIDITY ,
				PHOEBUS_CODE ,
				SUPPLIER_NAME ,
				OC_ID ,
				UNIT ,
				OWNER ,
				REWARD_TYPE ,
				BARCODE ,
				CREATEDATE ,
				STATUS ,
				MD5(
				coalesce(COUPON_NAME ,''"~~"'')||''"~"''||
				coalesce(COUPON_TAG ,''"~~"'')||''"~"''||
				coalesce(PRINTER_MESSAGE ,''"~~"'')||''"~"''||
				coalesce(SHORT_DESC ,''"~~"'')||''"~"''||
				coalesce(LONG_DESC ,''"~~"'')||''"~"''||
				coalesce(OFFER_EFFECTIVE_DATE ,''"~~"'')||''"~"''||
				coalesce(OFFER_EXPIRATION_DATE ,''"~~"'')||''"~"''||
				coalesce(REWARD_VALUE_FIXED ,0)||''"~"''||
				coalesce(COUPON_PRINT_START_DATE ,''"~~"'')||''"~"''||
				coalesce(ACCOUNT_CODE ,''"~~"'')||''"~"''||
				coalesce(COST_CENTRE ,''"~~"'')||''"~"''||
				coalesce(EST_DIST_QUANTITY ,0)||''"~"''||
				coalesce(EST_REDEMPTION_RATE ,0)||''"~"''||
				coalesce(THRESHOLD ,0)||''"~"''||
				coalesce(VALIDATION_TYPE ,''"~~"'')||''"~"''||
				coalesce(THRESHOLD_UNITS ,0)||''"~"''||
				coalesce(PROMO_ID ,0)||''"~"''||
				coalesce(REWARD_VALUE_POINTMULTI ,0)||''"~"''||
				coalesce(NECTAR_PRODUCT_RANGE ,''"~~"'')||''"~"''||
				coalesce(REWARD_VALUE_MONEY ,0)||''"~"''||
				coalesce(LOYALTY_CARD_REQUIRED ,''"~~"'')||''"~"''||
				coalesce(INSTORE ,''"~~"'')||''"~"''||
				coalesce(GOL ,''"~~"'')||''"~"''||
				coalesce(ROLLING_DAYS_VALIDITY ,0)||''"~"''||
				coalesce(PHOEBUS_CODE ,0)||''"~"''||
				coalesce(SUPPLIER_NAME ,''"~~"'')||''"~"''||
				coalesce(OC_ID ,0)||''"~"''||
				coalesce(UNIT ,''"~~"'')||''"~"''||
				coalesce(OWNER ,''"~~"'')||''"~"''||
				coalesce(REWARD_TYPE ,''"~~"'')||''"~"''||
				coalesce(CREATEDATE ,''"~~"'')||''"~"''||
				coalesce(STATUS ,''"~~"'')||''"~"''||
				''N''
				) AS HASH_DIFF
			from
				"ADW_PRODUCT_TRAN"."FINANCE_OCCDTL_VW") AS T2
		ON (T1.COUPON_NK1=T2.BARCODE and T1.HASH_DIFF=T2.HASH_DIFF)
			when not matched then
			insert
			(
			COUPON_NK1 ,
			COUPON_NK2 ,
			COUPON_NK3 ,
			COUPON_NAME ,
			COUPON_TAG_CD ,
			COUPON_PRINTER_MESSAGE_TEXT ,
			COUPON_SHORT_DESC ,
			COUPON_LONG_DESC ,
			COUPON_START_DT ,
			COUPON_END_DT ,
			COUPON_REWARD_VALUE_NECTAR_PTS ,
			COUPON_PRINT_START_DT ,
			COUPON_ACCOUNT_CD ,
			COUPON_COST_CENTRE_CD ,
			COUPON_ESTIMATED_QTY ,
			COUPON_ESTIMATED_REDEMPTION_QTY ,
			COUPON_THRESHOLD_NUM ,
			COUPON_REDEMPTION_TYPE ,
			COUPON_THRESHOLD_UNITS ,
			COUPON_PROMOTION_ID ,
			COUPON_REWARD_POINTS_MULTIPLIER_NUM ,
			NECTAR_PRODUCT_RANGE_CD ,
			COUPON_REWARD_VALUE_AMT ,
			LOYALTY_CARD_REQUIRED_IND ,
			COUPON_INSTORE_IND ,
			COUPON_ONLINE_ORDER_IND ,
			COUPON_ROLLING_VALIDITY_DAYS_NUM ,
			COUPON_PHOEBUS_CD ,
			COUPON_SUPPLIER_NAME ,
			COUPON_EAGLEEYE_CAMPAIGN_ID ,
			COUPON_STORE_UNIT_CD ,
			COUPON_OWNER_CD ,
			COUPON_REWARD_TYPE_CD ,
			COUPON_CREATE_DT ,
			COUPON_STATUS_CD ,
			HASH_DIFF ,
			SOURCE_SYSTEM_CD ,
			TECHNICAL_METADATA,
			LOAD_TS,
            BARCODE_STATUS
			)
			values
			(
                T2.BARCODE,
                ''~~'',
                ''~~'',
                T2.COUPON_NAME ,
                T2.COUPON_TAG ,
                T2.PRINTER_MESSAGE ,
                T2.SHORT_DESC ,
                T2.LONG_DESC ,
                T2.OFFER_EFFECTIVE_DATE ,
                T2.OFFER_EXPIRATION_DATE ,
                T2.REWARD_VALUE_FIXED ,
                T2.COUPON_PRINT_START_DATE ,
                T2.ACCOUNT_CODE ,
                T2.COST_CENTRE ,
                T2.EST_DIST_QUANTITY ,
                T2.EST_REDEMPTION_RATE ,
                T2.THRESHOLD ,
                T2.VALIDATION_TYPE ,
                T2.THRESHOLD_UNITS,
                T2.PROMO_ID,
                T2.REWARD_VALUE_POINTMULTI ,
                T2.NECTAR_PRODUCT_RANGE ,
                T2.REWARD_VALUE_MONEY ,
                T2.LOYALTY_CARD_REQUIRED ,
                T2.INSTORE ,
                T2.GOL ,
                T2.ROLLING_DAYS_VALIDITY ,
                T2.PHOEBUS_CODE ,
                T2.SUPPLIER_NAME ,
                T2.OC_ID ,
                T2.UNIT ,
                T2.OWNER ,
                T2.REWARD_TYPE ,
                T2.CREATEDATE ,
                T2.STATUS ,
                T2.HASH_DIFF,
                ''OCCDTL'',
                PARSE_JSON
                (
                    ''{
                    "EFFECTIVE_FROM_TS": "''||CURRENT_TIMESTAMP||''",
                    "JOB_NAME": "stage_finance_occdtl_vm_to_rdv_coupon_occdtl_sat",
                    "LOAD_TS": "''||CURRENT_TIMESTAMP||''",
                    "REASON_CD": "",
                    "RECORD_ID": "",
                    "SOURCE_SYSTEM_CD": "OCCDTL"
                    }''
                ) ,
                CURRENT_TIMESTAMP,
                ''valid''
		) `;

		//merge new records into coupon_hub table
        v_tbl_nm = `"ADW_RDV"."COUPON_HUB"`;
		var Statement1=snowflake.createStatement({ sqlText: insert_into_COUPON_HUB});

		//update the COUPON_END_DT of the record based on any change in the exsiting record
        v_tbl_nm = `"ADW_RDV"."COUPON_OCCDTL_SAT"`;
		var Statement2=snowflake.createStatement({ sqlText: update_COUPON_OCCDTL_SAT});

		//merge new records into coupon_hub table and update the already available records
		//incase there is any change in record details
		var Statement3=snowflake.createStatement({ sqlText: insert_into_COUPON_OCCDTL_SAT});

		//execute statments
        v_tbl_nm = `"ADW_RDV"."COUPON_HUB"`;

		var result1=Statement1.execute();
		//number of records effectively added into the table coupon_hub
		var v_rowCnt = Statement1.getNumRowsAffected();

		if(v_rowCnt != 0)
        {
			//check there is any record affected in operation then only add log
            //add the success log for coupon_hub table
            snowflake.createStatement( { sqlText: `call "ADW_STAGE"."ADD_LOG_SP"(:1,:2,:3)`, binds:[`INSERT RECORDS`,`INSERT DATA INTO TABLE: "ADW_RDV"."COUPON_HUB", Total Records inserted : `+ v_rowCnt , `Success`] } ).execute();
        }

		v_tbl_nm = `"ADW_RDV"."COUPON_OCCDTL_SAT"`;
		var result2=Statement2.execute();

		//number of records effectively updated into the table
		v_rowUpdCnt = Statement2.getNumRowsAffected();

        //add the success log for "ADW_RDV"."COUPON_OCCDTL_SAT" table
        if(v_rowUpdCnt != 0)
        {
			//check there is any record affected in operation then only add log
            snowflake.createStatement( { sqlText: `call "ADW_STAGE"."ADD_LOG_SP"(:1,:2,:3)`, binds:[`UPDATE RECORDS`,`UPDATE DATA INTO TABLE: "ADW_RDV"."COUPON_OCCDTL_SAT", Total Records updated : `+ v_rowCnt , `Success`] } ).execute();
        }

		var result3=Statement3.execute();
		//number of records effectively added or updated into the table

		v_rowInsCnt = Statement3.getNumRowsAffected();

        //add the success log for "ADV_RDV"."COUPON_OCCDTL_SAT" table
        if(v_rowInsCnt != 0)
        {
			//check there is any record affected in operation then only add log
            snowflake.createStatement( { sqlText: `call "ADW_STAGE"."ADD_LOG_SP"(:1,:2,:3)`, binds:[`INSERT RECORDS`,`INSERT DATA INTO TABLE:"ADW_RDV"."COUPON_OCCDTL_SAT", Total Records inserted : `+ v_rowInsCnt , `Success`] } ).execute();

        }
	}//end of try block
	catch(err)
	{
		v_log_msg = `Unable to add records into Table `+ v_tbl_nm +` Error code : ` + err.code;
        v_log_msg += `\n Message : ` + err.message;
        v_log_msg += `\n Stack Trace:\n` + err.stackTraceTxt;

        //add log entry for failure
		snowflake.createStatement( { sqlText: `call "ADW_STAGE"."ADD_LOG_SP"(:1,:2,:3)`, binds:[`INSERT RECORDS`, v_log_msg , `Error`] } ).execute();
        //return as there is a failure in execution
		//return `Execution failed, check pipeline_log table for more details`;
		throw err;
    }
	//final return to the calling environment
	//called once all above operations are successfully completed
	return v_rowInsCnt + v_rowUpdCnt;
    ';