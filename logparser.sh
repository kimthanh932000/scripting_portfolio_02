#!/bin/bash

# Student Name: Kim Tran
# Student ID: 10657323

# Assign arguments passed from the terminal to variables
original_file=$1
processed_file=$2

if [[ -z $original_file ]] || [[ ! $original_file =~ ^[A-Za-z]+\.csv$ ]] || [[ ! -f $original_file ]]; then  # Check if original file is empty or is not a .csv file or not existed
    echo "Please input a valid original file"  # Print invalid message
    exit 1      # Exit program with status code 1 on failed validation
fi

if [[ -z $processed_file ]] || [[ ! $original_file =~ ^[A-Za-z]+\.csv$ ]]; then  # Check if original file is empty or is not a .csv file
    echo "Please input a valid processed file"  # Print invalid message
    exit 1      # Exit program with status code 1 on failed validation
fi

echo "Processing..."
count=0

# 1st line: Remove the header line
# 2nd line: Replace the datetime format with date only   
sed -e '1d'\
    -e 's/\[\(.*\/.*\/.*\):[0-9]\{2\}:[0-9]\{2\}:[0-9]\{2\}/\1/g'\
    "$original_file" > temp.csv     # Read from the original file and output formatted content to "temp.csv"

echo "" >> temp.csv     # Add new line at the end of "temp.csv" for while loop to not skip the last line

# Add header line to the output file
echo "IP,Date,Method,URL,Protocol,Status" > $processed_file

# IFS value set to comma to match the source file format
while IFS=',' read -r ip date full_url status || [ -n "$line" ]; do  # Read line by line
    method=$(echo "$full_url" | cut -d' ' -f1)  # Extract the 1st part as method
    url=$(echo "$full_url" | cut -d' ' -f2 | sed 's/^\///') # Extract the 2nd part as url and remove the first slash (/)
    protocol=$(echo "$full_url" | cut -d' ' -f3)    # Extract the 3rd part as protocol
    count=$((count + 1))    # Increment the counter by 1
    echo "$ip,$date,$method,$url,$protocol,$status" >> $processed_file
done < temp.csv

echo "$count records processed..."
rm temp.csv     # Remove temp.csv before exiting program
exit 0