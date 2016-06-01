public class eCommerceHomePage {

    public static String loggedInUserName { get; set; }

    public static Boolean isLoggedUser { get; set; }
        
    public Integer i{get;set;}       
    public List<Product2> allProductsList{get;set;} 
    public List<Product2> productsList{get;set;}
    public List<Product2> hometheaterList{get;set;}
    public List<Product2> carSpeakerList{get;set;}
    public Map<Id,String> prodAttchMap{get;set;}
    public Product2 prodInfo {get;set;}
    public static Integer NoOfItems{get;set;}
    public static Integer qty{get;set;}
    public String attURL{get;set;}
    String[] banks= new String[]{};       
    public static string transacId{get;set;}    
    public Integer totalPrice{get;set;}    
    public String address{get;set;}
    public String str{get;set;}
    public String sessionId{get;set;}
    public String loggedInUserId{get;set;}
    public static String pCode{get;set;}
    public Static String transactionid{get;set;}
    
    
    public eCommerceHomePage(){
        attURL='https://c.na30.content.force.com/servlet/servlet.FileDownload?file=';
        str=apexpages.currentpage().getparameters().get('sessionId');        
        pCode=apexpages.currentpage().getparameters().get('pCode');
        
        prodAttchMap= new Map<Id,String>();
        productsList= new List<Product2>();
        hometheaterList= new List<Product2>();
        carSpeakerList= new List<Product2>();        
        /*if(!String.isBlank(str)){
            System.debug('11111'+str);
           Contact eUser= new Contact();
           try{
           eUser=[select id,Email from Contact where Email =:str]; 
               if(!String.isBlank(str)){                    
                    loggedInUserName=eUser.Email;
                    isLoggedUser=true;  
               }
           }
           catch(Exception e){}
        } */
        
        User u = [select Id, username from User where Id = :UserInfo.getUserId()];
        apexpages.currentpage().getparameters().put('sessionId',u.Id);
        loggedInUserName=u.userName;
        if(loggedInUserName!=null){
            isLoggedUser=true;
        }

        if(!isLoggedUser){
            attURL='https://harmanconnectedservices.secure.force.com/servlet/servlet.FileDownload?file='; 
        }
         
        allProductsList=[select id,name,Family,Description,ProductCode,Price__c,image_URL__c from Product2 where IsActive=true];
            
        for(Attachment attch:[select id,parentId from Attachment where parentId in:allProductsList]){
            prodAttchMap.put(attch.parentId,attURL+attch.id);               
        }
        
        if(allProductsList.size()>0){
            for(Product2 prod:allProductsList){
                if(prod.family=='Bluetooth Speakers'){
                        productsList.add(prod);
                }else if(prod.family=='Car Speakers'){
                    carSpeakerList.add(prod);
                }else if(prod.family=='Home Audio'){
                    hometheaterList.add(prod);
                }
            }
        }
        
    }       
    
    @RemoteAction
    public static User registerNewUser(String userName,String alias,String phoneNum, String delAddr){        
        User us= new User();
        /*Contact newUser = new Contact();
        newUser.lastName=userName;
        newUser.Email=userName;
        newUser.Phone=phoneNum;
        newUser.Password__c=password;
        newUser.Description=delAddr;        
        //newUser.AccountId='00136000008Gm2WAAS';
        System.debug('####'+userName+'\n'+password);        
        insert newUser;                                              
        
        
        
        String[] strName=userName.split('@');
        User userObj= new User();
        System.debug('%%%%%'+strName[0]);        
        userObj.LastName=strName[0];
        userObj.Alias=alias;
        userObj.Email=userName;
        userObj.CommunityNickname=strName[0];
        //userObj.userRoleId=[SELECT DeveloperName,Id,Name FROM UserRole limit 1].Id;
        userObj.ProfileId=[select id,Name from Profile where Name='System Administrator' limit 1].Id;
        //userObj.licenseId=[select id from UserLicense where name='Partner Community' limit 1].Id;
        //userObj.ContactId=newUser.id;     
        userObj.Phone=phoneNum;
        userObj.isActive=true;
        userObj.Delivery_Address__c=delAddr;
        userObj.userName=userName;
        userObj.EmailEncodingKey='ISO-8859-1';
        userObj.LanguageLocaleKey=' en_US';
        userObj.LocaleSidKey='en_US';
        userObj.TimeZoneSidKey='GMT';
        insert userObj;
        
        return userObj;*/
        
        return us;

    }
        
    public void displaySelectedProduct(){           
            String str=apexpages.currentpage().getparameters().get('pCode');            
            if(!String.isBlank(str)){
                prodInfo=[select id,name,Family,Description,ProductCode,Price__c,image_URL__c from Product2 where id=:str];
            }
    }
             
    /*public String[] getBankName() {
       
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
    */
    
    @RemoteAction 
    public static String generateTransactionid(String phoneNum,String price, String address,String quanty,String emailId,String bankName,String cardNum,Id prodCode,String cardType){
        
        PaypalProccessor p = new PaypalProccessor();
        p.city = 'Bangalore';
        p.state = 'KR';
        p.zip = '1002';
        p.CVV = '';
        p.expYe = '2021';
        p.expMo = '06';
        p.CardNo = cardNum;//'5110921839131706';
        p.CardType = cardType;// 'MasterCard';
        p.FirstName  = 'Ajay';
        p.LastName  = 'Satish';
        p.Country = 'IN';
        p.Addy1 = '44';
        p.Addy2 = '433';
        p.payer = 'satishdoddangadi@gmail.com';
        p.amount = String.valueOf(Integer.valueOf(price)/65);//'5000';
        string message = p.pay();
        transactionid = p.transid;
        system.debug('#### Message::' + message);
        system.debug('#### Transaction Id::' + transactionid);
        
        if(transactionid!=null){
            
        
            Asset astObj = new Asset();
            
            System.debug('Invooked....'+pCode);
            User_Product_Detail__c uProd= new User_Product_Detail__c();
            uProd.Delivery_Status__c='Order Placed';
            uProd.Price__c=Integer.valueOf(price);
            uProd.Description__c=address;
            uProd.Product_Id__c=prodCode;        
            uProd.Quantity__c=Integer.valueOf(quanty);
            uProd.Email_Id__c=emailId;
            uProd.Phone_Number__c=phoneNum; 
            uProd.Payment_Id__c=transactionid;
            try{
                uProd.user_Id__c= UserInfo.getUserId() ;
            }catch(Exception e){}
            if(String.isBlank(uProd.user_Id__c)){
                uProd.user_Id__c=[select id from User where id='00536000000I8Vi'].Id;// It will be the Guest user
            }
            //if(!String.isBlank(sessionId)){uProd.Order_Id__c=sessionId;}                
            insert uProd;
            
            Shipping__c shipObj= new Shipping__c();
            shipObj.Customer_Phone_Number__c=phoneNum;
            shipObj.Estimated_Delivery_Date__c=System.now()+7;
            shipObj.Ordered_Date__c=System.Now();
            shipObj.Product__c=prodCode;
            shipObj.Shipping_Address__c=address;
            insert shipObj;
            
            if(!String.isBlank(prodCode)){
                astObj=[select id,Description,Recent_Order__c,Quantity,Status,Product2Id from Asset where Product2Id=:prodCode limit 1];
            }
            
            if(astObj!=null){
                if(astObj.Quantity>=Integer.valueOf(quanty)){
                    astObj.Quantity=astObj.Quantity-Integer.valueOf(quanty);
                    system.debug('@@@'+astObj.Quantity);
                    if(astObj.Quantity==0){             
                        astObj.Status='Obsolete'; 
                        astObj.Description='No more products found in Inventory'; 
                        astObj.Recent_Order__c=uProd.Id;
                    }   
                    update astObj;              
                }else if(astObj.Quantity<Integer.valueOf(quanty)){ 
                    if(astObj.Quantity<0)astObj.Quantity=0;
                    astObj.Description='There is a Shortage of '+(Integer.valueOf(quanty)-astObj.Quantity)+' products';
                    astObj.Status='Obsolete';
                    astObj.Quantity=astObj.Quantity-Integer.valueOf(quanty);
                    astObj.Recent_Order__c=uProd.Id;
                    update astObj;
                }
            } 
        
        }                
        return transactionid;        
        
    }
    
    public void selectedProductSummary(){           
            pCode=apexpages.currentpage().getparameters().get('pCode');
            sessionId=apexpages.currentpage().getparameters().get('sessionId');
            String stng = apexpages.currentpage().getparameters().get('qty');
            
            if(!String.isBlank(stng)){              
                qty =Integer.valueOf(stng); 
            }else{
                qty=0;
            }
            
            /*if(String.isBlank(sessionId)){
                   sessionId='guestuser@gmail.com'; 
            }*/
            if(!String.isBlank(pCode)){
                prodInfo=[select id,name,Family,Description,ProductCode,Price__c,image_URL__c from Product2 where id=:pCode];                
                /*if(!String.isBlank(sessionId)){
                 eCommerce_User_Records__c eRec=[select id,userName__c from eCommerce_User_Records__c where Username__c=:sessionId];                 
                 if(eRec!=null){
                     loggedInUserId=eRec.Id;   
                 }
                }    */            
            }

            if(Integer.valueof(qty)<100 && prodInfo!=null){
                totalPrice=Integer.valueOf(prodInfo.Price__c*Integer.valueof(qty));
            } 
            
    } 
    
    @RemoteAction
    public static String registerUser(String firstName,String lastName,String emailId){
        
        //create Contact record for portal user
        Contact newUser = new Contact();
        newUser.firstName=firstName;
        newUser.lastName=lastName;
        newUser.Email=emailId;
        newUser.AccountId=[select id from Account where name='Guest User' limit 1].Id;
        //newUser.Description=delAddr;                
        System.debug('####'+firstName+'\n'+lastName);
        //newUser.ownerId=[select id from User where name like '%Integration User%' limit 1].Id;
        try{
                insert newUser;
        }catch(Exception e){
            return 'exception found'+e.getMessage();
        }
        
        
        
        //Create a portal user with Contact
        User userObj= new User();               
        userObj.LastName=lastName;
        userObj.Alias=lastName.substring(0, 3);
        userObj.Email=emailId;
        userObj.CommunityNickname=lastName;        
        userObj.ProfileId=[select id,Name from Profile where Name='Customer Community Login User' limit 1].Id;    
        //userObj.Phone='999';
        userObj.isActive=true; 
        String userName=firstName+lastName;userName=userName.replaceAll('\\s','');
        system.debug('userName---'+firstName+lastName+'@demo.com');
        userObj.userName=userName+'@demo.com';
        userObj.EmailEncodingKey='ISO-8859-1';
        userObj.LanguageLocaleKey=' en_US';
        userObj.LocaleSidKey='en_US';
        userObj.TimeZoneSidKey='GMT';
        userObj.contactId=newUser.id;
        
        try{
                insert userObj;
        }catch(Exception e){
            return 'exception found'+e.getMessage();
        }
        
        system.resetPassword(userObj.Id,true);
        
        return 'Thank you! Please confirm your email address.';
        
    }  
    
    @RemoteAction
    public static PageReference login(String username,String password) {
        String startUrl = ApexPages.currentPage().getUrl();
        return Site.login(username, password, startUrl);
    }

 
}