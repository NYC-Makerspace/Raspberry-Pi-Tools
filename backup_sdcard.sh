# backup and compress a device file (like external SD card)

set -e
set -u

function main {
local device="${1}"
local img="${2:-/tmp/`date +%Y%m%d`-sd.img}"

# sudo umount $device* || /bin/true
# sudo dcfldd if=$device  | pigz  > ${img}.gz
# sudo sync

sudo -s -- <<EOF
umount $device* || true
dcfldd if=$device of=${img}.large
sync ${img}.large
./PiShrink/pishrink.sh ${img}.large $img
EOF
rm -f ${img}.large
pigz ${img}

ls -sh $img.gz
}

if [[ "${1:--h}" = "-h" ]] ; then
  echo "usage:  $0  /dev/device-file  [output-file.img]"
  exit 1
fi
set -x
main $@
