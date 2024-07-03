# Pull Request Generator
Generate a Pull request along with commit.

# Installation

Download the `pr.sh` script and add it to your environment variables:

### Windows:
1. Download `pr.sh` and rename to `gpr`.
2. Put it anywhere and ensure you remember directory path you set
3. Add it to your environment variables:
   - Right-click on `This PC` or `Computer` > Properties > Advanced system settings > Environment Variables.
   - Under System Variables, find `Path`, then click `Edit`.
   - Add the path to the directory containing `pr`, then click `OK`.
   - Restart or SignOut your device

### Linux:
1. Download `pr.sh`.
2. Make it executable if necessary:
   ```bash
   chmod +x pr.sh
   ```
3. Add it to your environment variables:
   - Edit your shell configuration file (`~/.bashrc`, `~/.zshrc`, etc.):
     ```bash
     export PATH="$PATH:/path/to/pr.sh/directory"
     ```
   - Source the file to apply changes:
     ```bash
     source ~/.bashrc   # or ~/.zshrc, depending on your shell
     ```

### macOS:
1. Download `pr.sh`.
2. Make it executable if necessary:
   ```bash
   chmod +x pr.sh
   ```
3. Add it to your environment variables:
   - Edit your shell configuration file (`~/.bash_profile`, `~/.zshrc`, etc.):
     ```bash
     export PATH="$PATH:/path/to/pr.sh/directory"
     ```
   - Source the file to apply changes:
     ```bash
     source ~/.bash_profile   # or ~/.zshrc, depending on your shell
     ```

# Setup
- Get your GitHub Access Token (Personal Access Token) from https://github.com/settings/tokens. Select 'Personal Access Token -> Tokens (Classic)' or use the new fine-grained tokens.
- Create a .prconfig file in your working directory, like so:
```bash
GITHUB_TOKEN="" # Personal Access Token you generated before
REPO_OWNER="" # Your username
REPO_NAME="" # Your repo name
```

# Running
```bash
gpr commit "Your commit message here"  // For windows
pr commit "Your commit message here" // For Linux or Mac
```
Note: you can use prefix `feat:`, `fix:`, `chore:`.

**Make sure to add `pr.sh` into `.gitignore`**

# Note
You can modify the code as needed. For example, you can change the naming of the pull request according to your requirements.

# Author
Jerson Carin
