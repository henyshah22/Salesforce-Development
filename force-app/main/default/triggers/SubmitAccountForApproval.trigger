trigger SubmitAccountForApproval on Account (after insert) {
    for (Account acc : Trigger.new) {
        Approval.ProcessSubmitRequest request = new Approval.ProcessSubmitRequest();
        request.setComments('Account submitted for approval');
        request.setObjectId(acc.Id);
        request.setSubmitterId(UserInfo.getUserId());
        Approval.ProcessResult result = Approval.process(request);
    }
}