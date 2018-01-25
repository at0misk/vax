require 'capybara'
require "selenium/webdriver"
require 'rspec'
require 'rails_helper'
# include Capybara::DSL

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

Capybara.register_driver :headless_chrome do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    chromeOptions: { args: %w(headless disable-gpu) }
  )

  Capybara::Selenium::Driver.new app,
    browser: :chrome,
    desired_capabilities: capabilities
end

Capybara.javascript_driver = :headless_chrome

session = Capybara::Session.new(:chrome)
# IDs
ids = ['asdfasfasdfasdf', '59983', 'asdfasdfasdf']
# Login
session.visit "https://login.www.vaxvacationaccess.com/Default.aspx?anchorstore=none"
session.find_field('Agency Number:').set('05824840')
session.find_field('User Name:').set('Ron Archer')
session.find_field('ctl00_ContentPlaceHolder_ctl00_ctl01_LoginCtrl_Password').set('Oceanview4148')
session.click_button('Login')
session.find("#gear").click
# Loop through and attempt to delete
ids.each do |val|
	session.visit('https://login.www.vaxvacationaccess.com/ManageUsers/ManageUsers.aspx')
	session.find_field('User Name:').set("#{val}")
	session.click_button('Find Users')
	puts session.has_text?("No users found.")
	if session.has_text?("No users found.")
		puts "No User Found"
		next
	else
		puts "User Found"
		session.click_button('Remove Account')
		next
	end
end
# fill_in('ctl00$ContentPlaceHolder$ctl00$ctl01$LoginCtrl$UserName', with: 'Ron Archer')
# fill_in('ctl00$ContentPlaceHolder$ctl00$ctl01$LoginCtrl$Password', with: 'Oceanview4148')


# if session.has_content?("Login")
#   puts "All shiny, captain!"
# else
#   puts ":( no tagline fonud, possibly something's broken"
#   exit(-1)
# end