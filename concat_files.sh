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
            o) 
                # Validate the output file using regex
                if [[ "$OPTARG" =~ ^[a-zA-Z0-9_\-]+\.(txt)$ ]]; then
                    output_file="$OPTARG"
                else
                    echo "Error: Invalid output file format. Must end with .txt"
                    exit 1
                fi
                ;;
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
    # Check if the file exists and has a .txt extension
    if [[ -f "$file" && "$file" =~ \.txt$ ]]; then
        valid_input_files+=("$file")
    else
        echo "Warning: File $file does not exist or is not a .txt file. Skipping."
    fi
done

# If no valid input files were provided, check the default files
if [ ${#valid_input_files[@]} -eq 0 ]; then
    valid_input_files=("${default_files[@]}")
    echo "Using default files: ${valid_input_files[@]}"
fi

# Validate default input files
for file in "${valid_input_files[@]}"; do
    if [[ ! -f "$file" || ! "$file" =~ \.txt$ ]]; then
        echo "Warning: File $file does not exist or is not a .txt file. Skipping."
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
