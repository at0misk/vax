class SessionsController < ApplicationController

	def import
		Agent.destroy_all
		Agent.import(params[:file])
		flash[:imported] = "IDs Imported"
		redirect_to "/"
	end

	def root
	end

	def run
		puts "================================"
		puts "======== STARTING RUN! ========="
		puts "================================"
		# require 'capybara'
		# require "selenium/webdriver"
		# require 'rspec'
		# require 'rails_helper'
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

		deleted = 0
		notfound = 0

		Capybara.javascript_driver = :headless_chrome
		Capybara.default_wait_time = 60

		capy_session = Capybara::Session.new(:chrome)
		# IDs
		ids = Agent.all.pluck(:agent_id)
		# Login
		capy_session.visit "https://login.www.vaxvacationaccess.com/Default.aspx?anchorstore=none"
		capy_session.find_field('Agency Number:').set(Figaro.env.agency)
		capy_session.find_field('User Name:').set(Figaro.env.username)
		capy_session.find_field('ctl00_ContentPlaceHolder_ctl00_ctl01_LoginCtrl_Password').set(Figaro.env.password)
		capy_session.click_button('Login')
		# capy_session.find("#gear").click
		# Loop through and attempt to delete
		ids.each do |val|
			capy_session.visit('https://login.www.vaxvacationaccess.com/ManageUsers/ManageUsers.aspx')
			capy_session.find_field('User Name:').set("#{val}")
			capy_session.click_button('Find Users')
			puts capy_session.has_text?("No users found.")
			if capy_session.has_text?("No users found.")
				puts "No User Found"
				notfound += 1
			else
				puts "User Found"
				deleted += 1
				puts deleted
				capy_session.click_button('Remove Account')
				if capy_session.has_text?("Removed account for")
					puts "continue"
				end
			end
		end
		# fill_in('ctl00$ContentPlaceHolder$ctl00$ctl01$LoginCtrl$UserName', with: 'Ron Archer')
		# fill_in('ctl00$ContentPlaceHolder$ctl00$ctl01$LoginCtrl$Password', with: 'Oceanview4148')


		# if capy_session.has_content?("Login")
		#   puts "All shiny, captain!"
		# else
		#   puts ":( no tagline fonud, possibly something's broken"
		#   exit(-1)
		# end
		session[:deleted] = deleted
		session[:notfound] = notfound
		redirect_to '/'
		# render :json => ['Deleted' => "#{deleted}", 'Not Found' => "#{notfound}"]
	end

	def login
		@user = User.find_by(username: params['username'])
		if @user
			if @user.authenticate(params['password'])
				session[:user_id] = @user.id
			else
				flash[:error] = "Incorrect Password"
			end
		else
			flash[:error] = "No User Found"
		end
		redirect_to '/'
	end
end
