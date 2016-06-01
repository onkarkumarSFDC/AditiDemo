public class eCommerceExtension{

    public eCommerceExtension(eCommerceHomePage controller) {

    }

    
    public static Integer items{get;set;}
    
    @RemoteAction
    public static void setQuantity(Integer quant){        
        items=quant;
        system.debug('$$$'+items);
    }   

}