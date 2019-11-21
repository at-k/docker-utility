#!/bin/sh

set -xu

issue_url="https://jira-freee.atlassian.net/browse/"
slack_url="https://hooks.slack.com/services/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"

echo > body.txt

# 未着手なやつ
echo "未着手なチケットです" >> body.txt
echo "\`\`\`" >> body.txt
issues=$(jira ls -q "project = SRE AND issuetype = Ask AND labels = ask_SRE AND status = \"TO DO\"" | cut -d: -f1 )
for issue in $issues; do
  jira view $issue -t debug | jq -r '[.key = "'${issue_url}'" + .key | .key,.fields.assignee.key,.fields.updated] | @csv' >> body.txt
done
echo "\`\`\`" >> body.txt

# 最終更新から1週間以上経っているやつ
echo "放置されているチケットです" >> body.txt
echo "\`\`\`" >> body.txt
issues=$(jira ls -q "project = SRE AND issuetype = Ask AND labels = ask_SRE AND (status = DOING AND updated < \"-1w\")" | cut -d: -f1)
for issue in $issues; do
  jira view $issue -t debug | jq -r '[.key = "'${issue_url}'" + .key | .key,.fields.assignee.key,.fields.updated] | @csv' >> body.txt
done
echo "\`\`\`" >> body.txt

body=$(cat body.txt | tr '\n' '\\' | sed 's/\\/\\n/g'| sed 's/\"/\\"/g')
curl -s -S -X POST --data-urlencode "payload={\"text\": \"${body}\" }" ${slack_url}
