

#
#echo "Downloading raw events..."
#echo '["REQ", "RAND", {"kinds": [1], "limit": 000}]' |
#  nostcat wss://relay.nostr.ch |
#  jq '.[2]' > raw
#echo "Downloading raw events				done"
#echo "Downloading raw events		:)		done"
#echo "Downloading raw events				done"
#


LIMIT="5000"



while read RELAY
do
	RELAYSHORT=$(echo "$RELAY" | sed 's/^.\{6\}//')
	echo $RELAY
	echo $RELAYSHORT
echo "Downloading events timestamps from '$RELAY'..."
echo '["REQ", "RAND", {"kinds": [1], "limit": '$LIMIT'}]' |
  nostcat "$RELAY" |
  jq '.[2].created_at' > time
echo "Downloading events timestamps			done"
echo "Downloading events timestamps	:)		done"
echo "Downloading events timestamps			done"

echo "Downloading events pubkeys..."
echo '["REQ", "RAND", {"kinds": [1], "limit": '$LIMIT'}]' |
  nostcat "$RELAY" |
  jq '.[2].pubkey' > pubkey
echo "Downloading events pubkeys				done"
echo "Downloading events pubkeys		:)		done"
echo "Downloading events pubkeys				done"

# end of 01 dl 

echo "Removing quotes from pubkeys..."
sed -i 's/^.//' pubkey
sed -i 's/.$//' pubkey
echo "Removed quotes from pubkeys  		done"
echo "Removed quotes from pubkeys  	:)	done"
echo "Removed quotes from pubkeys  		done"
cp pubkey file

# end of 02 sed pubkey

echo " Adding |A to pubkeys..."
sed 's/$/|A|/' pubkey > log
echo " Added |A to pubkeys			done "

#end of add a

sed -i 's/$/|/' time
echo " Added | to time 						done"

# end of slash time

echo "Adding relay directory."
sed -i 's/$/\/events\/$RELAYSHORT\//' log
echo "ok"

#end of add relay name


paste time log > timelog
paste timelog file > timelogfile

sed -i 's/$/.event/' timelogfile

# remove tabulation #
sed -i 's/\t//g' timelogfile

cat timelogfile | sort -n > $RELAYSHORT.txt
rm -f file
rm -f gourceb
rm -f log
rm -f pubkey
rm -f raw 
rm -f time
rm -f timelog
rm -f timelogfile

mv $RELAYSHORT.txt ../gourcelogs/$RELAYSHORT.txt

done < relay.txt

