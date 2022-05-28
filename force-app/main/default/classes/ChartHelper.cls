public without sharing class ChartHelper{
    @AuraEnabled
    public static List<chartData> GetInventory(){
        //ToDo: Perform a calculation that aggregates active Products that have a positive Quantity_Remaining__c
        //  And return a list of chartData
        //  Where the name is the Product Family and the Qty is the sum of the Quantity_Remaining__c
        List<chartData> cht = new List<chartData>();
        AggregateResult[] groupedResults = [SELECT  SUM(Quantity_Remaining__c)Quantity, Family
                                            FROM Product2
                                            WHERE Quantity_Remaining__c > 0 AND IsActive = true
                                            GROUP BY Family];
        for (AggregateResult result : groupedResults){
            cht.add(new ChartData(String.valueOf(result.get('Family')), Decimal.valueOf(Integer.valueOf(result.get('Quantity')))));
        }
        return cht;
    }

    public class ChartData{
        public String name{ get; set; }

        public Decimal val{ get; set; }

        public ChartData(String name, Decimal val){
            this.name = name;
            this.val = val;
        }

    }

}