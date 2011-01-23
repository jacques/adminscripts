#!/opt/local/bin/bash
# Downloads and installs phpMyAdmin
#
# Copyright (c) 2005-2011 Jacques Marneweck <jacques@powertrip.co.za>
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


PHPMYADMIN_VERSION=3.3.8.1

wget http://downloads.sourceforge.net/project/phpmyadmin/phpMyAdmin/${PHPMYADMIN_VERSION}/phpMyAdmin-${PHPMYADMIN_VERSION}-all-languages.tar.bz2?use_mirror=softlayer

gtar -jxvf phpMyAdmin-${PHPMYADMIN_VERSION}-all-languages.tar.bz2
cd phpMyAdmin-${PHPMYADMIN_VERSION}-all-languages
cp config.sample.inc.php config.inc.php

HASH=$(dd if=/dev/random bs=32 count=1 2>/dev/null | openssl base64)
gsed -i"" -e "s/blowfish_secret'] = ''/blowfish_secret'] = '${HASH}'/g" config.inc.php

cd ..
ln -s phpMyAdmin-${PHPMYADMIN_VERSION}-all-languages phpMyAdmin