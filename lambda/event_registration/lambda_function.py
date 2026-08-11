import json
import boto3
import os


s3 = boto3.client("s3")
sns = boto3.client("sns")


BUCKET_NAME = os.environ["BUCKET_NAME"]
SNS_TOPIC_ARN = os.environ["SNS_TOPIC_ARN"]

EVENTS_KEY = "events.json"


def lambda_handler(event, context):

    try:

        body = json.loads(event.get("body", "{}"))

        title = body.get("title")
        description = body.get("description")
        date = body.get("date")
        location = body.get("location")

        if not title or not date:

            return {
                "statusCode": 400,
                "headers": {
                    "Content-Type": "application/json"
                },
                "body": json.dumps({
                    "message": "Title and date are required"
                })
            }

        response = s3.get_object(
            Bucket=BUCKET_NAME,
            Key=EVENTS_KEY
        )

        events_data = json.loads(
            response["Body"].read().decode("utf-8")
        )

        new_event = {
            "title": title,
            "description": description,
            "date": date,
            "location": location
        }

        events_data["events"].append(new_event)

        s3.put_object(
            Bucket=BUCKET_NAME,
            Key=EVENTS_KEY,
            Body=json.dumps(events_data),
            ContentType="application/json"
        )

        sns.publish(
            TopicArn=SNS_TOPIC_ARN,
            Subject=f"New Event: {title}",
            Message=json.dumps(new_event, indent=2)
        )

        return {
            "statusCode": 201,
            "headers": {
                "Content-Type": "application/json"
            },
            "body": json.dumps({
                "message": "Event created successfully",
                "event": new_event
            })
        }

    except Exception as error:

        print(f"Error: {error}")

        return {
            "statusCode": 500,
            "headers": {
                "Content-Type": "application/json"
            },
            "body": json.dumps({
                "message": "Internal server error"
            })
        }