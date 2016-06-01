public class siteHomecontroller {

    public String secure { get; set; }


    public List<Product2> getAllProduct(){
        return [SELECT Brand__c,Category__c,CreatedDate,Family,Id,Name,Price__c,ProductCode,Image_URL__c FROM Product2];
    } 
    
    @RemoteAction
    public static String registerUser(String firstName,String lastName,String emailId){
        
        //create Contact record for portal user
        Contact newUser = new Contact();
        newUser.firstName=firstName;
        newUser.lastName=lastName;
        newUser.Email=emailId;
        newUser.Phone='99999';
        //newUser.Description=delAddr;                
        System.debug('####'+firstName+'\n'+lastName);        
        insert newUser;
        
        
        //Create a portal user with Contact
        User userObj= new User();               
        userObj.LastName=lastName;
        userObj.Alias=lastName.substring(0, 3);
        userObj.Email=emailId;
        userObj.CommunityNickname=lastName;        
        userObj.ProfileId=[select id,Name from Profile where Name='Customer Community Login User' limit 1].Id;    
        userObj.Phone='999';
        userObj.isActive=true;        
        userObj.userName=firstName+lastName+'@demo.com';
        userObj.EmailEncodingKey='ISO-8859-1';
        userObj.LanguageLocaleKey=' en_US';
        userObj.LocaleSidKey='en_US';
        userObj.TimeZoneSidKey='GMT';
        insert userObj;
        
        return String.valueOf(userObj.Id);
        
    }
}