
RELEASE_TAG=$1
TAGS_LENGTH=$(git tag | sort -V | tail -2 | wc -l | awk '{ print $1 }')
PREVIOUS_TAG=$(git tag | sort -V | tail -$TAGS_LENGTH | head -1)
RANGE=$RELEASE_TAG

if [ $PREVIOUS_TAG != $RELEASE_TAG ]; then
RANGE=$PREVIOUS_TAG..$RELEASE_TAG
fi

COMMITS=$(git log $RANGE --pretty=format:"%H %cN %s" | awk '{ print $0 }')
echo $COMMITS
