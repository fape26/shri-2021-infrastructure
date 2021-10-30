#!/usr/bin/env

CURRENT_TAG_NAME=$(git tag | tail -1 | head -n1)

echo CURRENT_TAG_NAME

curl https://api.tracker.yandex.net/v2/myself -H "Authorization: OAuth ${OAuth}" -H "X-Org-Id: ${OrganizationId}"

echo "CURRENT_TAG_NAME"
