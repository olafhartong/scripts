#!/bin/bash
HOST=export_acs-feb.csv

year=`date +%Y`
month=`date +%m`
day=`date +%d`
hour=`date +%H`
min=`date +%M`
timestamp=${year}${month}${day}${hour}${min}

echo "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>" >> endpoints-$timestamp.xml
echo "<TipsContents xmlns=\"http://www.avendasys.com/tipsapiDefs/1.0\">" >> endpoints-$timestamp.xml
echo "  <TipsHeader exportTime=\"Tue Oct 21 10:00:00 CET 2015\" version=\"6.5\"/>" >> endpoints-$timestamp.xml
echo "  <Endpoints>" >> endpoints-$timestamp.xml


exec 3<&0
 exec 0<$HOST
 while read ENDPOINT
do
  echo "Generating for $ENDPOINT"
  MAC=$(echo "$ENDPOINT" | awk 'BEGIN {FS = ";"} {print $1}' | tr -d -)
  DESC=$(echo "$ENDPOINT" | awk 'BEGIN {FS = ";"} {print $2}')
  GRP=$(echo "$ENDPOINT" | awk 'BEGIN {FS = ";"} {print $4}')
  echo "    <Endpoint macAddress=\"$MAC\" status=\"Known\" description=\"$DESC\">" >> endpoints-$timestamp.xml
  echo "      <EndpointTags tagname=\"Device Type\" tagValue=\"$GRP\"/>" >> endpoints-$timestamp.xml
  echo "    </Endpoint>" >> endpoints-$timestamp.xml
done

echo "  </Endpoints>" >> endpoints-$timestamp.xml
echo "    <TagDictionaries>" >> endpoints-$timestamp.xml
echo "      <TagDictionary allowMultiple="true" mandatory="false" dataType="String" attributeName="Device Type" entityName="Endpoint"/>" >> endpoints-$timestamp.xml
echo "    </TagDictionaries>" >> endpoints-$timestamp.xml
echo "</TipsContents>" >> endpoints-$timestamp.xml
