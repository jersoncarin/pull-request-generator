#!/bin/bash

GITHUB_TOKEN=""
REPO_OWNER=""
REPO_NAME=""

remove_prefixes() {
    local commit_message="$1"
    local prefixes=("fix:" "feat:" "chore:")
    local regex="^($(IFS="|"; echo "${prefixes[*]}"))\\s*"
    echo "$commit_message" | sed -E "s/$regex//i"
}

format_date() {
    date "+%Y-%m-%d-%H-%M-%S"
}

delete_git_ref() {
    local repo_owner="$1"
    local repo_name="$2"
    local ref="$3"
    local url="https://api.github.com/repos/${repo_owner}/${repo_name}/git/refs/${ref}"
    local response
    response=$(curl -s -o /dev/null -w "%{http_code}" -X DELETE -H "Accept: application/vnd.github+json" -H "Authorization: Bearer ${GITHUB_TOKEN}" -H "X-GitHub-Api-Version: 2022-11-28" "$url")
    
    if [[ "$response" -eq 204 ]]; then
        echo "Git reference deleted successfully."
    else
        echo "Failed to delete git reference: $response"
    fi
}

create_pull_request() {
    local repo_owner="$1"
    local repo_name="$2"
    local title="$3"
    local head="$4"
    local base="$5"
    local url="https://api.github.com/repos/${repo_owner}/${repo_name}/pulls"
    local response
    response=$(curl -s -X POST -H "Accept: application/vnd.github+json" -H "Authorization: Bearer ${GITHUB_TOKEN}" -H "X-GitHub-Api-Version: 2022-11-28" -d "{\"title\":\"$title\",\"head\":\"$head\",\"base\":\"$base\"}" "$url")
    
    # Extract the html_url from the response and get the last segment after the last /
    local pull_number
    pull_number=$(echo "$response" | grep -o '"html_url": *"[^"]*' | grep -o '[^"]*$' | grep -oE '[^/]+$')
    
    echo "$pull_number"
}

get_pull_request_number() {
    local url="$1"
    echo "$url" | awk -F/ '{print $NF}'
}

merge_pull_request() {
    local repo_owner="$1"
    local repo_name="$2"
    local pull_number="$3"
    local commit_title="$4"
    local commit_message="$5"
    
    pull_number=$(echo "$pull_number" | grep -oE '[0-9]+')
    
    local url="https://api.github.com/repos/${repo_owner}/${repo_name}/pulls/${pull_number}/merge"
    local response
    
    response=$(curl -L \
        -X PUT \
        -H "Accept: application/vnd.github+json" \
        -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        -H "X-GitHub-Api-Version: 2022-11-28" \
    -d "{\"commit_title\":\"$commit_title\",\"commit_message\":\"$commit_message\"}" "$url")
    
    echo "$response" | grep -o '"message": *"[^"]*' | grep -o '[^"]*$'
}

commit() {
    local message="$1"
    local date
    date=$(format_date)
    local branch_name
    branch_name=$(echo "$message" | grep -iq "^feat:" && echo "feat-${date}" || echo "fix-${date}")
    
    git checkout -b "$branch_name"
    echo "Checkout: $branch_name"
    
    git add .
    git commit -m "$message"
    echo "Committed: $message"
    
    git push origin "$branch_name"
    echo "Push: $branch_name"
    
    git checkout main
    git merge "$branch_name"
    echo "Merged $branch_name into main locally"
    
    local pull_number
    pull_number=$(create_pull_request "$REPO_OWNER" "$REPO_NAME" "$message" "$branch_name" "main")
    
    merge_pull_request "$REPO_OWNER" "$REPO_NAME" "$pull_number" "$message" "This PR $(echo "$message" | grep -iq "^feat:" && echo "added feature:" || echo "fixes") ($(remove_prefixes "$message"))"
    
    delete_git_ref "$REPO_OWNER" "$REPO_NAME" "heads/${branch_name}"
    echo "Deleted: $branch_name"
    
    git branch -D "$branch_name"
    echo "Deleted local branch $branch_name"
    
    git pull origin main
}

main() {
    if [[ "$1" == "commit" ]]; then
        if [[ -z "$2" ]]; then
            echo "Message to commit is required."
            exit 1
        fi
        commit "$2"
    else
        echo "Usage: $0 commit <message>"
        exit 1
    fi
}

main "$@"
