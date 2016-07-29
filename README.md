# AWS EC2 Instance - Disk Usage Email Alert 
This provides an example on how to setup a disk usage email alert using `CRON`, some shell script and [https://www.sendwithus.com/](SendWithUs).

Normally, I would not prefer using an Email Provider but AWS EC2 Instances won't allow sending of an email by just using `mail` which could have been much easier: [http://docs.rightscale.com/faq/clouds/aws/Why_are_mail_messages_sent_from_EC2_undelivered_or_flagged_as_spam.html](Read Why Here).

So, if you already have an Email Provider which you can use, why not leverage that to create an Email Alert?

# Other Options
Setup AWS SES or SMTP. (Note: I have neither available)
