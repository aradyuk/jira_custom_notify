#!/usr/bin/env ruby 

require 'rubygems'
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

# CONSTANTA with regular expression:  

PATTERN = /[PATTERN]/

# Build array with issues from all projects except those that are PATTERN's:

issues = []; issues << client.Issue.all.each {|i| issues << i if i.key != PATTERN}


#puts " Deadline: #{issues[1].duedate}"
puts " Updated: #{issues[1].updated[0..9]}"
puts " Planning start date: #{issues[1].customfield_10100[0..9]}"

difference = Date.parse(issues[1].updated[0..9].gsub(/\-/, '/')).mjd - Date.parse(issues[1].customfield_10100[0..9].gsub(/\-/, '/')).mjd

puts " The difference is: #{difference}"
