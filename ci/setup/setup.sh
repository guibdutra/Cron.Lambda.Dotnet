#!/bin/bash

URL=http://localhost:4566
PROFILE=default
REGION=sa-east-1

ROLE_NAME=role-cron-lambda-dotnet
FUNCTION_NAME=function-cron-lambda-dotnet
EVENTS_RULE=events-rule-cron-lambda-dotnet

cd function/

aws iam create-role \
	--role-name $ROLE_NAME \
	--assume-role-policy-document "{\n    \"Version\": \"2012-10-17\",\n    \"Statement\": [\n        {\n            \"Effect\": \"Allow\",\n            \"Principal\": {\n                \"Service\": \"lambda.amazonaws.com\"\n            },\n            \"Action\": \"lambda:AssumeRole\"\n        }\n    ]\n}" \
	--endpoint-url $URL

aws lambda create-function \
	--function-name $FUNCTION_NAME \
	--runtime dotnet6 \
	--handler Cron.Lambda.Dotnet::Cron.Lambda.Dotnet.Function::FunctionHandler \
	--description "sample cron lambda dotnet" \
	--zip-file fileb://function.zip \
	--role arn:aws:iam:$REGION:000000000000:role/$ROLE_NAME \
	--endpoint-url $URL \

aws events put-rule \
	--name $EVENTS_RULE \
	--schedule-expression "cron(*/2 * * * *)" \
	--state "ENABLED" \
	--endpoint-url $URL

aws lambda add-permission \
    --function-name $FUNCTION_NAME \
    --statement-id 'cron-lambda-dotnet' \
    --action 'lambda:InvokeFunction' \
    --principal events.amazonaws.com \
    --source-arn arn:aws:events:$REGION:000000000000:rule/$EVENTS_RULE \
	--endpoint-url $URL

aws events put-targets \
	--rule $EVENTS_RULE \
	--targets '{"Id":"id-cron-lambda-dotnet","Arn":"arn:aws:lambda:$REGION:000000000000:function:$FUNCTION_NAME"}' \
	--endpoint-url $URL