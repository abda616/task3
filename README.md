# task3
this code used in AWS ec2 user data
it will install wordpress and any other softwear like (http, mysql, php)
then will get envirment from ssm-prameter store fitch them into wp-config.php
after that it will connect to database and efs (network file sys).

resorce :

conf-php : https://chatgpt.com/share/e90bb9b4-00f7-4e48-b382-98310ceaa896
efs : https://chatgpt.com/share/1933e8f1-3cbf-4415-84a8-5c9fdd26faef

https://repost.aws/questions/QUdiAD4rY2SHynBbiwX7KT1A/efs-does-not-automaticall-mount-on-reboot
https://docs.aws.amazon.com/efs/latest/ug/mount-fs-auto-mount-onreboot.html
https://docs.aws.amazon.com/efs/latest/ug/nfs-automount-efs.html
