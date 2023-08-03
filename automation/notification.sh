#!/bin/bash
# get variables form gitlab-ci or locals
source ./automation/read_config.sh
source ./automation/docker_getenv.sh

TELEGRAM_CHAT_ID="-1001508340482"
PARSE_MODE="Markdown"
COMMIT=$(git log -1 --pretty=format:"%s")


# Send message function
send_msg () {
    curl -s -X POST ${BOT_URL} -d chat_id=$TELEGRAM_CHAT_ID \
        -d text="$1" -d parse_mode=${PARSE_MODE}
}


# Call send message with the message
send_msg "
\`------------------------------\`
Deploy 🚀*${BRANCH_NAME}!*
\`Build: ${BUILD_NUMBER}\`
\`Repo: ${REPOSITORY}\`
\`Branch: ${BRANCH_NAME}\`
\`Commit: ${GIT_SHORT}\`
\`Version✅: ${VERSION}\`
\`Author🧑‍💻: ${GIT_USER}\`
*Commit Msg 💭:* _${COMMIT}_
\`-------------------------------\`
"