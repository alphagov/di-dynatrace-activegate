#!/bin/bash

# Services not queried due to denial by permission boundaries so check manually
# Amazon AppStream
# Amazon SageMaker Batch Transform Jobs	
# Amazon SageMaker Endpoint Instances
# Amazon SageMaker Endpoints
# Amazon SageMaker Ground Truth	
# Amazon SageMaker Processing Jobs	
# Amazon SageMaker Training Jobs
# Amazon WorkSpaces

# You will need to check manually
# AWS Billing
# AWS Chatbot
# Amazon Textract
# AWS IoT Things Graph
# AWS Trusted Advisor

# Deprected so ignored
# elastic-inference

# Not available in London region so ignored, manually confirm
# AWS App Runner
# Amazon CloudSearch
# Amazon Elastic Transcoder
# Amazon MediaTailor
# AWS IoT Analytics
# AWS RoboMaker
# Amazon WorkMail


managed_services=""

services=(
   "acm list-certificates|AWS Certificate Manager Private Certificate Authority"
   "mq list-brokers|Amazon MQ"
   "apigatewayv2 get-apis|Amazon API Gateway"
   "appsync list-graphql-apis|AWS AppSync"
   "rds describe-db-clusters|Amazon Aurora"
   "cloudhsmv2 describe-clusters|AWS CloudHSM"
   "codebuild list-projects|AWS CodeBuild"
   "connect list-instances|Amazon Connect"
   "eks list-clusters|Amazon Elastic Kubernetes Service (EKS)"
   "datasync list-tasks|AWS DataSync"
   "dax describe-clusters|Amazon DynamoDB Accelerator (DAX)"
   "dms describe-replication-instances|Amazon Database Migration Service"
   "docdb describe-db-clusters|Amazon DocumentDB"
   "directconnect describe-connections|AWS Direct Connect"
   "dynamodb list-tables|Amazon DynamoDB (built-in)"
   "ec2 describe-volumes|Amazon EBS (built-in)"
   "ec2 describe-instances|Amazon EC2 (built-in)"
   "ec2 describe-spot-fleet-requests|Amazon EC2 Spot Fleet"
   "elasticache describe-cache-clusters|Amazon ElastiCache (EC)"
   "elasticbeanstalk describe-environments|AWS Elastic Beanstalk"
   "efs describe-file-systems|Amazon Elastic File System (EFS)"
   "emr list-clusters|Amazon Elastic Map Reduce (EMR)"
   "es list-domain-names|Amazon Elasticsearch Service (ES)"
   "events list-event-buses|Amazon EventBridge"
   "fsx describe-file-systems|Amazon FSx"
   "gamelift list-fleets|Amazon GameLift"
   "glue get-jobs|AWS Glue"
   "inspector list-assessment-templates|Amazon Inspector"
   "kafka list-clusters|Amazon Managed Streaming for Kafka"
   "kinesisvideo list-streams|Amazon Kinesis Video Streams"
   "lambda list-functions|AWS Lambda (built-in)"
   "lex-models get-bots|Amazon Lex"
   "logs describe-log-groups|Amazon CloudWatch Logs"
   "mediaconnect list-flows|AWS Elemental MediaConnect"
   "mediapackage list-channels|Amazon MediaPackage Live"
   "mediapackage-vod list-packaging-configurations|Amazon MediaPackage Video on Demand"
   "ec2 describe-nat-gateways|Amazon VPC NAT Gateways"
   "neptune describe-db-clusters|Amazon Neptune"
   "opsworks describe-stacks|AWS OpsWorks"
   "polly list-speech-synthesis-tasks|Amazon Polly"
   "qldb list-ledgers|Amazon QLDB"
   "rds describe-db-instances|Amazon RDS (built-in)"
   "redshift describe-clusters|Amazon Redshift"
   "route53 list-hosted-zones|Amazon Route 53"
   "sesv2 list-email-identities|Amazon Simple Email Service (SES)"
   "sns list-topics|Amazon Simple Notification Service (SNS)"
   "sqs list-queues|Amazon Simple Queue Service (SQS)"
   "ssm list-commands|AWS Systems Manager - Run Command"
   "stepfunctions list-state-machines|AWS Step Functions"
   "transfer list-servers|Amazon Transfer Family"
   "ec2 describe-transit-gateways|AWS Transit Gateway"
   "translate list-text-translation-jobs|Amazon Translate"
   "ec2 describe-vpn-connections|AWS Site-to-Site VPN"
)

