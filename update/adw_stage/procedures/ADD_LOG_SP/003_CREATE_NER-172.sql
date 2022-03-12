 /***********************************************************************************************************************************************
* Filename:  003_CREATE_NER-172.sql
* Owner: Nectarine
* Author: Srujan K Alikanti
* Date: 13/01/2022
* Ticket Number: NER-172
* Description: Create - Proc: ADD_LOG that executes each time an event occured eg: INSERT/UPDATE/ERROR etc.
************************************************************************************************************************************************/ 

CREATE or REPLACE PROCEDURE "ADW_STAGE"."ADD_LOG_SP"(LOG_EVENT STRING, LOG_EVENT_DESC STRING, LOG_STATUS STRING)
 RETURNS STRING
 LANGUAGE JAVASCRIPT
AS
'
    //variable to check if logging needs to be added or not
    var v_logging_fl = true;

     //see if we should log - checks for v_logging_fl = true variable
     if ( v_logging_fl == true){ //if the value is anything other than true, dont add log
        try{

            snowflake.createStatement( { sqlText: `insert into "ADW_STAGE"."PIPELINE_LOG"(EVENT,EVENT_DESCRIPTION,STATUS ) VALUES (:1, :2 ,:3)`, binds:[ LOG_EVENT, LOG_EVENT_DESC , LOG_STATUS] } ).execute();
		
        } catch (ERROR){
	
            throw ERROR;
		
        }//end of add log check
     }
 ';