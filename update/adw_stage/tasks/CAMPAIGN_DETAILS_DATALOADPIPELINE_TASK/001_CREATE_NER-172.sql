/***********************************************************************************************************************************************
* Filename:  001_CREATE_NER-172.sql
* Owner: Nectarine
* Author: Srujan K Alikanti
* Date: 24/02/2022
* Ticket Number: NER-172
* Description: Execute procedure CAMPAIGN_DETAILS_DATALOAD_PIPELINE_TASK_WRP_SP that trigger whole pipeline
*************************************************************************************************************************************************/ 

USE SCHEMA ADW_STAGE;
CREATE OR REPLACE TASK "ADW_STAGE"."CAMPAIGN_DETAILS_DATALOADPIPELINE_TASK"
WAREHOUSE = ADW_XSMALL_ADHOC_WH
SCHEDULE  ='1 MINUTE'
COMMENT = "Execute pipeline every minute"
AS call "ADW_STAGE"."CAMPAIGN_DETAILS_DATALOAD_PIPELINE_TASK_WRP_SP"();
ALTER TASK "ADW_STAGE"."CAMPAIGN_DETAILS_DATALOADPIPELINE_TASK" RESUME;
