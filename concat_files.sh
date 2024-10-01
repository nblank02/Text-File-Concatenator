#!/bin/bash

# Function to display usage
display_usage() {
    echo "Usage: ./concat_files.sh [options] file1 file2 ..."
    echo ""
    echo "Options:"
    echo "  -o <output_file>  Specify the output file name (default: output.txt)"
    echo "  -h                Display this help message"
    echo ""
    echo "Example:"
    echo "  ./concat_files.sh -o output.txt file1.txt file2.txt"
}

# Default output file
output_file="output.txt"

# Default input files
default_files=("file1.txt" "file2.txt" "file3.txt")

# Check if any arguments are provided
if [ $# -eq 0 ]; then
    echo "No arguments provided. Using default files."
    input_files=("${default_files[@]}")
else
    # Process options and arguments
    while getopts "o:h" opt; do
        case $opt in
            o) output_file="$OPTARG" ;;
            h) display_usage; exit 0 ;;
            *) echo "Invalid option: -$OPTARG" >&2; display_usage; exit 1 ;;
        esac
    done
    shift $((OPTIND - 1))

    # If input files were provided as arguments
    input_files=("$@")
fi

# Validate input files
valid_input_files=()
for file in "${input_files[@]}"; do
    if [[ -f "$file" ]]; then
        valid_input_files+=("$file")
    else
        echo "Warning: File $file does not exist. Skipping."
    fi
done

# If no valid input files were provided, check the default files
if [ ${#valid_input_files[@]} -eq 0 ]; then
    valid_input_files=("${default_files[@]}")
    echo "Using default files: ${valid_input_files[@]}"
fi

# Validate default input files
for file in "${valid_input_files[@]}"; do
    if [[ ! -f "$file" ]]; then
        echo "Warning: File $file does not exist. Skipping."
        valid_input_files=("${valid_input_files[@]/$file}")
    fi
done

# Check if there are valid input files
if [ ${#valid_input_files[@]} -eq 0 ]; then
    echo "Error: No valid text files to concatenate."
    exit 1
fi

# Concatenate files
echo "Concatenating files..."
# Debug output: list of valid input files
echo "Valid input files: ${valid_input_files[@]}"

# Clear the output file before writing
: > "$output_file"

# Loop through each valid input file and append its contents to the output file
for file in "${valid_input_files[@]}"; do
    cat "$file" >> "$output_file"
    echo "Added contents of $file to $output_file."
done

echo "Files successfully concatenated into $output_file."
