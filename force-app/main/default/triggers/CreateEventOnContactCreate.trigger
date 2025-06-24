trigger CreateEventOnContactCreate on Contact (after insert) {
    List<Event> eventsToInsert = new List<Event>();
    for (Contact newContact : Trigger.new) {
        Event newEvent = new Event(
            Subject = 'New Contact Created: ' + newContact.FirstName + ' ' + newContact.LastName,
            WhoId = newContact.Id,
            StartDateTime = Datetime.now(),
            EndDateTime = Datetime.now().addMinutes(60)
            );
        eventsToInsert.add(newEvent);
    }
    if (!eventsToInsert.isEmpty()) {
        insert eventsToInsert;
    }
}