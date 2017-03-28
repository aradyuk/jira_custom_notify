#!/usr/bin/env ruby 

require 'pp'
require 'jira-ruby'
require 'dotenv'
require 'mail'
require 'colorize'
require 'json'

# Create .env in the root and specify your vars there, then load it here:
Dotenv.load('.env')

# Set some email configurations:
mail_options = {
      	    :address              => ENV['MAIL_ADDRESS'],
            :port                 => ENV['MAIL_PORT'],
            :user_name            => ENV['MAIL_USER'],
            :password             => ENV['MAIL_PASS'],
            :authentication       => 'plain',
            :enable_starttls_auto => true  
					}

Mail.defaults do
 delivery_method :smtp, mail_options
end

# Set some configurations for JIRA access:
jira_options = {
            :username => ENV['JIRA_USER'],
            :password => ENV['JIRA_PASS'],
            :site     => ENV['JIRA_URI'],
            :context_path => '',
            :auth_type => :basic,
            :use_ssl => false
          }

# Make connect:
client = JIRA::Client.new(jira_options)

# Build array with issues from all projects except those that are PATTERN's:
issues = []; client.Issue.all.each { |i| issues << i if i.project.name.include?('Pattern') != true && i.customfield_10100}

# Set today's date:
date_today = Time.now.to_s[0..9]

# Delete if difference between start and current date less than 5 days:
issues.delete_if { |i| (Date.parse(date_today.gsub(/\-/, '/')).mjd - Date.parse(i.customfield_10100[0..9].gsub(/\-/, '/')).mjd) < 5 }

# Keep if state is 'Open' or 'To do':
issues.keep_if { |i| i.status.name.match('Open') || i.status.name.match('To do') }

# Print statistic # Should comment to "Send mail" section if you don't want to display statistic in the terminal:
puts "---------------------------------------"

puts "\n Overdue issues count: #{issues.count}".underline.red

issues.each do |i|

	puts "\n Issue:               #{i.summary.green} (Project: #{i.project.name})"
	puts " issue status:        #{i.status.name.blue}"
	puts " Assign to:           #{i.assignee.present? ? JSON.load(i.assignee.to_json)["displayName"] : "Unassigned"}"
	puts " Planning start date: #{i.customfield_10100[0..9]}"
	puts " Date today:          #{date_today}"
	puts " Link:                http://jira-marketing.altoros.com/projects/#{i.project.key}/issues/#{i.key}?filter=allopenissues"

 puts "\n---------------------------------------"

 # Send mail:
 Mail.deliver do
       to 'aliaksandr.radziuk@altoros.com'
     from ENV['MAIL_ADDRESS']
  subject 'Overdue issues in Jira-Marketing'
     body "
	Overdue issues count: #{issues.count} (More than 5 days without any action)
	Issue:                        #{i.summary} (Project: #{i.project.name}
	Issue status:               #{i.status.name}
	Assign to:                   #{i.assignee.present? ? JSON.load(i.assignee.to_json)["displayName"] : "Unassigned"}
	Planning start date:     #{i.customfield_10100[0..9]}
	Date today:                #{date_today}
	Link:                          http://jira-marketing.altoros.com/projects/#{i.project.key}/issues/#{i.key}?filter=allopenissues\n"
 end
end
