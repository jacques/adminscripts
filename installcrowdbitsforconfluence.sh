#!/opt/local/bin/bash
# Enable Crowd Authentication with a fresh Atlassian Confluence Install
#
# http://confluence.atlassian.com/display/CROWD/Integrating+Crowd+with+Atlassian+Confluence
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
CONFLUENCE_VERSION=3.5.4
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

cp -pr ${CROWD_PATH}/client/crowd-integration-client-${CROWD_VERSION}.jar ${CONFLUENCE_PATH}/confluence/WEB-INF/lib/

cp -pr ${CROWD_PATH}/client/crowd-integration-client-${CROWD_VERSION}.jar ${CONFLUENCE_PATH}/confluence/WEB-INF/lib
cp -pr ${CROWD_PATH}/client/conf/crowd.properties ${CONFLUENCE_PATH}/confluence/WEB-INF/classes
cp -pr ${CROWD_PATH}/client/conf/crowd-ehcache.xml ${CONFLUENCE_PATH}/confluence/WEB-INF/classes/crowd-ehcache.xml

gsed -i'' '/^application.name/s/crowd/confluence/' ${CONFLUENCE_PATH}/confluence/WEB-INF/classes/crowd.properties
gsed -i'' '/^application.password/s/${CROWD_PASS}/${CONFLUENCE_APP_PASS}/' ${CONFLUENCE_PATH}/confluence/WEB-INF/classes/crowd.properties
gsed -i"" -e "s/localhost/${CROWD_HOSTNAME}/g" ${CONFLUENCE_PATH}/confluence/WEB-INF/classes/crowd.properties

# Enable crowd for user authentication in confluence
# First comment out confluences user database
gsed -i"" '/com.atlassian.confluence.user.ConfluenceAuthenticator/s/^/<!--/' ${CONFLUENCE_PATH}/confluence/WEB-INF/classes/seraph-config.xml
gsed -i"" '/com.atlassian.confluence.user.ConfluenceAuthenticator/s/$/-->/' ${CONFLUENCE_PATH}/confluence/WEB-INF/classes/seraph-config.xml
# Now enable the crowd SSO
gsed -i"" '/com.atlassian.confluence.user.ConfluenceCrowdSSOAuthenticator/s/<!--//' ${CONFLUENCE_PATH}/confluence/WEB-INF/classes/seraph-config.xml
gsed -i"" '/com.atlassian.confluence.user.ConfluenceCrowdSSOAuthenticator/s/-->//' ${CONFLUENCE_PATH}/confluence/WEB-INF/classes/seraph-config.xml
