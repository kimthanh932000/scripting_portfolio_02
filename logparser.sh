#!/bin/bash

# Student Name: Kim Tran
# Student ID: 10657323

# 1. Input original.csv and processed.csv from terminal
# 2. Validate the inputs
# 3. Remove the headers from original.csv
# 4. Format "Time" column into "Date" only
# 5. Extract "URL" column
# 6. Separate 3 fields "Method", "URL" and "Protocol" from original "URL" column

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

# 1st line: Remove the header line from the original file
# 2nd line: Replace the datetime format with date only and ouput to "temp.csv"    
sed -e '1d'\
    -e 's/\[\(.*\/.*\/.*\):[0-9]\{2\}:[0-9]\{2\}:[0-9]\{2\}/\1/g' $original_file > temp.csv  