
# Post Feeds of App Reviews

#### setting cron

```bash
export PATH="$HOME/.rbenv/bin:$PATH"

10 10 * * * /bin/bash -c 'eval "$(rbenv init -)"; cd /path/to/; ruby feeds.rb;'
```




