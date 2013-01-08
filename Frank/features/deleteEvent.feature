Feature: 
  As an i-meeting user
  I want to Delete the meeting
  So I can cancel or reschedule a meeting

Scenario: 
  Deleting An Event
Given I launch the app
When I touch "My Meetings"
And I wait to see "Empty list"
Then I note the number of meetings
And I touch the button marked "Delete"
And I wait for 2 second
Then I should see an alert view with the message "Are you sure you want to delete the event?"
