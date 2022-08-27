FROM ubuntu
RUN apt-get update -y; apt-get install -y curl python3 logrotate
RUN cd /tmp; curl -sO https://www.scalyr.com/install-agent.sh;  bash ./install-agent.sh 
RUN sed -i 's/],/\/\/],/g' /etc/scalyr-agent-2/agent.json; sed -i 's/api_key:/\/\/api_key:/g' /etc/scalyr-agent-2/agent.json; sed -i 's/logs:/\/\/logs:/g' /etc/scalyr-agent-2/agent.json; touch /etc/scalyr-agent-2/agent.d/logs.json
COPY ./docker-entrypoint.sh /usr/local/bin/
RUN ["chmod", "+x", "/usr/local/bin/docker-entrypoint.sh"]
ENTRYPOINT ["sh", "/usr/local/bin/docker-entrypoint.sh"]
