# BDV Table Classification Logic

## COUPON_VALUE_TYPE

Coupon Value Type: this tells us what type of campaign is being run. For example it may be a campaign which will treat vouchers as a tender, or it may be a campaign for Christmas food orders.

| When | COUPON_VALUE_TYPE is | Description|
|------|-------------------|------------|
| COUPON_NK1 IN('9924959239995','9924959239996')                                    | 'Christmas Food to Order' | Christmas food order vouchers have these barcodes
|COUPON_REWARD_TYPE_CD IN ('supplierMoneyOff','supplierFixedPoints')                |'Tender'| Supplier funded money off or fixed points campaigns are considered tender
|COUPON_REWARD_TYPE_CD IN ('pointsFixed','moneyOff') and COUPON_ACCOUNT_CD='48030'  | 'Deposit Return'| Account code 48030 represents 2x deposit return schemes. One rewards points, the other money off vouchers
|COUPON_ACCOUNT_CD = '35040'                                                        |'Car Park ticket'| Account code 35040 represents car park tickets
|COUPON_REWARD_TYPE_CD ='moneyOff' and COUPON_ACCOUNT_CD not in ('48030','35040') and substr(COUPON_NK1,1,6) not between '993014' and '993023'| 'Marketing Discount Product or Basket'| All money off vouchers excluding deposit return, car park tickets, and nectar price refunds
|COUPON_REWARD_TYPE_CD IN ('pointsFixed','pointsMultiplier') and COUPON_ACCOUNT_CD not in ('48030')|'Nectar Points Issuance Discount'| All points vouchers excluding deposit return
|substr(COUPON_NK1,1,6) between '993014' and '993023'                               |'Nectar Price Refund'| Nectar price refund vouchers which are issued digitally for nectar pricing
|else                                                                               | 'Unknown'|

## COUPON_APPORTIONMENT

Coupon Apportionment: this tells us if a campaign applies at the Product level (i.e. money off soft cheese) or a Basket level (£10 off if you spend over £100)


| When | COUPON_APPORTIONMENT is | Description|
|------|-------------------|------------|
|COUPON_TAG_CD = 'Deposit_Return_Points'    | 'Deposit Return Points'   | Trial deposit return rewarding points
|COUPON_TAG_CD = 'DepositReturnTrial'       | 'Deposit Return Trial'    | Trial deposit return rewarding money
|COUPON_ACCOUNT_CD = '35040'                | 'Basket'                  | All car park tickets should be considered basket level
|COUPON_REDEMPTION_TYPE='5. Basket Value' OR COUPON_REWARD_TYPE_CD='pointsMultiplier' | 'Basket' | All point multiplier campaigns are basket level
|COUPON_REDEMPTION_TYPE IN ('1. Item Quantity','3. Value of Qualifying Items')  | 'Product' | Items based redemption types are always product level
|else                                       | 'Unknown' |

## COUPON_FUNDING_CLASSIFICATION

Funding Classification: this tells us if the campaign is funded by Sainsbury's or by a Supplier (i.e. a supplier gives money off their brand of soap powder)

| When | COUPON_FUNDING_CLASSIFICATION is | Description|
|------|-------------------|------------|
|COUPON_REWARD_TYPE_CD IN ('supplierMoneyOff','supplierFixedPoints')    | 'Supplier' |
|COUPON_REWARD_TYPE_CD IN ('pointsFixed','moneyOff','pointsMultiplier')OR COUPON_TAG_CD IN ('Deposit_Return_Points','DepositReturnTrial') | 'Sainsburys' | Deposit return is Sainsbury's funded until August 2023
| else                      | 'Unknown' |
