#!/usr/bin/env

CURRENT_TAG=$(git tag | tail -1 | head -n1)

echo "CURRENT_TAG:"
echo $CURRENT_TAG
