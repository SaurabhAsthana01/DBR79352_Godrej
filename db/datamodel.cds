namespace GODREJ;

entity BULL_MASTER{
key ID: Integer;
BullCode : String;
Company : String;
Breed : String;
DaughterAverage: String;
TPI: String;
CreationDt : Date;
CreationId : String;
SimensStock: String

}

entity FARMER_MASTER{
    key ID:Integer;
    FarmerCode:String;
    FarmerName: String;
    Address:String;
    City:String;
    PIN: Integer;
    MobileNo:String;
    EmailId:String;
    CreationDate:Date;
    CreationId:String;
    District: String;
    State:String

}

entity COW_MASTER{
    key ID:Integer;
    CowCode:String;
    CowBreed:String;
    FarmerCode:String;
    Tagging:String;
    BestLocationYield:String;
    TPI:String;
    LactationNo:String;
    Age:Integer;
    INAPH_ID: String;
    Type: String;
    CreationDate:Date;
    CreationId:String

}

entity USER_MASTER{
    key ID:Integer; 
    EDP_No:String;
    Name:String;
    Role:String;
    emailId:String;
    MobileNo:String;
    ReportingManager:String;
    CreationDate:Date;
    CreationId:String;
    Active_Inactive:String;
    InactiveDt:Date

}

entity EMBRYO_MASTER{
    key ID:Integer;
    EmbryoNo:String;
    OPU_Date:Date;
    TransferDt:Date;
    SireName:String;
    DonorNo:String;
    BatchNo:String;
    CreationDt:Date;
    CreationID:String;
}

entity PROTOCOL_SYNCHRONIZATION{
    key ID:Integer;
    ProtoCode:String;
    ProtocolName: String;
    Length_Of_Synchronization: Integer
    
}

entity MASTER_TXN{
key OrderNo:Integer;
Order_Date: String;
FarmerCode:String;
EDP_No:String;                          // added this field
Order_Status:String;
CowBreed:String;
CowQty:Integer;
Exepcted_ET_DT:Date;
Billing_Condition:String;
AdvanceAmt:Decimal;
AgentNo:String;
Amount:Decimal;
BalanceAmt:String;
EmbryoNo:String;                         // added this field
EmbryoQty:Integer;
Rate:Decimal;
PaymentDt:Date;
Remarks:String
}

entity CHILD_TXN{
    OrderNo:Integer;          //reference from master txn table.
    Surr_Cow_Code:String;
    PrototypeCode:String;
    Date_of_start:Date;
    Expected_Heat_Date:Date;
    Date_of_heat:Date;
    DonorCowCode:String;     //Is it same as DonorNo?
    OPU_Date:Date;           //Should be auto generated  
    EmbryoQty:Integer;
    EmbryoType:String;
    Expected_Pregnancy_Dt:Date;
    ET_Date:Date;
    Pregnancy_Confirmation:String;
    Pregnancy_Dt:Date;
    Remarks:String

}
// //-----------------------------------------------------------------------------------------------------------------------------

define view HEATDETECTION as 
select FROM MASTER_TXN as T 
LEFT OUTER JOIN FARMER_MASTER as F ON T.FarmerCode = F.FarmerCode
LEFT OUTER JOIN USER_MASTER as U ON T.EDP_No = U.EDP_No
LEFT OUTER JOIN CHILD_TXN as C on T.OrderNo = C.OrderNo
{
    key T.OrderNo ,F.FarmerName, T.Order_Date, T.Exepcted_ET_DT, F.MobileNo, T.CowBreed, 
    U.Name, C.Surr_Cow_Code,C.Date_of_heat,C.Remarks
};

// //------------------------------------------------------------------------------------------------------

define view CUSTOMERENQUIRY as 
select FROM MASTER_TXN as T

LEFT OUTER JOIN FARMER_MASTER as F 
   ON T.FarmerCode = F.FarmerCode

LEFT OUTER JOIN COW_MASTER as C 
   ON T.FarmerCode = C.FarmerCode

  {
   key F.FarmerName, F.Address, F.City, F.PIN , F.MobileNo , C.CowBreed , T.CowQty , T.Exepcted_ET_DT, 
   C.CowCode, C.BestLocationYield, C.TPI, C.LactationNo, C.Age, C.INAPH_ID
 };

// How to map Surr.CowCode/Tagging -> Populated from Cow Master, key is Farmer Code, Entry into Child TXN table. We dont have Surr_Cow_Code in cow master.

// //-------------------------------------------------------------------------------------------------------

define view SYNCHRONIZATION as 
select FROM MASTER_TXN as T

LEFT OUTER JOIN FARMER_MASTER as F 
   ON T.FarmerCode = F.FarmerCode

LEFT OUTER JOIN CHILD_TXN as C 
   ON T.OrderNo = C.OrderNo

LEFT OUTER JOIN PROTOCOL_SYNCHRONIZATION as P
   ON C.PrototypeCode = P.ProtoCode
{
   key T.OrderNo, F.FarmerName, T.Order_Date, T.Exepcted_ET_DT, F.MobileNo, 
    T.CowBreed, C.Surr_Cow_Code,P.ProtoCode,C.Date_of_start, 
    To_DATS(ADDDAYS(C.Date_of_start, P.Length_Of_Synchronization)) as Expected_Heat_Date 
    ,C.Remarks
};

