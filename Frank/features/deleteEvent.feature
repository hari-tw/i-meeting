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
When I see "Delete" button and touch it

