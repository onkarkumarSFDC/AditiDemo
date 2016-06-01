public class SlideShow {

 public List<Photo__c> photo {get; set;}
    public String imageTag {get; set;}
    public String photoUrl {get; set;}
    public Integer strt=0,ed=1,len=0,i=0,indx=0;
   
    public String tmp {get; set;}
   
    public SlideShow(ApexPages.StandardController controller)
    {          
      String sql = 'SELECT image__c FROM Photo__c';
      photo = Database.query(sql);
      imageTag = photo.get(indx).image__c;
     
      strt = imageTag.indexOf('src=',0) + 5;
      ed = imageTag.lastIndexOf('alt=') - 2;
      tmp = imageTag.substring(strt,ed);
    }          
   
    public void prev()
    {
      if(indx != 0)
      {
      indx = indx - 1;
      String sql = 'SELECT image__c FROM Photo__c';
      photo = Database.query(sql);
      imageTag = photo.get(indx).image__c;
     
      strt = imageTag.indexOf('src=',0) + 5;
      ed = imageTag.lastIndexOf('alt=') - 2;
      tmp = imageTag.substring(strt,ed);
      }
    }   

    public void nxt()
    {  
      len = [SELECT COUNT() FROM Photo__c];
      if(indx != (len-1))
      {
      indx = indx + 1;
      String sql = 'SELECT image__c FROM Photo__c';
      photo = Database.query(sql);
      imageTag = photo.get(indx).image__c;
     
      len =imageTag.length();
      strt = imageTag.indexOf('src=',0) + 5;
      ed = imageTag.lastIndexOf('alt=') - 2;
      tmp = imageTag.substring(strt,ed);
      }     
    }       
}