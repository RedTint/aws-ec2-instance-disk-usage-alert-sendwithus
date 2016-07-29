# Set Threshold
THRESHOLD=80

# Get Usage
# 'disk1' should be replaced by the device you need to check
USAGE=`df | awk '$1 ~ /disk1/ {print $8}' | cut -d"%" -f1`
 
echo "=== CHECKING USAGE ==="
echo "Threshold = $THRESHOLD%"
echo "Usage = $USAGE%"
 
if [ $USAGE -gt $THRESHOLD ]
then
    # call SendWithUs API
    # Replace 'your_sendwithus_app_key_here' with your SendWithUs API Key
    echo "Threshold reached. Sending Email..."
    curl -i -u your_sendwithus_app_key_here: https://api.sendwithus.com/api/v1/send --header "Accept:application/json" -d @$(pwd)/payload.json
fi
