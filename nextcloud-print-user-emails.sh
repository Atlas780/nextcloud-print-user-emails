#!/bin/bash
# Author: Atlas
# Function: Script for printing out user emails to copy-paste a list for announcements.
# Last change: 17.10.2022

#add users to ignore for printout to this array (seperate with spaces)
#ignoreuser=(xyz xyz ...)

touch /tmp/userlist.txt
sudo -u www-data /usr/bin/php /var/www/nextcloud/occ user:list > /tmp/userlist.txt

# Modify temporary userlist for using in loop (remove everything except username)
sed -i 's/\(\:\)\(.*\)/\1/' /tmp/userlist.txt
sed -i 's/\://g' /tmp/userlist.txt
sed -i 's/  - //g' /tmp/userlist.txt

# Filter users to ignore
for i in "${ignoreuser[@]}"; do grep -v $i /tmp/userlist.txt > /tmp/userlist2.txt; mv /tmp/userlist2.txt /tmp/userlist.txt; done

# Modify emails for Copy-Paste (read the userinfo, filter for email, remove the description, add a semicolon for use in outlook and remove users who have no email)
for i in `cat /tmp/userlist.txt`; do sudo -u www-data /usr/bin/php /var/www/nextcloud/occ user:info $i | grep "email" | sed 's/  - email: //g' | sed 's/$/\;/' | sed '/^\;$/d'; done

# Remove temporary file
rm /tmp/userlist.txt
