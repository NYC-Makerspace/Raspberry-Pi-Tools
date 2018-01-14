set -e
set -u

function main {
  local host="pi@raspberrypi"
  local display=":1"

  while getopts "h:d:" opt; do
      case $opt in
          h ) local host="${OPTARG}";;
          d ) local display="${OPTARG}";;
          *) echo "usage:  $0  [-h ssh_hostname] [-d x11_display]"
          exit 1;;
      esac
  done

  sshcmd="ssh \
    -o StrictHostKeyChecking=no \
    -o UserKnownHostsFile=/dev/null \
    $host"

  (
  set -x
  $sshcmd tigervncserver $display -localhost yes
  $sshcmd -f -L 5901:127.0.0.1:5901 $host sleep 5
  vncviewer 127.0.0.1:5901
  $sshcmd tigervncserver -kill
  ) &
  disown
}
main $@
