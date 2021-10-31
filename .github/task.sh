#!/usr/bin/env

current_tag=$(git tag | sort -r | head -n1)
previous_tag=$(git tag | sort -r | tail -1 | head -n1)
author=$(git show ${current_tag} | grep Author: | head -1)
date=$(git show ${current_tag} | grep Date: | head -1)
changeLog=$(git log  --pretty=format:"%h - %s (%an, %ar)\n" ${previous_tag}.${current_tag})
descr="Released by ${author}\n${date}\nChangelog:\n${changeLog}"

echo "changeLog"
echo $changeLog

summary="Created release task by lex8329 $current_tag"
updateSummary="Updated release task by lex8329 $current_tag"
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
        "queue": "TREK",
        "summary": "'"${summary}"'",
        "type": "task",
        "description": "'"${descr}"'",
        "unique": "'"${uniqueTag}"'"
    }')

echo $createTaskRequest

if [ "$createTaskRequest" -eq 201 ]; 
    then
      echo "Ticket was successfully created"
      exit 0
elif [ "$createTaskRequest" -eq 409 ]
    then
        echo "Error, can't create new ticket with the same release version"
        
        findTask=$(curl --silent --location --request POST ${findExistingTask} \
        --header "${headerAuth}" \
        --header "${headerOrgID}" \
        --header "${contentType}" \
        --data-raw '{
            "filter": {
                "unique": "'"${uniqueTag}"'"
              }
         }' | jq -r '.[0].key')
         echo $findTask
         echo "findExistingTask"
         
         updateTask=$(curl --write-out '%{http_code}' --silent --output /dev/null --location --request PATCH ${postTaskUrl}/${findTask} \
        --header "${headerAuth}" \
        --header "${headerOrgID}" \
        --header "${contentType}" \
        --data-raw '{
            "summary": "'"${updateSummary}"'",
            "description": "'"${descr}"'"
         }')
         if [ "$updateTask" -ne 200]
            then
                echo "Something went wrong: ${updateTask}"
                exit 1
         else 
            echo "Update successfull"
         fi
fi
