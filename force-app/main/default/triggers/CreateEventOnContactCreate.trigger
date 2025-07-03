trigger CreateEventOnContactCreate on Contact (after insert) {
    List<Event> events = new List<Event>();
    for (Contact newContact : Trigger.new) {
        Event newEvent = new Event(
            Subject = 'New Contact Created',
            WhoId = newContact.Id,
            StartDateTime = Datetime.now(),
            EndDateTime = Datetime.now().addMinutes(60)
            );
        events.add(newEvent);
    }
        insert events;
}

// trigger CreateEventOnContactCreate on Contact (after undelete) {

// }