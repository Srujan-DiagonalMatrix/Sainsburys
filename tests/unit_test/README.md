# Instructions to Unit test a one sample load from Eagle Eye omni-channel campaigns in PreProduction

This readme describes how to execute a manual load of known Eagle Eye campaign data into the Aspire Pre-Production database and verify expected results.
The test will load one sample file of campaign data from 

This guide assumes you are running a MacOS laptop.

The test executes the following steps:

- Clone the repository
- Verify integrity of repository test data
- Prepare the Pre-production S3 bucket for the test
- Prepare the Pre-production snowflake STAGE tables for the test
- Copy the test data into the Pre-production S3 bucket to trigger data load
- Verify expected data results in snowflake STAGE tables

## Clone the repository


    >  git clone https://github.com/JSainsburyPLC/aspire-snowflake-deployment-finance-nectarine.git
    > cd aspire-snowflake-deployment-finance-nectarine

## Verify Integrity of the test data set

The md5 checksum for data is stored in /eagle_eye_occ_samples/md5sum.txt

> Checksum: cee7a4a2fa6fe723687658e2b20406f 

Check the integrity of the test data as follows

    > cd tests/eagle_eye_occ_samples
    > cat */*.csv | md5sum -c md5sum.txt

This should return

    > -: OK

## Prepare the Pre-production S3 bucket for the test

Eagle Eye pre-production data is held in the following S3 bucket

|Account| Location|
|---|---|
|js-dpp1 (576277063358)| dpp-preprd-raw-src-eagleeye-occ/coupondetails/data/|

Make sure the `coupondetails/data` folder is empty. 
The following command assumes you have set up AWS profiles as documented in https://sainsburys-confluence.valiantys.net/display/NER/AWS+Azure+SSO+Login

If you are unable to use the command line, data may be deleted using the AWS S3 console.


    > aws s3 rm s3://dpp-preprd-raw-src-eagleeye-occ/coupondetails/data/ --recursive --include "*.csv" --profile <your profile credentials for dpp1>


## Prepare the Pre-production snowflake STAGE tables for the test

The target table for ingested data is `"ADW_PREPROD"."ADW_STAGE"."EAGLEEYE_OCC_CAMPAIGN_DETAILS"`

This table should be truncated before executing the test.

    > truncate table "ADW_PREPROD"."ADW_STAGE"."EAGLEEYE_OCC_CAMPAIGN_DETAILS"

To verify the table is empty

    > select count(*) from "ADW_PREPROD"."ADW_STAGE"."EAGLEEYE_OCC_CAMPAIGN_DETAILS"

should return a result of 0.

## Copy the test data into the Pre-production S3 bucket to trigger data load

Make sure you are in the directory `tests/eagle_eye_occ_samples`

    > pwd

Expected output 

    > <your repos directory>/aspire-snowflake-deployment-finance-nectarine/tests/eagle_eye_occ_samples

Run the following command to copy the test data from the repository into the pre-production S3 bucket.

>**WARNING - once data is in copied to the S3 bucket the pipeline will begin to ingest data**

    > aws s3 cp . s3://dpp-preprd-raw-src-eagleeye-occ/coupondetails/data/ --recursive --exclude "*" --include "*.csv" --profile <your profile credentials for dpp1>

Ouput

    upload: 20211002/coupondetails_20211002.csv to s3://dpp-preprd-raw-src-eagleeye-occ/coupondetails/data/20211002/coupondetails_Unit_Test_File.csv


>  You can monitor progress of the data load via the slack channel `grada-finance-voyager-preprod`
> https://sainsburys-tech.slack.com/archives/C01PQFLEPQ9
>  
> **If notifications are not seen in the slack channel, the test has FAILED and further action should be taken to debug**

## Verify expected data results in snowflake STAGE tables

The test dataset contains 6 rows over 1 file.
Therefore, we know that 7 rows of data should be ingested as 1 row are header.


As an inital load check - make sure the number of rows returned from the followin select statement returns 6

    select count(*) from "ADW_PREPROD"."ADW_STAGE"."EAGLEEYE_OCC_CAMPAIGN_DETAILS"

A more detailed row check can be performed by grouping the results by `SOURCE_PATH`

    select count(*), SOURCE_PATH from "ADW_PREPROD"."ADW_STAGE"."EAGLEEYE_OCC_CAMPAIGN_DETAILS" group by SOURCE_PATH


Expected Results
Row    SOURCE_PATH                                                           COUNT(*)

1    s3://dpp-dev-raw-src-eagleeye-occ/coupondetails/data/Unit_Test_File.csv    6

Expected Result in BDV:

Final table in BDV is OCC_BARCODE_CLASSIFICATION_BR, 
we need to check after pipeline working the expected result are as same as below:

COUPON_NK1	     COUPON_APPORTIONMENT	COUPON_VALUE_TYPE
9925012940506	  Product	            Tender
9926330070050	  Product	            Deposit Return
9926334054001	  Basket				Marketing Discount Product or Basket
2069716			  Unknown				Nectar Points Issuance Discount
9930154679993	  Product				Nectar Price Refund
9925010000851	  Unknown				Unknown