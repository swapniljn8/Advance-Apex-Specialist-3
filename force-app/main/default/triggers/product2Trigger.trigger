/**
 * @name product2Trigger
 * @description Trigger to notify staff of low levels of inventory
**/
trigger product2Trigger on Product2 (
    before insert,
    before update,
    before delete,
    after insert,
    after update,
    after delete,
    after undelete
) {
    try {//no context variable check, //bulkification
        if(trigger.isAfter) {
            if(trigger.isUpdate) {
                Product2Helper.AfterUpdate((List<Product2>)Trigger.new);
            }
        }        
    } catch ( Exception e ){
        //A good developer would do something with this Exception!
    }
}