#!/bin/bash

# Student Name: Kim Tran
# Student ID: 10657323

validate_input() {
    if [[ -z $1 ]] || [[ ! $1 =~ ^[A-Za-z]+\.csv$ ]] || [[ ! -f $1 ]]; then  # Check if original file is empty or is not a .csv file or not existed
        echo "Please input a valid original file"  # Print invalid message
        exit 1      # Exit program with status code 1 on failed validation
    fi

    if [[ -z $2 ]] || [[ ! $2 =~ ^[A-Za-z]+\.csv$ ]]; then  # Check if original file is empty or is not a .csv file
        echo "Please input a valid processed file"  # Print invalid message
        exit 1      # Exit program with status code 1 on failed validation
    fi
}

# Assign arguments passed from the terminal to appropriate variables
original_file=$1
processed_file=$2

validate_input "$original_file" "$processed_file"

echo "Processing..."
count=0

# Line 29: Remove the header line
# Line 30: Replace the datetime format with date only
sed -e '1d'\
    -e 's/\[\(.*\/.*\/.*\):[0-9]\{2\}:[0-9]\{2\}:[0-9]\{2\}/\1/g'\
    "$original_file" > temp.csv     # Read from the original file and output formatted content to "temp.csv"

echo "" >> temp.csv     # Add new line at the end of "temp.csv" for while loop to not skip the last line

# Add header line to the output file
echo "IP,Date,Method,URL,Protocol,Status" > $processed_file

# IFS value set to comma to match the source file format
while IFS=',' read -r ip date full_url status || [ -n "$line" ]; do  # Read line by line in the "temp.csv"
    # Extract the 1st part of "full_url" and assign it to "method"
    method=$(echo "$full_url" | cut -d' ' -f1)
    
    # Extract the 2nd part of "full_url"
        # remove the leading slash (/) and everything starting from the question mark (?) onward
        # then assign it to "url"
    url=$(echo "$full_url" | cut -d' ' -f2 | sed -e 's/^\///; s/\?.*//')

    # Extract the 3rd part of "full_url" and assign it to "protocol"
    protocol=$(echo "$full_url" | cut -d' ' -f3)

    # Increment the counter by 1
    count=$((count + 1))

    # Write the entry to the output file
    echo "$ip,$date,$method,$url,$protocol,$status" >> $processed_file
done < temp.csv

echo "$count records processed..."  # Print the number of processed records
rm temp.csv     # Remove temp.csv before exiting program
exit 0      # Exit program with status code 0