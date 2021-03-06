#!/bin/bash

TOKEN="токен чат бота в телеграмі"
ID="айді кориспувача в телеграмі"
WALLET="нікнейм вебвалета duco"
URL="https://api.telegram.org/bot$TOKEN/sendMessage"
MSG="ᕲ DuinoCoin"

JSON=$(curl -s -X GET https://server.duinocoin.com/users/$WALLET -H "Accept: application/json" | jq .)
BALANCE=$(echo $JSON | jq '.result.balance.balance')
WORKERS=$(echo $JSON | jq '.result.miners' | jq '.[].identifier')
NUMBER_WORKERS=$(echo $JSON | jq -r '.result.miners' | jq -r '.[].identifier' | wc -l)
FORMAT1=$(echo "scale=2; $BALANCE/1" | bc -l)

if [ $? -ne 0 ]
then
        exit 0
else
        /usr/bin/curl -s -X POST $URL \
                -d chat_id=$ID \
                -d parse_mode=HTML \
                -d text="$(printf "$MSG\n\t\t- \U1FA99 Balance: <code>$FORMAT1 ᕲ</code>\n\t\t- \U26CF Nº Workers $NUMBER_WORKERS:\n<code>$WORKERS</code>")" \
                > /dev/null 2>&1
        exit 0
fi
