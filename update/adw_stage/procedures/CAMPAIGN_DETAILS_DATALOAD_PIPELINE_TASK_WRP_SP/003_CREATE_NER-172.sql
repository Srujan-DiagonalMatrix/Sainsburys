 /***********************************************************************************************************************************************
* Filename:  003_CREATE_NER-172.sql
* Owner: Nectarine
* Author: Srujan K Alikanti
* Date: 13/01/2022
* Ticket Number: NER-172
* Description: Create - Create STREAM on table EAGLEEYE_OCC_CAMPAIGN_DETAILS.
*************************************************************************************************************************************************/ 

CREATE or REPLACE PROCEDURE "ADW_STAGE"."CAMPAIGN_DETAILS_DATALOAD_PIPELINE_TASK_WRP_SP"()
returns string not null
language javascript
COMMENT =
		'
			Wrapper Procedure for syncing the CAMPAIGN DETAILS DATA in continous load once new data is loaded.
			This will be called from TASK which will be scheduled to run every 1 minute

		'
AS
'
try
{

    //variable to hold number of records getting added after execution of the procedure
	var v_rowCount = "";
    var v_sqlStmt  = "";
	var v_resStmt  = "";

	//variable to hold then procedure name which gets failed.
	v_err_proc_name = "";
	//procedure is for checking the stream object and adding the newly added records into table:
	//"ADW_STAGE"."EAGLEEYE_OCC_CAMPAIGN_DETAILS_BATCH_LOAD"
	v_err_proc_name = `"ADW_STAGE"."FETCH_FROM_CAMPAIGN_DETAILS_STREAM_PROC_SP"`;
    v_sqlStmt = snowflake.createStatement( { sqlText: `call "ADW_STAGE"."FETCH_FROM_CAMPAIGN_DETAILS_STREAM_PROC_SP"()` } )
	v_resStmt = v_sqlStmt.execute();
    //fetch the number of records added
    v_resStmt.next();
    v_rowCount = parseInt(v_resStmt.getColumnValue(1));


    //setting defaulted to 1 for testing the changes
	//call the below procedure only when new data has been added to load table
	if (v_rowCount > 0)
	{

		//procedure is to sync all data added into the "ADW_STAGE"."EAGLEEYE_OCC_CAMPAIGN_DETAILS_BATCH_LOAD"  latest batch_id only
		//into the tables : "ADW_RDV"."COUPON_HUB" and "ADV_RDV"."COUPON_OCCDTL_SAT"
		v_err_proc_name += v_rowCount + `"ADW_PRODUCT_TRAN"."FETCH_FROM_FINANCE_OCCDTL_VW_SP"`;
		v_sqlStmt = snowflake.createStatement( { sqlText: `call "ADW_PRODUCT_TRAN"."FETCH_FROM_FINANCE_OCCDTL_VW_SP"()` } );
        //execute the procedure for syncing the data
        v_resStmt = v_sqlStmt.execute();
        //fetch the number of records added
        v_resStmt.next();
        v_rowCount = parseInt(v_resStmt.getColumnValue(1));


        //if there are changes in the coupon hub data records then only concider for loading
        if (v_rowCount > 0)
        {

            //procedure is to delete and load data into tables "ADW_BDV"."OCC_BARCODE_CLASSIFICATION_BR" from table "ADV_RDV"."COUPON_OCCDTL_SAT"
            //only valid records are concidered for loading the data
            v_err_proc_name += v_rowCount + `"ADW_BDV"."FETCH_FROM_OCCDTL_SAT_TO_LOAD_BARCODE_CLASS_PROC_SP()"`;
            v_sqlStmt = snowflake.createStatement( { sqlText: `call "ADW_BDV"."FETCH_FROM_OCCDTL_SAT_TO_LOAD_BARCODE_CLASS_PROC_SP"()` } );
            //execute the procedure for syncing the data
            v_resStmt = v_sqlStmt.execute();
            //fetch the number of records added
            v_resStmt.next();
            v_rowCount = parseInt(v_resStmt.getColumnValue(1));

    	}
    }

}
catch(err)
{
	v_log_msg = `Wrapper procedure for campaign details data pipeline got failed at executing proc : `+ v_err_proc_name + ` Check the failed log entries for more details!` + err.code;
    v_log_msg += `\n Message : ` + err.message;
    v_log_msg += `\n Stack Trace:\n` + err.stackTraceTxt;

	//add log entry for failure
	snowflake.createStatement( { sqlText: `call "ADW_STAGE"."ADD_LOG_SP"(:1,:2,:3)`, binds:[`DATAPIPE EXECUTION`, v_log_msg , `Error`] } ).execute();

	//return as there is a failure in execution
	return `Execution failed, check pipeline_log table for more details`;
}

//final return to the executing task
//called once all above operations are successfully completed
return `Data Load Pipeline Executed Successfully! `;
';