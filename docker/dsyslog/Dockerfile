FROM ubuntu
RUN apt update && apt install rsyslog curl python3 -y
RUN echo '$ModLoad imudp \n\
$UDPServerRun 514 \n\
$ModLoad imtcp \n\
$InputTCPServerRun 514 \n\
$template RemoteStore, "/var/log/dataset/%HOSTNAME%/%$year%/%$Month%/%$Day%/%$Hour%/%SOURCE%.%FROMHOST%.%FROMHOST-IP%.%SYSLOGTAG%.log" \n\
$template RFC3164fmt,"<%PRI%>%TIMESTAMP% %HOSTNAME% %syslogtag%%msg%" \n\
:source, !isequal, "localhost" -?RemoteStore \n\
:source, isequal, "last" ~ ' > /etc/rsyslog.conf
RUN cd /tmp; curl -sO https://www.scalyr.com/install-agent.sh;  bash ./install-agent.sh 
RUN sed -i 's/],/\/\/],/g' /etc/scalyr-agent-2/agent.json; sed -i 's/api_key:/\/\/api_key:/g' /etc/scalyr-agent-2/agent.json; sed -i 's/logs:/\/\/logs:/g' /etc/scalyr-agent-2/agent.json; touch /etc/scalyr-agent-2/agent.d/logs.json
COPY docker-entrypoint.sh /usr/local/bin/
RUN ["chmod", "+x", "/usr/local/bin/docker-entrypoint.sh"]
ENTRYPOINT ["sh", "/usr/local/bin/docker-entrypoint.sh"]
