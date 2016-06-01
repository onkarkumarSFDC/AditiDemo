trigger updateImageURL on Attachment (after insert,after update) {

    List<Product2> prdList = new List<Product2>();
    for(Attachment objAttch : Trigger.New){
      
     if('DisplayImage'.equals(objAttch.Name)){
        Product2 ob = new Product2();
        ob.Id = objAttch.ParentId;
        ob.Image_URL__c = 'https://c.na30.content.force.com/servlet/servlet.FileDownload?file='+objAttch.id;
        prdList.add(ob);
     }
    }
    update prdList;

}