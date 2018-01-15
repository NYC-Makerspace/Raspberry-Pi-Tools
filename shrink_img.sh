set -e
set -u
img=$1

sudo ./PiShrink/pishrink.sh $img ${img}-shrunk
pigz ${img}-shrunk
