#!/bin/bash
for TEMPLATE in 00-master.yaml 01-newvpc.yaml 02-securitygroups.yaml 03-bastion.yaml 03-efsfilesystem.yaml 03-elasticache.yaml 03-publicalb.yaml 03-rds.yaml 04-cloudfront.yaml 04-efsalarms.yaml 04-web.yaml 05-route53.yaml
do
    aws s3 cp templates/$TEMPLATE s3://mb3moodle/templates/$TEMPLATE 
done


aws cloudformation create-stack --stack-name mb3moodle --template-url https://s3-eu-west-1.amazonaws.com/mb3moodle/templates/00-master.yaml --parameters \
                    ParameterKey=DatabaseInstanceType,ParameterValue=db.r5.4xlarge \
                    ParameterKey=UseApplicationCacheBoolean,ParameterValue=true \
                    ParameterKey=EfsEncrpytedBoolean,ParameterValue=true \
                    ParameterKey=DomainName,ParameterValue=veiver.com \
                    ParameterKey=UseCloudFrontBoolean,ParameterValue=true \
                    ParameterKey=DatabaseName,ParameterValue=moodle \
                    ParameterKey=WebAsgMin,ParameterValue=1 \
                    ParameterKey=WebAsgMax,ParameterValue=1 \
                    ParameterKey=PublicAlbAcmCertificate,ParameterValue=arn:aws:acm:eu-west-1:526038215496:certificate/d88f19ed-657c-457e-b690-b4b855981885 \
                    ParameterKey=MoodleLocale,ParameterValue=en \
                    ParameterKey=ApplicationCacheNodeType,ParameterValue=cache.t2.micro \
                    ParameterKey=DatabaseMasterUsername,ParameterValue=moodle \
                    ParameterKey=NumberOfAZs,ParameterValue=2 \
                    ParameterKey=UseSessionCacheBoolean,ParameterValue=false \
                    ParameterKey=WebInstanceType,ParameterValue=t3.xlarge \
                    ParameterKey=SessionCacheNodeType,ParameterValue=cache.t2.micro \
                    ParameterKey=DatabaseMasterPassword,ParameterValue=My0wnPr1vat3Pa33w0rd \
                    ParameterKey=DatabaseEncrpytedBoolean,ParameterValue=true \
                    ParameterKey=EfsPerformanceMode,ParameterValue=generalPurpose \
                    ParameterKey=EC2KeyName,ParameterValue=moodle \
                    ParameterKey=HostedZoneName,ParameterValue=veiver.com \
                    ParameterKey=AvailabilityZones,ParameterValue=\"eu-west-1a,eu-west-1b\" \
                    ParameterKey=CloudFrontAcmCertificate,ParameterValue=arn:aws:acm:us-east-1:526038215496:certificate/c78fe888-6ac3-4498-ac86-dce1fb1f282c \
                    ParameterKey=EfsGrowthInstanceType,ParameterValue=r4.large \
                    ParameterKey=BastionInstanceType,ParameterValue=t2.nano \
                    ParameterKey=UseRoute53Boolean,ParameterValue=true \
                    ParameterKey=EfsCmk,ParameterValue= \
                    ParameterKey=DatabaseCmk,ParameterValue= \
                    --capabilities CAPABILITY_NAMED_IAM --disable-rollback


                    
