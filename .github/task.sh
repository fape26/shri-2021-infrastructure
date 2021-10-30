#!/usr/bin/bash
CURRENT_TAG=$(git tag | sort -r | head -1)

echo "CURRENT_TAG:"
echo $CURRENT_TAG
