#!/bin/bash
for (( SN=193; SN<=197; SN++ ))
  do for (( A=1; A<=253; A++ ))
     do
     echo "Generating for 159.46.$SN.$A"
      sncdb -I 159.46.$SN.$A --no-os | grep -v Geen >> jubit-ext-$SN.txt
  done
done