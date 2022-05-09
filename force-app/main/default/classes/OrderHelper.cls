public without sharing class OrderHelper{
    /**
     * @name AfterUpdate
     * @description
     * @param List<Order> newList
     * @param List<Order> oldList
     * @return void
     **/
    public static void beforeInsert(){
    }

    public static void afterInsert(){
    }

    public static void beforeUpdate(){
    }

    public static void afterUpdate(List<Order> newList, Map<Id, Order> oldMap){
        List<Product2> product2List = new List<Product2>();
        Set<Id> orderIds = new Set<Id>();
        //select Id,Name Status, ActivatedDate,  from Order
        for (Order o : newList){
            if (oldMap.get(o.Id).Status != o.Status && o.Status == Constants.ACTIVATED_ORDER_STATUS && o.ActivatedDate != null){
                orderIds.add(o.Id);
            }
        }
        rollUpOrderItems(orderIds);
    }

    public static void beforeDelete(){
    }

    public static void afterDelete(){
    }

    public static void afterUndelete(){
    }

    /**
     * @name RollUpOrderItems
     * @description Given a set of Activated Order ids, query the child Order Items and related Products to calculate Inventory levels
     * @param Set<Id> activatedOrderIds
     * @return void
     **/
    public static void rollUpOrderItems(Set<Id> activatedOrderIds){
        Set<Id> productsId = new Set<Id>();
        //ToDo: Declare a Map named "productMap" of Ids to Product2 records
        
        //ToDo: Loop through a query of OrderItems related to the activatedOrderIds

        //ToDo: Populate the map with the Id of the related Product2 as the key and Product2 record as the value
        
        //ToDo: Loop through a query that aggregates the OrderItems related to the Products in the productMap keyset

        //ToDo: Perform an update on the records in the productMap
        for (OrderItem oi : [SELECT Id, Product2Id FROM OrderItem WHERE OrderId IN:activatedOrderIds]){
            productsId.add(oi.Product2Id);
        }
        Map<Id, Product2> productMap = new Map<Id, Product2>([select id,Quantity_Ordered__c from Product2 where Id IN:productsId]);
        for(AggregateResult result : [SELECT Product2Id, sum(Quantity) totalQuantity FROM OrderItem WHERE Product2Id IN:productMap.keySet() group by Product2Id]) {
            productMap.get((String)result.get('Product2Id')).Quantity_Ordered__c = Integer.valueOf(result.get('totalQuantity'));
        }
        
        if (ProductMap != null && ProductMap.size() > 0){
            update ProductMap.values();
        }
    }

}