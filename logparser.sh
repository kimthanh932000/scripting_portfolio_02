#!/bin/bash

# Student Name: Kim Tran
# Student ID: 10657323

input_file=$1   # Assign 1st argument from terminal to variable "input_file"
output_file=$2  # Assign 2nd argument from terminal to variable "output_file"
count=0         # Set counter for the number of processed records

validate() {
    if [[ -z $1 ]]; then  # Check if file is empty
        echo "$3 file must not be empty"  # Print error message
        exit 1      # Exit program with status code 1
    fi

    if [[ ! $1 =~ ^[A-Za-z]+\.csv$ ]]; then  # Check if file not ending in .csv
        echo "$3 file must end in .csv"  # Print error message
        exit 1      # Exit program with status code 1
    fi

    if [[ $2 = true ]] && [[ ! -f $1 ]]; then  # Check if file existence validation is required and check if file does not exist
        echo "$3 file does not exist"  # Print error message
        exit 1      # Exit program with status code 1
    fi
}

validate "$input_file" true "Input"         # Invoke validate(), pass input file name, require checking file existence and specify "Input" in the error message
validate "$output_file" false "Output"      # Invoke validate(), pass output file name, ignore checking file existence and specify "Output" in the error message

# Remove output file if it exists
if [ -f "$output_file" ]; then
    rm "$output_file"
fi

echo "Processing..."

# Line 39: Remove the header line
# Line 40: Replace the datetime format with date only
sed -e '1d'\
    -e 's/\[\(.*\/.*\/.*\):[0-9]\{2\}:[0-9]\{2\}:[0-9]\{2\}/\1/g'\
    "$input_file" > temp.csv     # Read from the original file and output formatted content to "temp.csv"

echo "" >> temp.csv     # Add new line at the end of "temp.csv" for while loop to not skip the last line

# Add header line to the output file
echo "IP,Date,Method,URL,Protocol,Status" > "$output_file"

# IFS value set to comma to match the source file format
while IFS=',' read -r ip date full_url status || [ -n "$line" ]; do  # Read line by line
    # Extract the 1st part of "full_url" and assign it to variable "method"
    method=$(echo "$full_url" | cut -d' ' -f1)
    
    # Extract the 2nd part of "full_url"
        # remove the leading slash (/) and everything starting from the question mark (?) onward
        # then assign it to variable "url"
    url=$(echo "$full_url" | cut -d' ' -f2 | sed -e 's/^\///; s/\?.*//')

    # Extract the 3rd part of "full_url" and assign it to variable "protocol"
    protocol=$(echo "$full_url" | cut -d' ' -f3)

    # Increment the counter by 1
    count=$((count + 1))

    # Write the entry to the output file
    echo "$ip,$date,$method,$url,$protocol,$status" >> "$output_file"
done < temp.csv     # Read from "temp.csv"

echo "$count records processed..."  # Print the number of processed records
rm temp.csv     # Remove "temp.csv" before exiting program
exit 0      # Exit program with status code 0