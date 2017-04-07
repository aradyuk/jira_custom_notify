# Notification script which works with JIRA API: #

Create list with overdue tasks and send to PM.

### Requirements ###
ruby 2.3

```sh
apt-add-repository ppa:brightbox/ruby-ng
```

```sh
apt-get update && apt-get install ruby2.3 ruby2.3-dev -y
```

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
### Add to crontab (example) ###

```sh 
crontab -e
```
```
35 9 * * 1-5 /bin/bash -l -c "cd /$path_to_script && ./main.rb" >> /dev/null 2>&1
```
