 /***********************************************************************************************************************************************
* Filename:  001_CREATE_NER-172.ddl
* Owner: Nectarine
* Author: Srujan K Alikanti
* Date: 09/02/2022
* Ticket Number: NER-172
* Description: Create - Create a Log table that holds runtime log details
*************************************************************************************************************************************************/ 
USE ROLE RL_${ENV}_OBJECT_OWNER;

CREATE OR REPLACE TABLE "ADW_STAGE"."PIPELINE_LOG" (
	DATE_TIME			TIMESTAMP_NTZ(9) NOT NULL DEFAULT CURRENT_TIMESTAMP() COMMENT 'runtime datatime stamp',
	EVENT				VARCHAR(128) NOT NULL COMMENT 'events such as Insert/Update, function execution are recorded,',
	EVENT_DESCRIPTION	VARCHAR(1000) NOT NULL COMMENT 'Detailed description of an event. Eg: 100 records inserted',
	STATUS				VARCHAR(100) NOT NULL COMMENT 'Success/Faile/Warnings are recorded'
);