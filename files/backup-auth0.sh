#!/bin/bash

# Backup auth0 user metadata to Amazon S3
# Requires awscli to be setup @see http://docs.aws.amazon.com/cli/latest/reference/index.html#cli-aws
# Tested on Ubuntu 14.04
# @author Sander Sink <ss@fadeit.dk>
# @date November, 2015
#
# Example usage: ./backup-auth0.sh --bucket="s3://my-bucket" --token="ey..."

BUCKET=""
DATABASE=""
WORK_DIR=/tmp/s3_backup/auth0
HOME=/root

# Parse arguments
for i in "$@"
do
case $i in
    -b=*|--bucket=*)
    BUCKET="${i#*=}"
    shift # past argument=value
    ;;
    -t=*|--token=*)
    TOKEN="${i#*=}"
    shift # past argument=value
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

if [[ $TOKEN == "" ]]; then
    echo "missing argument -t, --token"
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
ID="Auth0-users $(date +%Y-%m-%d_%H_%M)"

echo "Bucket: $BUCKET"
echo "Token: $TOKEN"
echo "File: $ID"

mkdir -p $WORK_DIR
chown -R postgres $WORK_DIR


response=$(curl --silent --write-out "\n%{http_code}\n" https://fadeit.eu.auth0.com/api/v2/users -H "Authorization: Bearer $TOKEN")
#Parse status code and response body into variables
status_code=$(echo "$response" | sed -n '$p')
json=$(echo "$response" | sed '$d')

if [[ $status_code != 200 ]]; then
    echo "CURL returned HTTP status code $status_code"
    exit 1
fi

echo "$json" > "$WORK_DIR/$ID.json"
cd $WORK_DIR || exit 1; tar -cvJf "$ID.json.tar.xz" "$ID.json"

#TODO!
# Upload to AWS
#/usr/local/bin/aws s3 cp "$ID.json.tar.xz" "$BUCKET"

# Clean up
#rm "$ID.json.tar.xz"
#rm "$ID.json"
exit 0
