#!/usr/bin/env

current_tag=$(git tag | sort -r | head -n1)
uniqueTag="lex8329/$current_tag"

findExistingTask="https://api.tracker.yandex.net/v2/issues/_search"


headerAuth="Authorization: OAuth ${OAuth}"
headerOrgID="X-Org-Id: ${OrganizationId}"
contentType="Content-Type: application/json"

testRes=$(npm run test 2>&1)

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
         
createCommentURL="https://api.tracker.yandex.net/v2/issues/${findTask}/comments"
com1=$testRes process.json | tr { '\n' | tr , '\n' | tr } '\n' | grep "uri" | awk  -F'"' '{print $4}';
echo $com1

comment="Tests:\n${testRes}"

createComment=$(curl --write-out '%{http_code}' --silent --output /dev/null --location --request POST ${createCommentURL} \
        --header "${headerAuth}" \
        --header "${headerOrgID}" \
        --header "${contentType}" \
        --data-raw '{
            "text": "'"${comment}"'"
         }')
echo $createComment

if [ "$createComment" -ne 200 ];
then
  echo "Error occurred in attempt to create comment"
  exit 1
else
  echo "Created comment with the result of test run"
fi
