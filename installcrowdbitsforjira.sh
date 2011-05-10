#!/opt/local/bin/bash
# Enable Crowd Authentication with a fresh JIRA Install
#
# http://confluence.atlassian.com/display/CROWD/Integrating+Crowd+with+Atlassian+JIRA#IntegratingCrowdwithAtlassianJIRA-Step2.ConfiguringJIRAtotalktoCrowd
# 
# Copyright (c) 2010-2011 Jacques Marneweck <jacques@powertrip.co.za>
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

CROWD_VERSION=2.2.4
JIRA_VERSION=4.3.3
CROWD_PATH=/home/crowd/atlassian-crowd-${CROWD_VERSION}
JIRA_PATH=/home/jira/atlassian-jira-${JIRA_VERSION}

CROWD_PASS=`grep pass ${CROWD_PATH}/client/conf/crowd.properties | awk '{ print $2 }'`

if [ -z $1 ]; then
    echo "Usage: $0 <JIRA APP PASSWORD>"
    echo "Reset the password for JIRA under Apps in your crowd console."
    exit
fi

JIRA_PASS=$1

if [ -f ${JIRA_PATH}/atlassian-jira/WEB-INF/lib/crowd-integration-client-2.0.7.jar ]; then
  rm ${JIRA_PATH}/atlassian-jira/WEB-INF/lib/crowd-integration-client-2.0.7.jar
fi

cp -pr ${CROWD_PATH}/client/crowd-integration-client-${CROWD_VERSION}.jar ${JIRA_PATH}/atlassian-jira/WEB-INF/lib
cp -pr ${CROWD_PATH}/client/conf/crowd.properties ${JIRA_PATH}/atlassian-jira/WEB-INF/classes
cp -pr ${CROWD_PATH}/client/conf/crowd-ehcache.xml ${JIRA_PATH}/atlassian-jira/WEB-INF/classes/crowd-ehcache.xml

gsed -i'' '/^application.name/s/crowd/jira/' ${JIRA_PATH}/atlassian-jira/WEB-INF/classes/crowd.properties
gsed -i'' '/^application.password/s/${CROWD_PASS}/${JIRA_APP_PASS}/' ${JIRA_PATH}/atlassian-jira/WEB-INF/classes/crowd.properties
gsed -i"" -e "s/localhost/`hostname`/g" ${JIRA_PATH}/atlassian-jira/WEB-INF/classes/crowd.properties