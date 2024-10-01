#!/bin/bash

# Display help/usage information
function display_help() {
    echo "Usage: $0 [options] file1 file2 ... fileN"
    echo
    echo "Options:"
    echo "  -o <output_file>  Specify the output file name (required)"
    echo "  -h                Display this help message"
    echo
    echo "Example:"
    echo "  $0 -o result.txt file1.txt file2.txt"
}

# Check for valid .txt files using a regular expression
function is_valid_file() {
    local file=$1
    if [[ $file =~ ^.*\.txt$ ]]; then
        return 0
    else
        return 1
    fi
}

# Handle invalid arguments or no arguments
if [[ $# -eq 0 ]]; then
    echo "Error: No arguments provided."
    display_help
    exit 1
fi

# Initialize variables
output_file=""
input_files=()

# Parse options and arguments
while getopts ":o:h" option; do
    case $option in
        o)
            output_file=$OPTARG
            ;;
        h)
            display_help
            exit 0
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            display_help
            exit 1
            ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            display_help
            exit 1
            ;;
    esac
done

shift $((OPTIND - 1))

# Ensure output file is specified
if [[ -z $output_file ]]; then
    echo "Error: Output file is required."
    display_help
    exit 1
fi

# Collect input files
for file in "$@"; do
    if is_valid_file "$file"; then
        if [[ -f $file ]]; then
            input_files+=("$file")
        else
            echo "Warning: File $file does not exist. Skipping."
        fi
    else
        echo "Warning: File $file is not a valid text file. Skipping."
    fi
done

# Check if there are any valid input files
if [[ ${#input_files[@]} -eq 0 ]]; then
    echo "Error: No valid text files to concatenate."
    exit 1
fi

# Concatenate the files into the output file
echo "Concatenating files..."
> "$output_file"  # Clear the output file
for file in "${input_files[@]}"; do
    cat "$file" >> "$output_file"
    echo "" >> "$output_file"  # Add a new line between files
done

echo "Files successfully concatenated into $output_file."
