Feature: 
  As an i-meeting user
  I want to see details page of a meeting
  So I can see the details of a particular meeting

Scenario: 
  Navigating to MyMeetingsDetails Page
Given I launch the app
When I touch "My Meetings"
Then I should see a navigation bar titled "My Meetings"
And I wait for 5 second
And I touch the first table cell
And I wait for 5 second
Then I should see a navigation bar titled "Event Details"


