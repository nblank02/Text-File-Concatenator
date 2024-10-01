# Text-File-Concatenator

## Overview

`concat_files.sh` is a simple Bash script designed to concatenate multiple text files into a single output file. It is useful when you have many text files and want to merge their contents into one file without having to manually copy and paste the data.

## Features

- Takes in multiple text file inputs.
- Outputs the concatenated content to a single file.
- Provides a `-h` option to display help information.
- Ensures that only `.txt` files are processed using a regular expression.
- Handles invalid arguments and file errors gracefully.

## Usage

```bash
./concat_files.sh [options] file1.txt file2.txt ... fileN.txt
