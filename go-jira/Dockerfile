FROM alpine

RUN apk add jq

RUN wget -O /usr/local/bin/jira https://github.com/go-jira/jira/releases/download/v1.0.22/jira-linux-amd64 && \
    chmod +x /usr/local/bin/jira

RUN mkdir /root/.jira.d
ADD config.yml /root/.jira.d/config.yml
