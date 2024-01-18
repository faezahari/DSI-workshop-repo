#!/bin/bash

# Assignment 1: Unix and Data Processing Script

# Check if a file was provided as an argument
if [ $# -eq 0 ]; then
    echo "No arguments provided. Please provide the path to the parking_data.csv file."
    exit 1
fi

# Assign the first argument as the file path variable
FILE_PATH=$1

# Function to print all unique types of parking infractions
print_infractions() {
    echo -e ds"List of Parking Infractions with count:\n"
    # Skip the header, extract the infraction descriptions, sort them, 
    # count unique occurrences, and then sort numerically by the count
    cut -d, -f4  "$FILE_PATH" | sort | uniq -c | sort -nr
}

# Function to calculate and print the mean, min, and max set fine amount
calculate_fine_statistics() {
    # Use awk to process the file and calculate statistics
    awk -F',' '
    NR > 1 { sum+=$5; if(min==""){min=max=$5} if($5<min){min=$5} if($5>max){max=$5} } 
    END { 
        if(NR>1) {
            printf "Mean Fine Amount: %.2f\n", sum/(NR-1); 
            printf "Min Fine Amount: %d\n", min; 
            printf "Max Fine Amount: %d\n", max;
        } else {
            print "No data to process.";
        }
    }' "$FILE_PATH"
}

# Function to save one type of parking infraction to a separate csv file
save_onetypeofparkinginfraction() {
    local infraction="PARK ON PRIVATE PROPERTY" # choose the infraction type
    local outfile="parkonprivateproperty.csv"

    # Get the header for the specific columns and store it in the outfile
    head -n 1 "$FILE_PATH" | cut -d',' -f2,3,4,5,8 > "$outfile"

    # Append the matching infraction lines with specific columns to the outfile
    grep -i "$infraction" "$FILE_PATH" | cut -d',' -f2,3,4,5,8 >> "$outfile"
}


# Main script execution
echo "Running parking data analysis script..."

# Navigate to the directory housing the csv file
cd "$(dirname "$FILE_PATH")"

# Call the functions
print_infractions
calculate_fine_statistics
save_onetypeofparkinginfraction

echo "Script execution completed."
