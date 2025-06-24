trigger UpdateRatingAsHot on Lead (before insert) {
    for (Lead lead : Trigger.new) {
        lead.Rating = 'Hot';	
    }
}