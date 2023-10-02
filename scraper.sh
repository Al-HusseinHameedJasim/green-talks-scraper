#!/bin/bash

# List of keywords to search for in the content of URLs
KEYWORDS=("carbon" "climate" "energy" "green" "kepler" "sustainability" "sustainable")

# Associative array to keep track of encountered titles
declare -A encountered_titles

# Read URLs from urls.txt file into an array
readarray -t URLS < urls.txt

# Loop through the array of URLs
for url in "${URLS[@]}"; do
    # Fetch the content of the URL
    content=$(curl -s "$url")

    # Array to store talks for this URL
    talks=()

    # Loop through the array of keywords
    for keyword in "${KEYWORDS[@]}"; do
        matched_lines=($(echo "$content" | grep -n "$keyword" | cut -d':' -f1))

        # Loop through the matched lines
        for line_number in "${matched_lines[@]}"; do

	    # Extract the title from the matched line
            title=$(echo "$content" | sed -n "${line_number}s/.*'>\(.*\)<span class=\"vs\">.*/\1/p")

            # Check if the title has at least 40 characters and is not encountered before
            if [ "${#title}" -ge 40 ] && [ -z "${encountered_titles["$title"]}" ]; then
                encountered_titles["$title"]=1  # Mark the title as encountered
                talks+=("- $title")  # Add title to talks array
            fi
        done
    done

    # Print the conference schedule link and "Talks:" section if talks were found
    if [ "${#talks[@]}" -gt 0 ]; then
        echo -e "\nConference schedule link: $url"
        echo -e "\nTalks:"
        printf "%s\n" "${talks[@]}"
    fi
done