for service in "${services[@]}"
do
  query=$(echo $service | awk -F "|" '{print $1}')
  service_description=$(echo $service | awk -F "|" '{print $2}')
  
  service_test=$(aws $query | wc -l)
  if [ "$service_test" -gt 3 ]
  then
    managed_services+="${service_description},"
  fi

done


# Deviations to structure

service_test=$(aws cloudfront list-distributions | wc -l)

if [ "$service_test" -gt 0 ]
then
  managed_services+="Amazon CloudFront,"
fi

service_test=$(aws cognito-identity list-identity-pools --max-results 1 | wc -l)

if [ "$service_test" -gt 3 ]
then
  managed_services+="Amazon Cognito,"
fi

service_test=$(aws ecs list-clusters  | wc -l)

if [ "$service_test" -gt 3 ]
then
  managed_services+="Amazon Elastic Container Service (ECS),"
  managed_services+="Amazon ECS ContainerInsights,"
fi

service_test=$(aws autoscaling describe-auto-scaling-groups | wc -l)

if [ "$service_test" -gt 3 ]
then
  managed_services+="Amazon EC2 Auto Scaling,"
  managed_services+="Amazon EC2 Auto Scaling (built-in),"
fi


service_test_1=$(aws iot list-ca-certificates | wc -l)
service_test_2=$(aws iot list-custom-metrics | wc -l)
service_test_3=$(aws iot list-dimensions | wc -l)
service_test_4=$(aws iot list-fleet-metrics | wc -l)
service_test_5=$(aws iot list-jobs | wc -l)
service_test_6=$(aws iot list-streams | wc -l)


if [[ "$service_test_1" -gt 3 || "$service_test_2" -gt 3 || "$service_test_3" -gt 3 || "$service_test_4" -gt 3 || "$service_test_5" -gt 3 || "$service_test_6" -gt 3 ]]
then
  managed_services+="AWS Internet of Things (IoT),"
fi

 # greater than 4 in the if statement
services=(
  "kinesisanalytics list-applications|Amazon Kinesis Data Analytics"
  "firehose list-delivery-streams|Amazon Kinesis Data Firehose"
  "kinesis list-streams|Amazon Kinesis Data Streams"
  "rekognition list-collections|Amazon Rekognition"
  "route53resolver list-resolver-endpoints|Amazon Route 53 Resolver"
)

service_test=$(aws kinesisanalytics list-applications | wc -l)

for service in "${services[@]}"
do
  query=$(echo $service | awk -F "|" '{print $1}')
  service_description=$(echo $service | awk -F "|" '{print $2}')
  
  service_test=$(aws $query | wc -l)
  if [ "$service_test" -gt 4 ]
  then
    managed_services+="${service_description},"
  fi

done

service_test=$(aws elbv2 describe-load-balancers | wc -l)

if [ "$service_test" -gt 3 ]
then
  managed_services+="AWS Elastic Load Balancing (ELB) (built-in),"
  managed_services+="AWS Application and Network Load Balancer (built-in),"
fi

service_test=$(aws s3 ls | wc -l)

if [ "$service_test" -gt 0 ]
then
  managed_services+="Amazon S3,"
  managed_services+="Amazon S3 (built-in),"
fi

