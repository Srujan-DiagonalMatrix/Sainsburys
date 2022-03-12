/***********************************************************************************************************************************************
* Filename:  001_CREATE_NER-381.ddl
* Owner: Nectarine
* Author: Vinod Karimilla
* Date: 04/03/2022
* Ticket Number: NER-381
* Description: Create - Create  for eagle eye integration stage.
*************************************************************************************************************************************************/
use role RL_${ENV}_NECTARINE_ETL;
CREATE OR REPLACE STAGE "ADW_STAGE"."STAGE_EAGLEYE_OCC_CAMPAIGN_DETAILS"
storage_integration = NECTARINE_${ENV}
url = 's3://${S3_ENV}-raw-src-eagleeye-occ/coupondetails/data/'
file_format = "ADW_STAGE"."EAGLEEYE_MULTILINE_CSV"