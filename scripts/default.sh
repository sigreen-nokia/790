#!/bin/bash
#this is the script that will be hit for defender events
#######################################################
#change these two to point to your line account channel
#######################################################
export WHATSAPP_PHONE_NUMBER_ID="642398275615559"
export META_PERMANENT_ACCESS_TOKEN="EAARZCIZBewkk8BO7iPSXXkfAbiNY90NoyrnQNLMYGxLHc2mRBnhNHZAHTKpSoxyKZCvFf7dgj4bSTF1mFCqzFAAf3GnZCO7pEdXuZBtW72x1fIY6Y2tnuEb5Gh5AZARr7wK7yICblIN740az34QIFpU8YZCDSGBLWlaStgEXEQZCkwfUiRtPS5aG6y6dXe47qcll7rwZDZD"
export WHATSAPP_PHONE_NUMBER_TO_CALL="447801878914"
#######################################################


#function that send the line app text messages
line_message () {
   #echo "DEBUG: MESSAGE is: $MESSAGE" >> /tmp/gazoo-commands/message-decode
   curl -v -i POST https://graph.facebook.com/v22.0/$WHATSAPP_PHONE_NUMBER_ID/messages -H "Authorization: Bearer $META_PERMANENT_ACCESS_TOKEN" -H 'Content-Type: application/json' -d '{ "messaging_product": "whatsapp", "recipient_type": "individual", "to": "'"$WHATSAPP_PHONE_NUMBER_TO_CALL"'", "type": "text", "text": { "body": "'"$MESSAGE"'" } }'
}

#extract the event and the event id from the JSON data block
#note we are dealing with a bug here, for the test message we see .status for everything else .Status
#We are also dealing with a change from .Status to ."Event Status" in 23.11
STATUS=`sed -e 's/^"//' -e 's/"$//' <<< $(jq '.Status, .status, ."Event Status"' <<< "$1") | grep -v null` 
EVENTID=`sed -e 's/^"//' -e 's/"$//' <<< $(jq '."Event ID"' <<< "$1")` 
MESSAGETYPE=`sed -e 's/^"//' -e 's/"$//' <<< $(jq '."Message type"' <<< "$1")`
#remove the hash on these lines to get additional debug
#echo "DEBUG: STATUS is: $STATUS" >> /tmp/gazoo-commands/message-decode
#echo "DEBUG: EVENTID is: $EVENTID" >> /tmp/gazoo-commands/message-decode
#echo "DEBUG: MESSAGETYPE is: $MESSAGETYPE" >> /tmp/gazoo-commands/message-decode


#this block handles the event to line message api 
#We are dealing with pre 23.11 and post 23.11 API formats in here.
case "$STATUS" in
  "ACTIVE")
    if [ "$MESSAGETYPE" = "Event started" ] || [ "$MESSAGETYPE" = "null" ]; then
        MESSAGE="Defender Start event $EVENTID"
        line_message 
    fi
    ;;

  "FINISHED")
    if [ "$MESSAGETYPE" = "Event finished" ] || [ "$MESSAGETYPE" = "null" ]; then
        MESSAGE="Defender Stop event $EVENTID"
        line_message 
    fi
    ;;

  "TEST")
    MESSAGE="Defender Test event"
    line_message 
    ;;
  *)
    if [ "$MESSAGETYPE" = "Test" ]; then
        MESSAGE="Defender Test event $EVENTID"
        line_message 
    else 
        echo "Defender unrecognised event" >> /tmp/gazoo-commands/message-decode
        echo "DEBUG: STATUS is: $STATUS" >> /tmp/gazoo-commands/message-decode
        echo "DEBUG: EVENTID is: $EVENTID" >> /tmp/gazoo-commands/message-decode
        echo "DEBUG: MESSAGETYPE is: $MESSAGETYPE" >> /tmp/gazoo-commands/message-decode
    fi
    ;;
esac


