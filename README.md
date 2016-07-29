# AWS EC2 Instance - Disk Usage Email Alert 
This provides an example on how to setup a disk usage email alert using `CRON`, some shell script and [https://www.sendwithus.com/](SendWithUs).

Normally, I would not prefer using an Email Provider but AWS EC2 Instances won't allow sending of an email by just using `mail` which could have been much easier: [http://docs.rightscale.com/faq/clouds/aws/Why_are_mail_messages_sent_from_EC2_undelivered_or_flagged_as_spam.html](Read Why Here).

So, if you already have an Email Provider which you can use, why not leverage that to create an Email Alert?

# Why Recommend?

"It's portable from AWS to Azure to Google Cloud to whereever" - Jim Rath

# Other Options
Setup AWS SES or SMTP. (Note: I have neither available)

# The Shell Script
```
# Set Threshold
THRESHOLD=80

# Get Usage
# 'disk1' should be replaced by the device you need to check
# NOTE '$8' may need to change depending on what distro you are using. I figured 'df' for MAC and Ubuntu doesn't return the same set of columns.
USAGE=`df | awk '$1 ~ /disk1/ {print $8}' | cut -d"%" -f1`
 
echo "=== CHECKING USAGE ==="
echo "Threshold = $THRESHOLD%"
echo "Usage = $USAGE%"
 
if [ $USAGE -gt $THRESHOLD ]
then
    # call SendWithUs API
    # Replace 'your_sendwithus_api_key_here' with your SendWithUs API Key
    echo "Threshold reached. Sending Email..."
    curl -i -u your_sendwithus_api_key_here: https://api.sendwithus.com/api/v1/send --header "Accept:application/json" -d @$(pwd)/payload.json
fi
```

# So How Does this Work?

1. A shell script will check if you have reached your set disk usage THRESHOLD. In this case, disk is `disk1`, THRESHOLD is 80%.
2. Will send an Email Alert via SendWithUs.

# What do I need to define?
1. You need to create a template in SendWithUs and get your template ID. (if you are already using SendWithUs, you should already know this.)

2. You need to replace `your_sendwithus_api_key_here` with your actual API Key.

3. Define payload.json with necessary values such as Recipient, Sender, etc...

4. Setup CRON to run `check_disk_usage.sh` periodically.

# Note
You may need to run `chmod +x check_disk_usage.sh` to work.

# How did I get USAGE?
This line gets the usage for us
```
USAGE=`df | awk '$1 ~ /disk1/ {print $8}' | cut -d"%" -f1
```

1. `df` - https://en.wikipedia.org/wiki/Df_(Unix)
Returns ($1-$9 not included):

```
$1            $2              $3   $4        $5        $6      $7    $8      $9
Filesystem    512-blocks      Used Available Capacity  iused   ifree %iused  Mounted on
/dev/disk1     487849984 438662272  48675712    91% 54896782 6084464   90%   /
devfs                368       368         0   100%      638       0  100%   /dev
map -hosts             0         0         0   100%        0       0  100%   /net
map auto_home          0         0         0   100%        0       0  100%   /home
```

2. awk - disects the returned information from `df`. `$1 ~ /disk1/` checks the first column if it matches `disk1` then `{print $8}` prints column no. 8.

3. `cut -d "%" -f1` simply removes the `%` at the end of the returned value.
