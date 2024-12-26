#!/bin/bash

# This script blocks or unblocks access to specific websites on Linux, 
# using the /etc/hosts file to redirect blocked domains to 127.0.0.1.
# It has been adapted to handle site lists in the format used by StevenBlack/hosts.
# Source: https://github.com/StevenBlack/hosts

# Path to the /etc/hosts file
HOSTS_FILE="/etc/hosts"
# IP to redirect to (localhost)
REDIRECT_IP="127.0.0.1"
# Base directory for site categories to be blocked
CATEGORIES_DIR="src/categories"

# Function to add sites to the /etc/hosts file
block_sites() {
    category="$1"
    category_file="$CATEGORIES_DIR/$category/list.txt"
    
    # Check if the category file exists
    if [[ -f "$category_file" ]]; then
        # Read the file line by line
        while IFS= read -r line; do
            # Ignore comment lines or blank lines
            if [[ $line == \#* ]] || [[ -z "$line" ]]; then
                continue
            fi
            
            # Extract the domain from the line that starts with "0.0.0.0"
            domain=$(echo "$line" | awk '{print $2}')
            
            # Check if the domain is already in the hosts file
            if ! grep -q "$domain" "$HOSTS_FILE"; then
                echo "Blocking $domain from category $category..."
                # Add the domain to the hosts file
                echo "$REDIRECT_IP $domain" | sudo tee -a "$HOSTS_FILE" > /dev/null
            else
                echo "$domain from category $category is already blocked."
            fi
        done < "$category_file"
    else
        echo "The category $category does not exist."
    fi
}

# Function to remove blocked sites from the /etc/hosts file
unblock_sites() {
    category="$1"
    category_file="$CATEGORIES_DIR/$category/sites_list.txt"

    # Check if the category file exists
    if [[ -f "$category_file" ]]; then
        while IFS= read -r line; do
            # Ignore comment lines or blank lines
            if [[ $line == \#* ]] || [[ -z "$line" ]]; then
                continue
            fi
            
            # Extract the domain from the line that starts with "0.0.0.0"
            domain=$(echo "$line" | awk '{print $2}')
            
            # Check if the domain is in the hosts file
            if grep -q "$domain" "$HOSTS_FILE"; then
                echo "Unblocking $domain from category $category..."
                # Remove the domain from the hosts file
                sudo sed -i".bak" "/$domain/d" "$HOSTS_FILE"
            else
                echo "$domain from category $category is not blocked."
            fi
        done < "$category_file"
    else
        echo "The category $category does not exist."
    fi
}

# Function to block or unblock all categories
process_all_categories() {
    action="$1"
    
    for category_dir in "$CATEGORIES_DIR"/*/; do
        category=$(basename "$category_dir")
        "$action"_sites "$category"
    done
}

# Options menu
case "$1" in
    block)
        if [[ -n "$2" ]]; then
            block_sites "$2"
        else
            process_all_categories "block"
        fi
        ;;
    unblock)
        if [[ -n "$2" ]]; then
            unblock_sites "$2"
        else
            process_all_categories "unblock"
        fi
        ;;
    *)
        echo "Usage: $0 {block|unblock} [category]"
        echo "Example: $0 block social"
        exit 1
        ;;
esac
