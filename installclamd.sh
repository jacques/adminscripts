#!/bin/bash
# Install clamav
pkgin up
pkgin in clamav

gsed -i'.bak' '/^Example/s/Example/#Example/' freshclam.conf clamd.conf
git diff freshclam.conf clamd.conf
gsed -i'.bak2' '/^#DatabaseMirror/s/XY/us/' freshclam.conf
git diff freshclam.conf clamd.conf
gsed -i'.bak3' '/^#DatabaseMirror/s/#//' freshclam.conf
git diff freshclam.conf clamd.conf
