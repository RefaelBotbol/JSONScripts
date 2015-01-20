#!/bin/bash
export BZA=https://a.blazemeter.com:443
export BZA_API_KEY=789
export FILE=myscript.json

if [ "x$1" == "x" ] ; then
	echo "Usage: $0 file.json"
	echo "---"
	echo -n "No parameters given, so .. "
else
	export FILE=@$1
fi

# Create a Test
echo "Create a test"
TEST_ID=$(curl -X POST -d $FILE -v -k -H "Content-Type: application/json" -H "x-api-key: ${BZA_API_KEY}" ${BZA}/api/latest/tests/custom?custom_test_type=json2 | jq '.result.id' )
echo "test id: " $TEST_ID

##Run a Test
echo "Run a test"
SESSION_ID=$(curl --silent --insecure ${BZA}/api/latest/tests/${TEST_ID}/start?api_key=${BZA_API_KEY} | jq '.result.sessionsId[]' | tr -d \")

## Query Test Status
echo "Query test status"
TEST_RUN_STATUS=$(curl --silent --insecure ${BZA}/api/latest/sessions/${SESSION_ID}?api_key=${BZA_API_KEY} | jq '.result.status' | tr -d \" )
