# Instructions to test a one month sample load from Eagle Eye omni-channel campaigns in PreProduction

This readme describes how to execute a manual load of known Eagle Eye campaign data into the Aspire Pre-Production database and verify expected results.
The test will load one month of campaign data from 

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

    upload: 20211002/coupondetails_20211002.csv to s3://dpp-preprd-raw-src-eagleeye-occ/coupondetails/data/20211002/coupondetails_20211002.csv
    upload: 20211010/coupondetails_20211010.csv to s3://dpp-preprd-raw-src-eagleeye-occ/coupondetails/data/20211010/coupondetails_20211010.csv
    ...
    <truncated>
    ...
    upload: 20211026/coupondetails_20211026.csv to s3://dpp-preprd-raw-src-eagleeye-occ/coupondetails/data/20211026/coupondetails_20211026.csv
    upload: 20211028/coupondetails_20211028.csv to s3://dpp-preprd-raw-src-eagleeye-occ/coupondetails/data/20211028/coupondetails_20211028.csv
    upload: 20211012/coupondetails_20211012.csv to s3://dpp-preprd-raw-src-eagleeye-occ/coupondetails/data/20211012/coupondetails_20211012.csv


>  You can monitor progress of the data load via the slack channel `grada-finance-voyager-preprod`
> https://sainsburys-tech.slack.com/archives/C01PQFLEPQ9
>  
> **If notifications are not seen in the slack channel, the test has FAILED and further action should be taken to debug**

## Verify expected data results in snowflake STAGE tables

The test dataset contains 10539 rows over 31 files.
Therefore, we know that 10508 rows of data should be ingested as 31 rows are headers.

However, we know that file 20211002/coupondetails_20211002.csv contains a row with a multiline split. Therefore we would expect 10507 rows to be ingested into the Snowflake `"ADW_PREPROD"."ADW_STAGE"."EAGLEEYE_OCC_CAMPAIGN_DETAILS"` table

As an inital load check - make sure the number of rows returned from the followin select statement returns 10508

    select count(*) from "ADW_PREPROD"."ADW_STAGE"."EAGLEEYE_OCC_CAMPAIGN_DETAILS"

A more detailed row check can be performed by grouping the results by `SOURCE_PATH`

    select count(*), SOURCE_PATH from "ADW_PREPROD"."ADW_STAGE"."EAGLEEYE_OCC_CAMPAIGN_DETAILS" group by SOURCE_PATH


Expected Results

| Row Count Excluding Headers | Source Path |
|-----------------------------|-------------|
|      20 |20211001/coupondetails_20211001.csv|
|      2 |20211002/coupondetails_20211002.csv|
|     17 |20211003/coupondetails_20211003.csv|
|     15 |20211004/coupondetails_20211004.csv|
|  286 |20211005/coupondetails_20211005.csv|
|   1305 |20211006/coupondetails_20211006.csv|
|    923 |20211007/coupondetails_20211007.csv|
|   2896 |20211008/coupondetails_20211008.csv|
|    474 |20211009/coupondetails_20211009.csv|
|     17 |20211010/coupondetails_20211010.csv|
|     88 |20211011/coupondetails_20211011.csv|
|   2020 |20211012/coupondetails_20211012.csv|
|    132 |20211013/coupondetails_20211013.csv|
|     17 |20211014/coupondetails_20211014.csv|
|     25 |20211015/coupondetails_20211015.csv|
|      0 |20211016/coupondetails_20211016.csv|
|     17 |20211017/coupondetails_20211017.csv|
|      5 |20211018/coupondetails_20211018.csv|
|     9 |20211019/coupondetails_20211019.csv|
|     13 |20211020/coupondetails_20211020.csv|
|      1 |20211021/coupondetails_20211021.csv|
|      0 |20211022/coupondetails_20211022.csv|
|      1 |20211023/coupondetails_20211023.csv|
|     17 |20211024/coupondetails_20211024.csv|
|     26 |20211025/coupondetails_20211025.csv|
|   1046 |20211026/coupondetails_20211026.csv|
|     12 |20211027/coupondetails_20211027.csv|
|   1000 |20211028/coupondetails_20211028.csv|
|     48 |20211029/coupondetails_20211029.csv|
|      0 |20211030/coupondetails_20211030.csv|
|     76 |20211031/coupondetails_20211031.csv|

If a mismatch in expected rowcounts, further investigation will be required as the test has FAILED.