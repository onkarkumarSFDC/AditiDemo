trigger AssetTrigger on Asset (after update) {
    List<Production__c> manfUnit = new List<Production__c>();
    for(Asset astObj:Trigger.New){
        if(astObj.Status=='Obsolete' && astObj.Description!=null && astObj.Quantity<0){
            Production__c pUnit = new Production__c();
            pUnit.Product__c=astObj.Product2Id;
            pUnit.Shortage_of_Products__c=Integer.valueOf(String.valueOf(astObj.Quantity).replace('-',''));
            pUnit.Description__c=astObj.Description;
            pUnit.Order_Id__c=astObj.Recent_Order__c;
            manfUnit.add(pUnit);            
        }       
    }
    if(manfUnit.size()>0){
        insert manfUnit;
        
    }
}