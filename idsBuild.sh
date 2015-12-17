#!/bin/bash

#
# This script is only intended to run in the IBM DevOps Services Pipeline Environment.
#

#!/bin/bash
echo Informing slack...
curl -X 'POST' --silent --data-binary '{"text":"A new build for the concierge service has started."}' $WEBHOOK > /dev/null

echo Setting up Docker...
mkdir dockercfg ; cd dockercfg
echo -e $KEY > key.pem
echo -e $CA_CERT > ca.pem
echo -e $CERT > cert.pem
cd ..
	 
echo Building projects using gradle...
./gradlew build
echo Building and Starting Concierge Docker Image...
cd concierge-wlpcfg
../gradlew buildDockerImage
../gradlew stopCurrentContainer
../gradlew removeCurrentContainer
../gradlew startNewContainer

cd ..
rm -rf dockercfg
