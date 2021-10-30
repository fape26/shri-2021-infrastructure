#!/usr/bin/env

CURRENT_TAG_NAME=$(git tag | tail -1 | head -n1)

echo "CURRENT_TAG_NAME:"
echo $CURRENT_TAG_NAME
