#!/opt/local/bin/bash
# Enable Crowd Authentication with a fresh JIRA Install
#
# http://confluence.atlassian.com/display/CROWD/Integrating+Crowd+with+Atlassian+JIRA#IntegratingCrowdwithAtlassianJIRA-Step2.ConfiguringJIRAtotalktoCrowd

CROWD_VERSION=2.0.7
JIRA_VERSION=4.1.2
CROWD_PATH=/home/crowd/atlassian-crowd-${CROWD_VERSION}
JIRA_PATH=/home/jira/atlassian-jira-enterprise-${JIRA_VERSION}-standalone

CROWD_PASS=`grep pass ${CROWD_PATH}/client/conf/crowd.properties | awk '{ print $2 }'`

if [ -z $1 ]; then
    echo "Usage: $0 <JIRA APP PASSWORD>"
    echo "Reset the password for JIRA under Apps in your crowd console."
    exit
fi

JIRA_PASS=$1

rm ${JIRA_PATH}/atlassian-jira/WEB-INF/lib/crowd-integration-client-2.0.4.jar
cp -pr ${CROWD_PATH}/client/crowd-integration-client-${CROWD_VERSION}.jar ${JIRA_PATH}/atlassian-jira/WEB-INF/lib
cp -pr ${CROWD_PATH}/client/conf/crowd.properties ${JIRA_PATH}/atlassian-jira/WEB-INF/classes
cp -pr ${CROWD_PATH}/client/conf/crowd-ehcache.xml ${JIRA_PATH}/atlassian-jira/WEB-INF/classes/crowd-ehcache.xml

gsed -i'' '/^application.name/s/crowd/jira/' ${JIRA_PATH}/atlassian-jira/WEB-INF/classes/crowd.properties
gsed -i'' '/^application.password/s/${CROWD_PASS}/${JIRA_APP_PASS}/' ${JIRA_PATH}/atlassian-jira/WEB-INF/classes/crowd.properties
gsed -i"" -e "s/localhost/`hostname`/g" ${JIRA_PATH}/atlassian-jira/WEB-INF/classes/crowd.properties
