#!/usr/bin/python3.6
import urllib3
import json
import os

http = urllib3.PoolManager()

def lambda_handler(event, context):
    url = os.environ.get('HOOK_URL', None)
    msg = {
        "channel": os.environ.get('CHANNEL', None),
        "username": os.environ.get('USERNAME', "aws-sns-slack"),
        "text": event['Records'][0]['Sns']['Message'],
        "icon_emoji": os.environ.get('EMOJI', ":robot_face:"),
    }

    encoded_msg = json.dumps(msg).encode('utf-8')
    resp = http.request('POST',url, body=encoded_msg)
    print({
        "message": event['Records'][0]['Sns']['Message'],
        "status_code": resp.status,
        "response": resp.data
    })
