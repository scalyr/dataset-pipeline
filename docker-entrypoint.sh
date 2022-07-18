rm -f /var/run/rsyslogd.pid || exit 0
scalyr-agent-2 start; rsyslogd -n 
