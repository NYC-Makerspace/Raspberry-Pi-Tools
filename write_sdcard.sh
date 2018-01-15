set -e
set -u
set -x

function main {
  local img=$1
  local device=$2

  sudo umount $device* || /bin/true
  if [[ $img == *.gz ]] ; then
    zcat $img| sudo dcfldd of=$device bs=1M
  else
    sudo dcfldd if=$img of=$device bs=1M
  fi

  sudo sync
  sudo umount $device* || /bin/true
}
main $@
