#!/usr/bin/env

current_tag=$(git tag | tail -1 | head -n1)
previous_tag=$(git tag | tail -2 | head -n1)
author=$(git show ${current_tag} | grep Author: | head -1)
date=$(git show ${current_tag} | grep Date: | head -1)
changeLog=$(git log ${previous_tag}..${current_tag} --pretty=format:"%h - %s (%an, %ar)\n")
descr="${author}\n${date}\n${changeLog}"

summary="Created release task by lex8329 $current_tag"
uniqueTag="lex8329/$current_tag"

postTaskUrl="https://api.tracker.yandex.net/v2/issues/"
findExistingTask="https://api.tracker.yandex.net/v2/issues/_search"

headerAuth="Authorization: OAuth ${OAuth}"
headerOrgID="X-Org-Id: ${OrganizationId}"
contentType="Content-Type: application/json"

echo "create Task"
echo $previous_tag

createTaskRequest=$(curl --write-out '%{http_code}' --silent --output /dev/null --location --request POST ${postTaskUrl} \
    --header "${headerAuth}" \
    --header "${headerOrgID}" \
    --header "${contentType}" \
    --data-raw '{
        "queue": "TMP",
        "summary": "'"${summary}"'",
        "type": "task",
        "description": "'"${descr}"'",
        "unique": "'"${uniqueTag}"'"
    }')

echo $createTaskRequest

if [ "$createTaskRequest" = 201 ]; 
    then
      echo "Ticket was successfully created"
      exit 0
elif ["$createTaskRequest" -eq 409]
    then
        echo "Error, can't create new ticket with the same release version"
        
        findTask=$(curl --write-out '%{http_code}' --silent --output /dev/null --location --request POST ${findExistingTask} \
        --header "${headerAuth}" \
        --header "${headerOrgID}" \
        --header "${contentType}" \
        --data-raw '{
            "filter": {
                "unique": "'"${uniqueTag}"'"
              }
              }' | jq -r '.[0].key')
         echo "$findTask"
