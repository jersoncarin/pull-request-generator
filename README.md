# Pull Request Generator
Generate a Pull request along with commit.

# Setup
- Get your GitHub Access Token (Personal Access Token) from https://github.com/settings/tokens. Select 'Personal Access Token -> Tokens (Classic)' or use the new fine-grained tokens.
- Download the pr.sh from the file and open it and modify the following:
```bash
GITHUB_TOKEN="" # Personal Access Token you generated before
REPO_OWNER="" # Your username
REPO_NAME="" # Your repo name
```

# Running
```bash
./pr.sh commit "Your commit message here"
```
Note: you can use prefix `feat:`, `fix:`, `chore:`

# Note
You can modify the code as needed. For example, you can change the naming of the pull request according to your requirements.

# Author
Jerson Carin
