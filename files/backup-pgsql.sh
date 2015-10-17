#!/bin/bash

# Backup pgsql database to Amazon S3
# Requires awscli to be setup @see http://docs.aws.amazon.com/cli/latest/reference/index.html#cli-aws
# Tested on Ubuntu 14.04
# @author Justas Azna <ja@fadeit.dk>
# @date October, 2015
#
# Example usage: ./backup-pgsql.sh --bucket="s3://my-bucket" --database="mydb"

BUCKET=""
DATABASE=""
WORK_DIR=/tmp/backup/pgsql

# Parse arguments
for i in "$@"
do
case $i in
    -b=*|--bucket=*)
    BUCKET="${i#*=}"
    shift # past argument=value
    ;;
    -d=*|--database=*)
    DATABASE="${i#*=}"
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

if [[ $DATABASE == "" ]]; then
    echo "missing argument -d, --database"
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
ID=pgsql-$DATABASE-$(date +%Y-%m-%d_%H_%M)

echo "Bucket: $BUCKET"
echo "Database: $DATABASE"
echo "Id: $ID"


# Ensure that working directory exists and can be accessed by postgres user
mkdir -p $WORK_DIR
chown -R postgres $WORK_DIR

# Dump and compress
sudo -H -u postgres bash -c "pg_dump $DATABASE > $WORK_DIR/$ID.psql"
cd $WORK_DIR || exit 1; tar -cvJf "$ID.psql.tar.xz" "$ID.psql"

# Upload to AWS
aws s3 cp "$ID.psql.tar.xz" "$BUCKET"

# Clean up
rm "$ID.psql.tar.xz"
rm "$ID.psql"
exit 0
