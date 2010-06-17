#!/opt/local/bin/bash
# Downloads and installs phpMyAdmin
#
# Copyright 2005-2010 Jacques Marneweck <jacques@powertrip.co.za>
PHPMYADMIN_VERSION=3.3.3

wget http://downloads.sourceforge.net/project/phpmyadmin/phpMyAdmin/${PHPMYADMIN_VERSION}/phpMyAdmin-${PHPMYADMIN_VERSION}-all-languages.tar.bz2?use_mirror=softlayer

gtar -jxvf phpMyAdmin-${PHPMYADMIN_VERSION}-all-languages.tar.bz2
cd phpMyAdmin-${PHPMYADMIN_VERSION}-all-languages
cp config.sample.inc.php config.inc.php

HASH=$(dd if=/dev/random bs=32 count=1 2>/dev/null | openssl base64)
gsed -i"" -e "s/blowfish_secret'] = ''/blowfish_secret'] = '${HASH}'/g" config.inc.php
