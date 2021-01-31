#!/bin/bash

# Backup auth0 user metadata to Amazon S3
# Requires awscli to be setup @see http://docs.aws.amazon.com/cli/latest/reference/index.html#cli-aws
# Tested on Ubuntu 14.04
# @author Sander Sink <ss@fadeit.dk>
# @date November, 2015
#
# Example usage: ./backup-auth0.sh --bucket="s3://my-bucket" --domain="https://fadeit.auth0.com" --token="ey..."

BUCKET=""
DOMAIN=""
WORK_DIR_NAME=auth0
WORK_DIR=<%= @workdir_base %>/s3_backup/$WORK_DIR_NAME
HOME=/root

# Parse arguments
for i in "$@"
do
case $i in
    -b=*|--bucket=*)
    BUCKET="${i#*=}"
    shift # past argument=value
    ;;
    -d=*|--domain=*)
    DOMAIN="${i#*=}"
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

if [[ $DOMAIN == "" ]]; then
    echo "missing argument -d, --domain"
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
echo "Domain: $DOMAIN"
echo "File: $ID"

mkdir -p $WORK_DIR

PAGE=0

#Loop pages until we get empty response
while true; do
    echo "Fetching page $PAGE"
    response=$(curl --silent --write-out "\n%{http_code}\n" "$DOMAIN/api/v2/users?page=$PAGE&per_page=100" -H "Authorization: Bearer $TOKEN")
    #Parse status code and response body into variables
    status_code=$(echo "$response" | sed -n '$p')
    json=$(echo "$response" | sed '$d')

    if [[ $status_code != 200 ]]; then
        echo "CURL returned HTTP status code $status_code:"
        echo "$response"
        exit 1
    fi

    size=${#response} 
    if [ $size -le 10 ]; then
        #If size is less than 10, then response is empty
        break
    fi
    
    echo "$json" > "$WORK_DIR/$ID-page-$PAGE.json"
    PAGE=$((PAGE + 1))
    if [ $PAGE -ge 50 ]; then
        #In case auth0 changes empty response length, we limit to 50 pages
        echo "Reached limit of 50 pages"
        break
    fi

done

cd $WORK_DIR/.. || exit 1
tar -cvJf "$ID.tar.xz" "$WORK_DIR_NAME"

# Upload to AWS
/usr/local/bin/aws s3 cp "$ID.tar.xz" "$BUCKET"

# Clean up
rm -rf "$WORK_DIR_NAME"
rm "$ID.tar.xz"
exit 0
