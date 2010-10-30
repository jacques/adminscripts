#!/bin/bash
# Install clamav
pkgin up
pkgin -y in clamav

gsed -i'' '/^Example/s/Example/#Example/' freshclam.conf clamd.conf
gsed -i'' '/^#DatabaseMirror/s/XY/us/' freshclam.conf
gsed -i'' '/^#DatabaseMirror/s/#//' freshclam.conf
