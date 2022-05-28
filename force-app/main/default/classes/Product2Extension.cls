public with sharing class Product2Extension{
    public List<ProductWrapper> productsToInsert{ get; set; }

    public String family{ get; set; }

    //Product2
    public String unitPrice{ get; set; }

    //PriceBookEntry
    public Product2Extension(ApexPages.StandardController controller){
        productsToInsert = new List<ProductWrapper>();
        system.debug('productsToInsert = ' + productsToInsert.size());
        addRows();
    }

    public List<SelectOption> getFamilyOptions(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption(Constants.SELECT_ONE, Constants.SELECT_ONE));
        for (Schema.PicklistEntry picklist : Constants.PRODUCT_FAMILY){
            options.add(new SelectOption(picklist.getLabel(), picklist.getLabel()));
        }
        return options;
    }

    public void addRows(){
        for (integer i = 0; i < Constants.DEFAULT_ROWS; ++i){
            productsToInsert.add(new ProductWrapper());
        }
    }

    public List<ChartHelper.ChartData> GetInventory(){
        return ChartHelper.GetInventory();
    }

    //insert productsToInsert;
    //If successful clear the list and display an informational message
    public PageReference save(){
        Savepoint sp = Database.setSavepoint();
        List<Product2> product2Records = new List<Product2>();
        List<PriceBookEntry> priceBookEntryRecords = new List<PriceBookEntry>();
        for (ProductWrapper productWrapper : productsToInsert){
            Product2 prod;
            PriceBookEntry priceBook;
            system.debug('productWrapper=' + productWrapper);
            if (productWrapper.productRecord != null){
                system.debug('product inside if=' + productWrapper.productRecord);
                if (String.isNotBlank(productWrapper.productRecord.Name) && String.isNotBlank(productWrapper.productRecord.Family) && String.isNotBlank(String.valueOf(productWrapper.productRecord.isActive)) && productWrapper.productRecord.Initial_Inventory__c != null && Constants.SELECT_ONE != productWrapper.productRecord.Family){
                    prod = new Product2(Name = productWrapper.productRecord.Name, Family = productWrapper.productRecord.Family, isActive = productWrapper.productRecord.isActive, Initial_Inventory__c = productWrapper.productRecord.Initial_Inventory__c);
                    product2Records.add(prod);
                }
            }
            if (prod != null && productWrapper.pricebookEntryRecord != null && productWrapper.pricebookEntryRecord.unitPrice != null){
                system.debug('productEntry inside if=' + productWrapper.pricebookEntryRecord);
                //priceBook.Product2Id   = ;
                priceBook = new PriceBookEntry(Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID, unitPrice = productWrapper.pricebookEntryRecord.unitPrice);
                priceBookEntryRecords.add(priceBook);
            }
        }
        if (product2Records.size() > 0){
            insert product2Records;
            for (integer i = 0; i < product2Records.size(); ++i){
                priceBookEntryRecords[i].Product2Id = product2Records[i].id;
            }
            if (NULL != priceBookEntryRecords && priceBookEntryRecords.size() > 0){
                insert priceBookEntryRecords;
            }
            apexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, product2Records.size() + ' Inserted'));
        } else{
            Database.rollback(sp);
            apexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, Constants.ERROR_MESSAGE));
        }
        productsToInsert.clear();   //Do not remove
        addRows();
        return null;
    }

    public class ProductWrapper{
        public Product2 productRecord{ get; set; }

        public PriceBookEntry pricebookEntryRecord{ get; set; }

        public ProductWrapper(){
            productRecord = new Product2(Initial_Inventory__c = 0);
            pricebookEntryRecord = new PriceBookEntry(UnitPrice = 0.0);
        }

    }

}