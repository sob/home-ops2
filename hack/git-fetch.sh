#!/usr/bin/env bash

REPO="https://github.com/sob/hass-config.git"
DEST="/home/sob/work/hass-config"
BRANCH="main"

mkdir -p "${DEST}"

if [ -d "${DEST}/.git" ]; then
  echo "git repository exists"
else
  echo "git repository doesnt exist"
  rm -rf '${DEST}/* ${DEST}/.*' 2> /dev/null
  cd "${DEST}"

  git init . --initial-branch="${BRANCH}"
  git remote add -t \\\* -f origin "${REPO}"
  git checkout "${BRANCH}"
fi
