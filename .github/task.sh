#!/usr/bin/env

current_tag=$(git tag | tail -1 | head -n1)
previous_tag=$(git tag | tail -2 | head -n1)
author=$(git show ${current_tag} | grep Author: | head -1)
date=$(git show ${current_tag} | grep Date: | head -1)

summary="Created release task by lex8329 $current_tag"
uniqueTag="lex8329/$current_tag"
changeLog=$(git log "$previous_tag".. --pretty=format:"%h - %s (%an, %ar)\n" | tr -s "\n" " ")

postTaskUrl="https://api.tracker.yandex.net/v2/issues/"

headerAuth="Authorization: OAuth ${OAuth}"
headerOrgID="X-Org-Id: ${OrganizationId}"
contentType="Content-Type: application/json"

responseStatus=$(curl --write-out '%{http_code}' --silent --output /dev/null --location --request POST ${postTaskUrl} \
--header "$headerAuth" \
--header "$headerOrgID" \
--header "$contentType" \
--data-raw '{
    "queue": "TREK",
    "summary": "'"${summary}"'",
    "type": "task",
    "description": "$changeLog}",
    "unique": "$uniqueTag"
}')

echo "previous_tag:"
echo $previous_tag

echo "current_tag:"
echo $current_tag
