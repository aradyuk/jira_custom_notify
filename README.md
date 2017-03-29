# Notification script which works with JIRA API: #

Create list with overdue tasks and send to PM.

### Requirements ###
ruby 2.3

### Gem list ###
`pp`
`jira-ruby`
`dotenv`
`mail`
`colorize`
`json`

```sh
gem install $gem_name
```

### Create ".env" in the root and add credentials data and settings: ###
```
#JIRA:
JIRA_URI=''
JIRA_USER=''
JIRA_PASS=''
#MAIL:
MAIL_USER=''
MAIL_PASS=''
MAIL_PORT=''
MAIL_ADDRESS=''
```
