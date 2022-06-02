public class Product2Helper {

    /**
     * @name COLLABORATION_GROUP
     * @description List of CollaborationGroup used in both business and test logic
    **/
    static List<CollaborationGroup> COLLABORATION_GROUP = [
        SELECT Id
        FROM CollaborationGroup
        WHERE Name =: Constants.INVENTORY_ANNOUNCEMENTS
        OR Name = :('TEST'+Constants.INVENTORY_ANNOUNCEMENTS)
        LIMIT 1
    ];

    /**
     * @name afterUpdate
     * @description called by product2 Trigger on After Update
     * @param List<Product2> newList
     * @param List<Product2> oldList
    **/
    //ToDo: Declare a List of Product2 records named needsAnnouncement

    //ToDo: Declare a Map of Strings to Inventory_Setting__mdt records

    //ToDo: Loop through a query of Inventory_Setting__mdt records and populate the Map with Name as the key

    //ToDo: Loop through the Products in newList
    // Use the corresponding Inventory Setting record to determine the correct Low Quantity Alert
    // If the Product's Quantity Remaining has been changed to less than the Low Quantity Alert
    //      add it to the needsAnnouncement list

    //ToDo: Pass records to the postAlerts method
    public static void AfterUpdate(List<Product2> newProductList){
        List<Product2> needsAnnouncement = new List<Product2>();
        Map<String,Integer> inventoryMap = new Map<String,Integer>();
        for(Inventory_Setting__mdt inventory : [SELECT id,MasterLabel,Low_Quantity_Alert__c FROM Inventory_Setting__mdt]) {
            inventoryMap.put(inventory.MasterLabel, Integer.valueOf(inventory.Low_Quantity_Alert__c));
        }
        for(Product2 prod : newProductList) {
            if(prod.Quantity_Remaining__c < inventoryMap.get(prod.Family)) {
                needsAnnouncement.add(prod);
            }
        }
        postAlerts(needsAnnouncement);
    }

    /**
     * @name postAlerts
     * @description called by product2 Trigger on After Update
     * @param List<Product2> productList
     **/
    // ToDo: Construct a new AnnouncementInput for the Chatter Group so that it:
        // expires in a day
        // does not notify users via email.
        // and has a text body that includes the name of the product followed by the INVENTORY_LEVEL_LOW constant
    // ToDo: Create and enqueue an instance of the announcementQueuable class with the list of Products
    public static void postAlerts(List<Product2> productList){
        List<ConnectApi.AnnouncementInput> toPost = new List<ConnectApi.AnnouncementInput>();
        for ( Product2 p : productList ){
            ConnectApi.AnnouncementInput newAnnouncement = new ConnectApi.AnnouncementInput();
            ConnectApi.MessageBodyInput messageInput = new ConnectApi.MessageBodyInput();
            messageInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
            ConnectApi.TextSegmentInput textSegment = new ConnectApi.TextSegmentInput();
            textSegment.text = p.Name + Constants.INVENTORY_LEVEL_LOW;
            messageInput.messageSegments.add(textSegment);
            newAnnouncement.body= messageInput;
            newAnnouncement.expirationDate= datetime.now().addDays(1);
            newAnnouncement.sendEmails=false;
            newAnnouncement.ParentID=COLLABORATION_GROUP[0].Id;//to product id
            //newAnnouncement.ParentID=p.Id;//to product id
            toPost.add(newAnnouncement);
        }
        //ConnectApi.Announcements.postAnnouncement(null, toPost);
        AnnouncementQueueable q = new AnnouncementQueueable();
        q.toPost = toPost;
        ID jobID = System.enqueueJob(q);

            
    }
}