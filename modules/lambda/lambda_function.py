import os
import json
import psycopg2


def lambda_handler(event, context):

    connection = psycopg2.connect(
        host=os.environ["DB_HOST"],
        database=os.environ["DB_NAME"],
        user=os.environ["DB_USER"],
        password=os.environ["DB_PASSWORD"],
        port=5432
    )

    cursor = connection.cursor()

    cursor.execute(
        "SELECT id, name, email FROM application.users;"
    )

    rows = cursor.fetchall()

    cursor.close()
    connection.close()

    return {
        "statusCode": 200,
        "body": json.dumps(rows)
    }