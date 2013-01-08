
def app_path
  ENV['APP_BUNDLE_PATH'] || (defined?(APP_BUNDLE_PATH) && APP_BUNDLE_PATH)
end

Given /^I launch the app$/ do
  # latest sdk and iphone by default
  launch_app app_path
end

Given /^I launch the app using iOS (\d\.\d)$/ do |sdk|
  # You can grab a list of the installed SDK with sim_launcher
  # > run sim_launcher from the command line
  # > open a browser to http://localhost:8881/showsdks
  # > use one of the sdk you see in parenthesis (e.g. 4.2)
  launch_app app_path, sdk
end

Given /^I launch the app using iOS (\d\.\d) and the (iphone|ipad) simulator$/ do |sdk, version|
  launch_app app_path, sdk, version
end

Given /^I note the number of meetings$/ do
  @count = frankly_map("view:'CalendarCell'",'tag').count
end

Given /^I should see same number of rows as earlier$/ do
  @count.should == frankly_map("view:'CalendarCell'",'tag').count
end

Given /^I should see less number of rows as earlier$/ do
  @deleted = @count - 1
  @deleted == frankly_map("view:'CalendarCell'",'tag').count
end

When /^I wait to see "(.*?)" element$/ do |element|
  wait_until(:message => "The specified element #{element} did not appear!") {
    element_exists(element)
  }
end
