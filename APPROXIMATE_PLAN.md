- `setup_macos.sh`
  - check if AnyBar is installed and throw error if not
  - copy `*.png` icons to `~/.AnyBar`
  - create `~/.config/github-daily-commits` directory and `commits.txt` file with 0
  - set `check_commits.sh` `cronjob` to check `commits.txt` file every 5 minutes
  - set `check_github.js` `cronjob` to check github user page once per `GITHUB_INTERVAL` `env` variable or once per hour as default
