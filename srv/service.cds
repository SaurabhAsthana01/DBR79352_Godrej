using GODREJ as my from '../db/datamodel';

@impl: './FARMER.js'
service catalogservice{
entity BULL_MASTER as projection on my.BULL_MASTER;
entity FARMER_MASTER as projection on my.FARMER_MASTER;
entity COW_MASTER as projection on my.COW_MASTER;
entity USER_MASTER as projection on my.USER_MASTER;
entity EMBRYO_MASTER as projection on my.EMBRYO_MASTER;
entity PROTOCOL_SYNCHRONIZATION as projection on my.PROTOCOL_SYNCHRONIZATION;
// entity BILLING as projection on my.BILLING;
// entity HEATDETECTION as projection on my.HEATDETECTION;
}