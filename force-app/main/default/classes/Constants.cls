public with sharing class Constants{
    public Constants(){
    }

    public static Integer DEFAULT_ROWS = 5;
    public static String SELECT_ONE = Label.Select_One;
    public static String INVENTORY_LEVEL_LOW = Label.Inventory_Level_Low;
    public static List<String> PRODUCT_FAMILY = getGlobalPicklistValues('Product2', 'Family');
    public static String DRAFT_ORDER_STATUS = 'Draft';
    public static String ACTIVATED_ORDER_STATUS = 'Activated';
    public static String INVENTORY_ANNOUNCEMENTS = 'Inventory Announcements';
    public static String ERROR_MESSAGE = 'An error has occurred, please take a screenshot with the URL and send it to IT.';
    public static String STANDARD_PRICEBOOK_ID = '';
    
    public static List<String> getGlobalPicklistValues(String objectName, String fieldName){
        List<String> picklistValueList = new List<String>();
        for (Schema.PicklistEntry pickListEntry : Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap().get(fieldName).getDescribe().getPicklistValues()){
            picklistValueList.add(pickListEntry.getLabel());
        }
        return picklistValueList;
    }
}