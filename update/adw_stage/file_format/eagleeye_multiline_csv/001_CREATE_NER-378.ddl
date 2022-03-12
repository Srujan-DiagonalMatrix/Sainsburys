/***********************************************************************************************************************************************
* Filename:  001_CREATE_NER-378.ddl
* Owner: Nectarine
* Author: Vinod Karimilla
* Date: 04/03/2022
* Ticket Number: NER-378
* Description: Create - Added new  DDL for file format EAGLEEYE_MULTILINE_CSV for multiline.
*************************************************************************************************************************************************/
USE ROLE RL_${ENV}_OBJECT_OWNER;

CREATE OR REPLACE FILE FORMAT "ADW_STAGE"."EAGLEEYE_MULTILINE_CSV"
type = 'csv'
FIELD_DELIMITER = ','
RECORD_DELIMITER = '\n'
SKIP_HEADER = 1
FIELD_OPTIONALLY_ENCLOSED_BY = '"'
TRIM_SPACE = FALSE
ERROR_ON_COLUMN_COUNT_MISMATCH = TRUE
ESCAPE = 'NONE'
ESCAPE_UNENCLOSED_FIELD = '\134'
DATE_FORMAT = 'AUTO'
TIMESTAMP_FORMAT = 'AUTO'
NULL_IF = ('NULL', 'null', '\\N')
COMMENT = 'parse comma-delimited data';