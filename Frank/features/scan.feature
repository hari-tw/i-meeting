Feature: 
  As an i-meeting user
  I want to go to scan page
  So I can scan the qr code of meeting room

Scenario: 
  Navigating to Scan Page
Given I launch the app
When I touch "Scan"
Then I should see a navigation bar titled "iMeeting"