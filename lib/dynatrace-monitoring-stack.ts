import * as cdk from 'aws-cdk-lib';
import { Construct } from 'constructs';
import * as iam from 'aws-cdk-lib/aws-iam';

interface StackProps extends cdk.StackProps {
  dynatraceAccountId: string;
  dynatraceActivegateRole: iam.IRole;
}

export class DynatraceMonitoringRoleStack extends cdk.Stack {
  constructor(scope: Construct, id: string, props: StackProps) {
    super(scope, id, props);

    const role = new iam.Role(this, 'role', {
      roleName: 'DynatraceMonitoringRole',
      assumedBy: new iam.CompositePrincipal(
        new iam.AccountPrincipal('509560245411'),
        new iam.AccountPrincipal(props.dynatraceAccountId),
        new iam.ArnPrincipal(props.dynatraceActivegateRole.roleArn)
      ).withConditions({
        StringEquals: {
          'sts:ExternalId': '8ddda2c2-8a5e-450c-9c73-74a92da96e17'
        }
      })
    });

    role.addToPolicy(
      new iam.PolicyStatement({
        actions: [
          'cloudwatch:GetMetricData',
          'cloudwatch:GetMetricStatistics',
          'cloudwatch:ListMetrics',
          'sts:GetCallerIdentity',
          'tag:GetResources',
          'tag:GetTagKeys',
          'autoscaling:DescribeAutoScalingGroups',
          'rds:DescribeDBInstances',
          'rds:DescribeEvents',
          'rds:ListTagsForResource',
          'ec2:DescribeAvailabilityZones',
          'ec2:DescribeInstances',
          'ec2:DescribeVolumes',
          'apigateway:GET',
          'cloudfront:ListDistributions',
          'codebuild:ListProjects',
          'dynamodb:ListTables',
          'dynamodb:ListTagsOfResource',
          'ecs:ListClusters',
          'elasticache:DescribeCacheClusters',
          'elasticloadbalancing:DescribeInstanceHealth',
          'elasticloadbalancing:DescribeListeners',
          'elasticloadbalancing:DescribeLoadBalancers',
          'elasticloadbalancing:DescribeRules',
          'elasticloadbalancing:DescribeTags',
          'elasticloadbalancing:DescribeTargetHealth',
          'lambda:ListFunctions',
          'lambda:ListTags',
          'route53:ListHostedZones',
          's3:ListAllMyBuckets',
          'sns:ListTopics',
          'sqs:ListQueues'
        ],
        resources: ['*']
      })
    );
  }
}
