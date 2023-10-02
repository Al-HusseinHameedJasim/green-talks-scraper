#!/bin/bash

# An array of keywords to search for in the content of URLs
keywords=("carbon" "climate" "energy" "green" "kepler" "sustainability" "sustainable")

# An array of specific words/phrases that, if found, the title should be excluded in case there is only 1 matched keyword
specific_words=("blue/green" "blue-green" "blue green" "green light" "greenberg" "greendale" "greene" "greenfield" "greenlee" "greenley" "greentree" "greenwald" "greenwich" "greenwood")

# A function to check if a title contains a specific word/phrase
contains_specific_word() {
    local title="$1"

    for word in "${specific_words[@]}"; do
        if [[ "$title" == *"$word"* ]]; then
            return 0  # Match found
        fi
    done
    return 1  # No match found
}

# Read URLs from urls.txt file into an array
readarray -t URLS < urls.txt

# Loop through the array of URLs
for url in "${URLS[@]}"; do
	# Fetch the content of the URL
    content=$(curl -s "$url")

    # An associative array to store encountered titles
    declare -A encountered_titles

    # An array to store talks for the current URL
    talks=()

    # Loop through the array of keywords
    for keyword in "${keywords[@]}"; do
        matched_lines=($(echo "$content" | grep -ni "$keyword" | cut -d':' -f1))

        # Loop through the matched lines
        for line_number in "${matched_lines[@]}"; do
            title=$(echo "$content" | sed -n "${line_number}s/.*'>\(.*\)<span class=\"vs\">.*/\1/p")

            # Check if the title has at least 40 characters (to avoid having unwanted matched contents) and is not encountered before
            if [ "${#title}" -ge 40 ] && [ -z "${encountered_titles["$title"]}" ]; then
                encountered_titles["$title"]=1  # Mark the title as encountered
                talks+=("$title")  # Add title to talks array
            fi
        done
    done

    # Print the conference schedule link and "Talks:" section if talks were found
    if [ "${#talks[@]}" -gt 0 ]; then
        echo -e "\nConference schedule link: $url"
        echo -e "\nTalks:"
        for title in "${talks[@]}"; do
            title_lowercase=$(echo "$title" | tr '[:upper:]' '[:lower:]')  # Convert title to lowercase for keyword counting
            count=0
            for keyword in "${keywords[@]}"; do
                if [[ "$title_lowercase" == *"$keyword"* ]]; then
                    ((count++))
                fi
            done
            # if [ "$count" -eq 1 ] && contains_specific_word "$title"; then
	    if [ "$count" -eq 1 ] && contains_specific_word "$title_lowercase"; then
                echo "- $title (Keywords Matched: $count) (Contains Specific Word)"
            else
                echo "- $title (Keywords Matched: $count)"
            fi
        done
    fi
done
