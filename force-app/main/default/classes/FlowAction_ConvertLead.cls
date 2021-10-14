public with sharing class FlowAction_ConvertLead {

    @invocableMethod(label='Lead Convert' description='Convert a Lead' category='Lead')
    public static List<FlowOutput> ConvertLead(List<FlowInput> inputs){
    
        String leadId           = inputs.get(0).leadId;
        String contactId        = inputs.get(0).contactId;
        String accountId        = inputs.get(0).accountId;
        String convertedStatus  = inputs.get(0).convertedStatus;
        Boolean noOpportunity   = inputs.get(0).noOpportunity;

        Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(leadId);
        lc.setConvertedStatus(convertedStatus);

        if (accountId != null){
            lc.setAccountId(accountId);
        } 

        if (contactId != null){
            lc.setContactId(contactId);
        } 

        if (noOpportunity == true){
            lc.setDoNotCreateOpportunity(noOpportunity);
        } 
        
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        System.assert(lcr.isSuccess());

        String newAccountId = accountId==null?lcr.getAccountId():null;
        String newContactId = contactId==null?lcr.getContactId():null;
        String newOpportunityId = lcr.getOpportunityId();

        FlowOutput output = new FlowOutput();
        output.newContactId = newContactId;
        output.newAccountId = newAccountId;
        output.newOpportunityId = newOpportunityId;

        List<FlowOutput> outputList = new List<FlowOutput>();
        outputList.add(output);

        return outputList;

    }

    public class FlowInput { 

        @invocableVariable(label='Existing Lead ID' required=true)
        public String leadId;

        @invocableVariable(label='Existing Contact ID' required=false)
        public String contactId;

        @invocableVariable(label='Existing Account ID' required=false)
        public String accountId;

        @invocableVariable(label='Converted Lead Status' required=true)
        public String convertedStatus;

        @invocableVariable(label='Do Not Create Opportunity')
        public Boolean noOpportunity;   
    }

    public class FlowOutput {

        @invocableVariable (label='New Contact ID')
        public String newContactId;

        @invocableVariable (label='New Account ID')
        public String newAccountId;

        @invocableVariable (label='New Opportunity ID')
        public String newOpportunityId;
    }
}