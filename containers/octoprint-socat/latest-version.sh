#!/usr/bin/env bash

# Get the version using jq from the json response.
version=$(curl -sX GET https://api.github.com/repos/octoprint/octoprint/releases/latest | jq --raw-output '.name')
# Strip the v from the beginning of version if it exists.
version="${version#*v}"

# Print the verion without a new line (\n) character.
printf "%s" "${version}"
