@isTest (seeAllData=false)
public with sharing class PriceBookTest {
    public PriceBookTest() {

    }
    static TestMethod void PriceBook_UnitTest(){
        Test.startTest();
        String priceBookId = Test.getStandardPricebookId();
        system.debug('priceBookId = '+priceBookId);
        Test.stopTest();
    }
}
