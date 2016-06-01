public class eCommerceTransactionPage {
    String[] banks= new String[]{};
    public Integer cardNum{get;set;}
    public String paswrd{get;set;}
    public static string transacId{get;set;}
    public Product2 prodInfo {get;set;}
    public Integer totalPrice{get;set;}
    public String qty{get;set;} 
    public String address{get;set;}
    public String str{get;set;}
    public String sessionId{get;set;}
    public String loggedInUserId{get;set;}
    
    public String[] getBankName() {
       
        return banks;
    }
    
    
    public void setBankName(String[] banks){
        this.banks=banks;
    }
    
    public List<selectOption> getlistOfBanks(){
        List<selectOption> banksList = new List<selectOption>();
        
        banksList.add(new SelectOption('HDFC Bank',' HDFC BANK'));
        banksList.add(new SelectOption('Axis Bank',' AXIS BANK'));
        return banksList;
    }
    
    @RemoteAction
    public static String generateTransactionid(String cardNumb,Integer price,String address,String orderId,Integer quntity,String sessionId){
        transacId=cardNumb;//cardNum;
        
        User_Product_Detail__c uProd= new User_Product_Detail__c();
        uProd.Delivery_Status__c='Order Placed';
        uProd.Price__c=price;
        uProd.Description__c=address;
        uProd.Product_Id__c=orderId;
        System.debug('Values1----'+quntity+'\n'+orderId+'\n'+'\n'+price+'\n'+address+'\n'+sessionId);
        uProd.Quantity__c=Integer.valueOf(quntity);
        if(!String.isBlank(sessionId)){uProd.Order_Id__c=sessionId;}        
        try{
            insert uProd;
        }catch(Exception e){
            System.debug('Exception Found @'+e.getLineNumber());
        }
        return 'Your Transaction is Successfull:'+cardNumb;
    }
    
    public void selectedProductSummary(){           
            str=apexpages.currentpage().getparameters().get('pCode');
            sessionId=apexpages.currentpage().getparameters().get('sessionId');            
            System.debug('OUTside.......'+sessionId);
            if(String.isBlank(sessionId)){
                   sessionId='guestuser@gmail.com'; 
            }
            if(!String.isBlank(str)){
                prodInfo=[select id,name,Family,Description,ProductCode,Price__c,image_URL__c from Product2 where id=:str];                
                if(!String.isBlank(sessionId)){
                 eCommerce_User_Records__c eRec=[select id,userName__c from eCommerce_User_Records__c where Username__c=:sessionId];                 
                 if(eRec!=null){
                     loggedInUserId=eRec.Id;   
                 }
                }
                System.debug('Inside.......'+sessionId);
            }
            System.debug('000----'+prodInfo.Id);
            qty =apexpages.currentpage().getparameters().get('qty');
            if(Integer.valueof(qty)<100){
                totalPrice=Integer.valueOf(prodInfo.Price__c*Integer.valueof(qty));
            }                   
            
    } 
}