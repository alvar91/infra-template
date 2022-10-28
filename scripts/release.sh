#!/usr/bin/env bash
echo "Запуск процесса обновления задачи"

AUTH_TOKEN=$1
ORGANIZATION_ID=$2
TICKET_KEY=$3
RELEASE_TAG=$4
COMMITTER_NAME=$5
TAGS_LENGTH=$(git tag | sort -V | tail -2 | wc -l | awk '{ print $1 }')
PREVIOUS_TAG=$(git tag | sort -V | tail -$TAGS_LENGTH | head -1)
RANGE=$RELEASE_TAG

if [ $PREVIOUS_TAG != $RELEASE_TAG ]; then
RANGE=$PREVIOUS_TAG..$RELEASE_TAG
fi

echo "Сбор коммитов..."

COMMITS=$(git log $RANGE --pretty=format:"%H %cN %s" | awk '{ print $0 }')

echo "Выполняется запрос на обновление задачи..."
node ./scripts/update-ticket.js $AUTH_TOKEN $ORGANIZATION_ID $TICKET_KEY $RELEASE_TAG "'$COMMITTER_NAME'" "'$COMMITS'"

if [ "$?" != 0 ]; then
    echo "Произошла ошибка. Запрос не выполнен"
    exit 0
fi

echo $COMMITS