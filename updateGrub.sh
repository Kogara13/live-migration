#!/usr/bin/bash

# Define the search string
search_string="GRUB_CMDLINE_LINUX_DEFAULT"

# Define the string to append
append_string="console=ttyS0"

# Find the line that starts with the search string
line=$(grep "^$search_string" /etc/default/grub)

# Check if the line was found
if [[ -n "$line" ]]; then
  # Append the string to the line
  new_line=${line::-1}" $append_string\""
  # Replace the line in the file
  sed -i "s/^$search_string.*/$new_line/" /etc/default/grub
fi
