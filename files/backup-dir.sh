#!/bin/bash

# Backup directory to Amazon S3
# Requires awscli to be setup @see http://docs.aws.amazon.com/cli/latest/reference/index.html#cli-aws
# Tested on Ubuntu 14.04
# @author Justas Azna <ja@fadeit.dk>
# @date October, 2015
#
# Example usage: ./backup-dir.sh --bucket="s3://my-bucket" --dir="/var/log" --identifier="log"

BUCKET=""
TARGET_DIR=""
IDENTIFIER=""
WORK_DIR=/tmp/s3_backup
HOME=/root

for i in "$@"
do
case $i in
    -b=*|--bucket=*)
    BUCKET="${i#*=}"
    shift
    ;;
    -d=*|--dir=*)
    TARGET_DIR="${i#*=}"
    shift
    ;;
    -i=*|--identifier=*)
    IDENTIFIER="${i#*=}"
    shift
    ;;
    *)
            # unknown option
    ;;
esac
done

# Check requirements
MISSING=false
if [[ $BUCKET == "" ]]; then
    echo "missing argument -b, --bucket"
    MISSING=true
fi

if [[ $TARGET_DIR == "" ]]; then
    echo "missing argument -d, --dir"
    MISSING=true
fi

if [[ $IDENTIFIER == "" ]]; then
    echo "missing argument -k, --key"
    MISSING=true
fi

if [[ $MISSING == true ]]; then
    exit 1
fi

if [[ $(whoami) != root ]]; then
    echo "should execute as root"
    exit 1
fi

# Generate ID
ID=$IDENTIFIER-$(date +%Y-%m-%d_%H_%M)

echo "Bucket: $BUCKET"
echo "Target directory: $TARGET_DIR"
echo "Identifier: $IDENTIFIER"
echo "Id: $ID"

# Ensure that working directory exists
mkdir -p $WORK_DIR

# Copy and compress
cd $WORK_DIR || exit 1; cp "$TARGET_DIR" -r "$ID"
tar -cvJf "$ID.tar.xz" "$ID"

# Upload to AWS
/usr/local/bin/aws s3 cp "$ID.tar.xz" "$BUCKET"

# Clean up
rm -rf "$ID"
rm "$ID.tar.xz"
