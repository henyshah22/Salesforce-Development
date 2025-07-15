public with sharing class GlobalRecordSearchController {

    @AuraEnabled(cacheable=true)
    public static List<ObjectWrapper> searchRecords(String searchTerm, List<String> objectNames) {
        List<ObjectWrapper> wrapperList = new List<ObjectWrapper>();
        if (String.isBlank(searchTerm) || objectNames == null || objectNames.isEmpty()) {
            return wrapperList;
        }

        String objectQuery = '';
        for (String obj : objectNames) {
            if (obj == 'Account') {
                objectQuery += 'Account(Name WHERE Name LIKE \'%' + searchTerm + '%\' LIMIT 5), ';
            } else if (obj == 'Contact') {
                objectQuery += 'Contact(Name WHERE Name LIKE \'%' + searchTerm + '%\' LIMIT 5), ';
            } else if (obj == 'Opportunity') {
                objectQuery += 'Opportunity(Name WHERE Name LIKE \'%' + searchTerm + '%\' LIMIT 5), ';
            }
        }
        objectQuery = objectQuery.removeEnd(', ');

        String soslQuery = 'FIND \'' + searchTerm + '\' IN ALL FIELDS RETURNING ' + objectQuery;
        List<List<sObject>> searchList = Search.query(soslQuery);

        Integer index = 0;
        for (String obj : objectNames) {
            List<sObject> sObjectList = searchList[index];
            for (sObject sObj : sObjectList) {
                ObjectWrapper objWrapper = new ObjectWrapper();
                objWrapper.Id = sObj.Id;
                objWrapper.Name = String.valueOf(sObj.get('Name'));
                objWrapper.Type = obj;
                if (obj == 'Account') {
                    objwrapper.Icon = 'standard:account';
                } else if (obj == 'Contact') {
                    objwrapper.Icon = 'standard:contact';
                } else if (obj == 'Opportunity') {
                    objwrapper.Icon = 'standard:opportunity';
                }
                wrapperList.add(objWrapper);
            }
            index++;
        }

        return wrapperList;
    }

    public class ObjectWrapper {
        @AuraEnabled 
        public String Id {get; set;}
        @AuraEnabled 
        public String Name {get; set;}
        @AuraEnabled 
        public String Type {get; set;}
        @AuraEnabled 
        public String Icon {get; set;}
    }
}
