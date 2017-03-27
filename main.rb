#!/usr/bin/env ruby 

require 'pp'
require 'jira-ruby'
require 'dotenv'

# Create .env in the root and specify your vars there, then load it here:
Dotenv.load('.env')

# Set some configurations for JIRA access:
options = {
            :username => ENV['JIRA_USER'],
            :password => ENV['JIRA_PASS'],
            :site     => ENV['JIRA_URI'],
            :context_path => '',
            :auth_type => :basic,
            :use_ssl => false
          }

# Make connect:
client = JIRA::Client.new(options)

# Build array with issues from all projects except those that are PATTERN's:
issues = []; client.Issue.all.each { |i| issues << i if i.project.name.include?('Pattern') != true && i.customfield_10100}

date_today = Time.now.to_s[0..9].gsub(/\-/, '/')

# Delete if difference between start and current date less than 5 days:
issues.delete_if { |i| (Date.parse(date_today).mjd - Date.parse(i.customfield_10100[0..9].gsub(/\-/, '/')).mjd) < 5 }

# Keep if state is 'Open' or 'To do':
issues.keep_if { |i| i.status.name.match('Open') || i.status.name.match('To do') }

puts "---------------------------------------"

puts "\n Overdue issues count: #{issues.count} (More than 5 days without any action)"

issues.each do |i|
	puts "\n Issue: #{i.summary} (Project: #{i.project.name})"
	puts " issue status: #{i.status.name}"
	puts " Date today:          #{date_today}"
	puts " Planning start date: #{i.customfield_10100[0..9].gsub(/\-/, '/')} "
	puts " Link: #{i.remotelink.all}"
end

puts "\n---------------------------------------"

