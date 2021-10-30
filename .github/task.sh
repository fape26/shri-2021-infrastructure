#!/usr/bin/env

current_tag=$(git tag | tail -1 | head -n1)
previous_tag=$(git tag | tail -2 | head -n1)

echo
echo "previous_tag:"
echo $previous_tag
echo
echo "current_tag:"
echo $current_tag

curl https://api.tracker.yandex.net/v2/myself -H "Authorization: OAuth ${OAuth}" -H "X-Org-Id: ${OrganizationId}"
