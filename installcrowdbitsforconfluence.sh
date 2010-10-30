#!/opt/local/bin/bash
# Enable Crowd Authentication with a fresh Atlassian Confluence Install
#
# http://confluence.atlassian.com/display/CROWD/Integrating+Crowd+with+Atlassian+Confluence

CROWD_VERSION=2.0.7
CONFLUENCE_VERSION=3.4
CROWD_PATH=/home/crowd/atlassian-crowd-${CROWD_VERSION}
CONFLUENCE_PATH=/home/confluence/confluence-${CONFLUENCE_VERSION}-std
CROWD_HOSTNAME=your.crowd.host
CROWD_PASS=`grep pass ${CROWD_PATH}/client/conf/crowd.properties | awk '{ print $2 }'`

if [ -z $1 ]; then
echo "Usage: $0 <CONFLUENCE APP PASSWORD>"
    echo "Reset the password for CONFLUENCE under Apps in your crowd console."
    exit
fi

CONFLUENCE_PASS=$1

cp -pr ${CROWD_PATH}/client/crowd-integration-client-${CROWD_VERSION}.jar ${CONFLUENCE_PATH}/confluence/WEB-INF/lib
cp -pr ${CROWD_PATH}/client/conf/crowd.properties ${CONFLUENCE_PATH}/confluence/WEB-INF/classes
cp -pr ${CROWD_PATH}/client/conf/crowd-ehcache.xml ${CONFLUENCE_PATH}/confluence/WEB-INF/classes/crowd-ehcache.xml

gsed -i'' '/^application.name/s/crowd/confluence/' ${CONFLUENCE_PATH}/confluence/WEB-INF/classes/crowd.properties
gsed -i'' '/^application.password/s/${CROWD_PASS}/${CONFLUENCE_APP_PASS}/' ${CONFLUENCE_PATH}/confluence/WEB-INF/classes/crowd.properties
gsed -i"" -e "s/localhost/${CROWD_HOSTNAME}/g" ${CONFLUENCE_PATH}/confluence/WEB-INF/classes/crowd.properties