service_test_1=$(aws servicecatalog search-products | wc -l)
service_test_2=$(aws servicecatalog list-portfolios | wc -l)
service_test_3=$(aws servicecatalog list-service-actions | wc -l)

if [[ "$service_test_1" -gt 8 || "$service_test_2" -gt 3 || "$service_test_3" -gt 3 ]]
then
  managed_services+="AWS Service Catalog,"
fi

service_test_1=$(aws storagegateway list-volumes | wc -l)
service_test_2=$(aws storagegateway list-tapes | wc -l)
service_test_3=$(aws storagegateway list-gateways | wc -l)
service_test_4=$(aws storagegateway list-file-shares | wc -l)

if [[ "$service_test_1" -gt 3 || "$service_test_2" -gt 3 || "$service_test_3" -gt 3 || "$service_test_4" -gt 4 ]]
then
  managed_services+="AWS Storage Gateway,"
fi

service_test_1=$(aws swf list-domains --registration-status REGISTERED | wc -l)
service_test_2=$(aws swf list-domains --registration-status DEPRECATED | wc -l)

if [[ "$service_test_1" -gt 3 || "$service_test_2" -gt 3  ]]
then
  managed_services+="Amazon SWF,"
fi

service_test_1=$(aws waf list-rules | wc -l)
service_test_2=$(aws waf list-web-acls | wc -l)

if [[ "$service_test_1" -gt 3 || "$service_test_2" -gt 3  ]]
then
  managed_services+="Amazon WAF Classic,"
fi

service_test_1=$(aws wafv2 list-managed-rule-sets --scope CLOUDFRONT --region=us-east-1 | wc -l)
service_test_2=$(aws wafv2 list-managed-rule-sets --scope REGIONAL | wc -l)
service_test_3=$(aws wafv2 list-rule-groups --scope CLOUDFRONT --region=us-east-1 | wc -l)
service_test_4=$(aws wafv2 list-rule-groups --scope REGIONAL | wc -l)
service_test_5=$(aws wafv2 list-web-acls --scope CLOUDFRONT --region=us-east-1 | wc -l)
service_test_6=$(aws wafv2 list-web-acls --scope REGIONAL | wc -l)

if [[ "$service_test_1" -gt 3 || "$service_test_2" -gt 3 || "$service_test_3" -gt 3 ||
      "$service_test_4" -gt 3 || "$service_test_5" -gt 4 || "$service_test_6" -gt 4 ]]
then
  managed_services+="Amazon WAF ,"
fi

url=$(aws mediaconvert describe-endpoints | grep eu-west-2 | awk '{print $2}' | sed 's/"//g')

service_test_1=$(aws mediaconvert list-jobs --endpoint-url $url | wc -l)

if [[ "$service_test_1" -gt 3 ]]
then
  managed_services+="Amazon MediaConvert,"
fi

service_test=$(aws keyspaces list-keyspaces | wc -l)

if [ "$service_test" -gt 20 ]
then
  managed_services+="Amazon Keyspaces,"
fi


service_test_1=$(aws athena list-work-groups | wc -l)
service_test_2=$(aws athena list-data-catalogs | wc -l)

if [[ "$service_test_1" -gt 14 || "$service_test_2" -gt 8 ]]
then
  managed_services+="Amazon Athena,"
fi

echo "Managed services"
echo $managed_services | tr "," "\n" | sort

echo ""
echo "Lambda Tags"
echo ""

lambdas=$(aws lambda list-functions | jq '.Functions[].FunctionName')

for lambda in $lambdas
do
  lambda=$(echo $lambda | tr -d '"')
  
  if [[ $lambda != "AWSAccelerator-"* ]]; then
    system=$(aws lambda get-function --function-name $lambda | jq '.Tags.System')
    environment=$(aws lambda get-function --function-name $lambda | jq '.Tags.Environment')
    echo "Lambda: $lambda, System: $system, Environment: $environment"
  fi

done
