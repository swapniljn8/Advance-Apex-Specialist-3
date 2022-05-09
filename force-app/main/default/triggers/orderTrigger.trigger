/**
 * @name orderTrigger
 * @description
**/
trigger orderTrigger on Order (
    before insert, after insert
    ,before update, after update
    ,before delete, after delete
    ,after undelete
) {
    try {
        //Update
        if(trigger.isAfter) {
            if ( Trigger.new != null ){
                OrderHelper.afterUpdate(Trigger.new, Trigger.oldMap);
            }
        }
        
    }catch ( Exception e ){
    
    }
}