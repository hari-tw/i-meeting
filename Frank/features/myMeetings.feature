Feature: 
  As an i-meeting user
  I want to see myMeetings page
  So I can see my scheduled meetings for the day

Scenario: 
  Navigating to MyMeetings Page
Given I launch the app
When I touch "My Meetings"
Then I should see a navigation bar titled "My Meetings"