// //---------------------------------------------------------------------------------------------------------

//Proposed ET DT is not present in Embryo Master table used TransferDt a per Glen.
//Linkage is : Embryo Master linked to Cow master, key Cow Code AND Cow master linked to Master TXN table, key Breed value

define view DONOR_COW_IDENTIFICATION as 
select from MASTER_TXN as T

LEFT OUTER JOIN FARMER_MASTER as F 
   ON T.FarmerCode = F.FarmerCode

LEFT OUTER JOIN EMBRYO_MASTER as E 
   ON T.EmbryoNo = E.EmbryoNo              //EmbryoNo field was not present in Any TXN Table. I added this in MasterTxn

LEFT OUTER JOIN USER_MASTER as U
  ON T.EDP_No = U.EDP_No

LEFT OUTER JOIN CHILD_TXN as C
  ON T.OrderNo = C.OrderNo
{
   key T.OrderNo, F.FarmerName, T.Order_Date, F.MobileNo, T.CowBreed, U.Name,C.Surr_Cow_Code, 
    E.DonorNo, C.Date_of_heat, E.OPU_Date, E.TransferDt, T.Remarks
};


// //----------------------------------------------------------------------------------------------------------------

define view EMBRYO_PRODUCTION as
select from MASTER_TXN as T
LEFT OUTER JOIN FARMER_MASTER as F 
   ON T.FarmerCode = F.FarmerCode

LEFT OUTER JOIN USER_MASTER as U
   ON T.EDP_No = U.EDP_No

LEFT OUTER JOIN CHILD_TXN as C 
   ON T.OrderNo = C.OrderNo

LEFT OUTER JOIN EMBRYO_MASTER as E
   ON T.EmbryoNo = E.EmbryoNo
   {
     key T.OrderNo, F.FarmerName, T.Order_Date, F.MobileNo, T.CowBreed, U.Name, C.Surr_Cow_Code, E.SireName, C.DonorCowCode,
     C.OPU_Date, E.EmbryoNo , C.EmbryoQty ,E.BatchNo , C.Remarks 

   };

//--------------------------------------------------------------------------------------------------------------------------------

define view EMBRYO_TRANSFER as
select from MASTER_TXN as T
LEFT OUTER JOIN FARMER_MASTER as F 
   ON T.FarmerCode = F.FarmerCode
LEFT OUTER JOIN USER_MASTER as U 
   ON T.EDP_No = U.EDP_No
LEFT OUTER JOIN EMBRYO_MASTER as E
   ON T.EmbryoNo = E.EmbryoNo
LEFT OUTER JOIN CHILD_TXN as C
   ON T.OrderNo = C.OrderNo

{
   Key T.OrderNo, F.FarmerName, T.Order_Date , F.MobileNo, T.CowBreed, U.Name, C.Surr_Cow_Code, E.SireName, C.DonorCowCode,
   C.OPU_Date, E.BatchNo, C.EmbryoQty , C.EmbryoType , C.Expected_Pregnancy_Dt, C.Remarks, C.ET_Date
};

//---------------------------------------------------------------------------------------------------------------------------------

define view PREGNANCY_DIAGNOSIS as
select from MASTER_TXN as T
LEFT OUTER JOIN FARMER_MASTER as F 
   ON T.FarmerCode = F.FarmerCode
LEFT OUTER JOIN USER_MASTER as U 
   ON T.EDP_No = U.EDP_No
LEFT OUTER JOIN EMBRYO_MASTER as E
   ON T.EmbryoNo = E.EmbryoNo
LEFT OUTER JOIN CHILD_TXN as C
   ON T.OrderNo = C.OrderNo

{
    Key T.OrderNo,F.FarmerName, F.MobileNo, T.CowBreed, U.Name, C.Surr_Cow_Code, C.DonorCowCode, E.EmbryoNo, C.Pregnancy_Confirmation,
    C.Pregnancy_Dt, C.Remarks, C.ET_Date

};

//----------------------------------------------------------------------------------------------------------------------------------

//Billing view is not completed yet, missing one field Surr_Cow_Nos field.

define view BILLING as
select from MASTER_TXN as T
LEFT OUTER JOIN FARMER_MASTER as F 
   ON T.FarmerCode = F.FarmerCode
LEFT OUTER JOIN USER_MASTER as U 
   ON T.EDP_No = U.EDP_No
LEFT OUTER JOIN EMBRYO_MASTER as E
   ON T.EmbryoNo = E.EmbryoNo

   {
        Key T.OrderNo,F.FarmerName, F.MobileNo, T.CowBreed, U.Name, T.Billing_Condition, (T.EmbryoQty*T.Rate) as Amount,
        T.AdvanceAmt, (Amount - T.AdvanceAmt) as BalanceAmt, sum (T.EmbryoQty) as EmbryoQty, T.Rate, T.PaymentDt, T.Remarks
   };

//-------------------------------------------------------------------------------------------------------------------------------------
