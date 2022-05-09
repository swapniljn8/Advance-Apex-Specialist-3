public with sharing class Constants{
    public Constants(){
    }

    public final static Integer DEFAULT_ROWS = 5;
    public final static String SELECT_ONE = Label.Select_One;
    public final static String INVENTORY_LEVEL_LOW = Label.Inventory_Level_Low;
    //public final static List<Schema.PicklistEntry> PRODUCT_FAMILY = getGlobalPicklistValues('Product2', 'Family');
    public final static List<Schema.PicklistEntry> PRODUCT_FAMILY = Schema.getGlobalDescribe().get('Product2').getDescribe().fields.getMap().get('Family').getDescribe().getPicklistValues();
    public final static String DRAFT_ORDER_STATUS = 'Draft';
    public final static String ACTIVATED_ORDER_STATUS = 'Activated';
    public final static String INVENTORY_ANNOUNCEMENTS = 'Inventory Announcements';
    public final static String ERROR_MESSAGE = 'An error has occurred, please take a screenshot with the URL and send it to IT.';
    public static String STANDARD_PRICEBOOK_ID = '01s2w0000061s7fAAA';
    
    public static List<String> getGlobalPicklistValues(String objectName, String fieldName){
        List<String> picklistValueList = new List<String>();
        for (Schema.PicklistEntry pickListEntry : Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap().get(fieldName).getDescribe().getPicklistValues()){
            picklistValueList.add(pickListEntry.getLabel());
        }
        return picklistValueList;
    }
}