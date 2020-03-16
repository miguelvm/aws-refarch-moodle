#!/bin/bash
for TEMPLATE in 00-master.yaml 01-newvpc.yaml 02-securitygroups.yaml 03-bastion.yaml 03-efsfilesystem.yaml 03-elasticache.yaml 03-publicalb.yaml 03-rds.yaml 04-cloudfront.yaml 04-efsalarms.yaml 04-web.yaml 05-route53.yaml
do
    aws s3 cp templates/$TEMPLATE s3://mb3moodle/templates/$TEMPLATE 
done

# Creates stack without session caching

aws cloudformation create-stack --stack-name moodle39dev --template-url https://s3-eu-west-1.amazonaws.com/mb3moodle/templates/00-master.yaml --parameters \
                    ParameterKey=DatabaseInstanceType,ParameterValue=db.r5.4xlarge \
                    ParameterKey=UseApplicationCacheBoolean,ParameterValue=true \
                    ParameterKey=EfsEncrpytedBoolean,ParameterValue=true \
                    ParameterKey=DomainName,ParameterValue=moodle39dev.veiver.com \
                    ParameterKey=UseCloudFrontBoolean,ParameterValue=true \
                    ParameterKey=DatabaseName,ParameterValue=moodle \
                    ParameterKey=WebAsgMin,ParameterValue=1 \
                    ParameterKey=WebAsgMax,ParameterValue=1 \
                    ParameterKey=PublicAlbAcmCertificate,ParameterValue=arn:aws:acm:eu-west-1:526038215496:certificate/5e24ec78-7951-4a59-acba-669df1d7ebf1 \
                    ParameterKey=MoodleLocale,ParameterValue=en \
                    ParameterKey=ApplicationCacheNodeType,ParameterValue=cache.m5.xlarge \
                    ParameterKey=DatabaseMasterUsername,ParameterValue=moodle \
                    ParameterKey=NumberOfAZs,ParameterValue=2 \
                    ParameterKey=UseSessionCacheBoolean,ParameterValue=false \
                    ParameterKey=WebInstanceType,ParameterValue=t3.2xlarge \
                    ParameterKey=SessionCacheNodeType,ParameterValue=cache.m5.xlarge \
                    ParameterKey=DatabaseMasterPassword,ParameterValue=My0wnPr1vat3Pa33w0rd \
                    ParameterKey=DatabaseEncrpytedBoolean,ParameterValue=true \
                    ParameterKey=EfsPerformanceMode,ParameterValue=generalPurpose \
                    ParameterKey=EfsGrowth,ParameterValue=256 \
                    ParameterKey=EC2KeyName,ParameterValue=moodle \
                    ParameterKey=HostedZoneName,ParameterValue=veiver.com \
                    ParameterKey=AvailabilityZones,ParameterValue=\"eu-west-1a,eu-west-1b\" \
                    ParameterKey=CloudFrontAcmCertificate,ParameterValue=arn:aws:acm:us-east-1:526038215496:certificate/90b2bbdf-0bf7-47c7-94e4-891b032758b7 \
                    ParameterKey=EfsGrowthInstanceType,ParameterValue=r4.large \
                    ParameterKey=BastionInstanceType,ParameterValue=t2.nano \
                    ParameterKey=UseRoute53Boolean,ParameterValue=true \
                    ParameterKey=EfsCmk,ParameterValue= \
                    ParameterKey=DatabaseCmk,ParameterValue= \
                    --capabilities CAPABILITY_NAMED_IAM --disable-rollback

# Important: before running the configuration wizard
# disable opcache in /etc/php-7.2.d/10-opcache.ini:
#   opcache.enable=0
#
# disable reader instance in /var/www/moodle/html/config.php:
#   //  'readonly' => [
#   //    'instance' => 'mb3moodle-rds-5nihipy3drzj-databasecluster-k4fbpgme7bec.cluster-ro-c4uvy8r76ryw.eu-west-1.rds.amazonaws.com',
#   //  ],
#
# make efs great again:
# sudo nohup dd if=/dev/urandom of=2048gb-b.img bs=1024k count=256000 status=progress &