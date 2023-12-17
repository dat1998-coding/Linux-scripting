#!/bin/bash

# Create a directory for the original .tar.gz files
mkdir -p initial_files

# Function to extract tar.gz files in a directory
extract() {
    local dir="$1"

    # Find all .tar.gz files in the directory
    local files=$(find "$dir" -name "*.tar.gz")

    # If no .tar.gz files were found, return
    if [ -z "$files" ]; then
        return
    fi

    # Extract each .tar.gz file
    for file in $files; do
        echo "Extracting $file"
        tar xzvf "$file" -C "$dir"
        
        # If the file is in the current directory (i.e., it's an outermost file),
        # move it to the initial_files directory
        if [ "$(dirname "$file")" = "$dir" ]; then
            mv "$file" initial_files/
        else
            rm "$file"
        fi
    done

    # Call extract() on each subdirectory
    for subdir in $(find "$dir" -type d); do
        extract "$subdir"
    done
}

# Call extract() on the current directory
extract .
