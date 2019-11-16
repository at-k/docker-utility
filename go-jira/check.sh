#!/bin/sh

issue_url="https://jira-freee.atlassian.net/browse/"
slack_url=""

echo > body.txt

# 未着手なやつ
issues=$(jira ls -q "project = SRE AND issuetype = Ask AND labels = ask_SRE AND status = \"TO DO\"" | cut -d: -f1)

for issue in issues; do
  # jira view DONBURI-7290 -t debug | jq '.fields.assignee.name'
  jira view $issue -t debug | jq -r '[.key = "'${issue_url}'" + .key | .key,.fields.assignee.name] | @csv' >> body.txt
done

# 最終更新から1週間以上経っているやつ
issues=$(jira ls -q "project = SRE AND issuetype = Ask AND labels = ask_SRE AND (status = DOING AND updated < \"-1w\")" | cut -d: -f1)

for issue in issues; do
  jira view $issue -t debug | jq -r '[.key = "'${issue_url}'" + .key | .key,.fields.assignee.name,.fields.updated] | @csv' >> body.txt
done

#curl -X POST -H 'Content-type: application/json' --data '{"text":"Allow me to reintroduce myself!"}' $slack_url
curl -X POST -H 'Content-type: application/json' -d @body.json $slack_url
