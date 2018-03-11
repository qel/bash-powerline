# bash-powerline-arrow

A fork of [bash-powerline](https://github.com/riobard/bash-powerline) with pretty colors.

![bash-powerline-arrow](https://raw.github.com/qel/bash-powerline-arrow/master/screenshots/liberation-18-standard-colors.png)

(I like it with a salmon-y #cc6644 foreground)

![bash-powerline-arrow](https://raw.github.com/qel/bash-powerline-arrow/master/screenshots/liberation-18-foreground-cc6644.png)


## Features

* Festive blue ribbon behind working directory.
* Always uses $ prompt because there are enough little apples on our Apple things.
* Sexy green chevron behind prompt.
* Turns red and shows errorlevel on error.
* Needs [Powerline patched fonts](https://github.com/powerline/fonts).


## Installation

Save it where you want it and load it in your `~\.bash_profile`. Maybe like this:

```
if [ -f ~/bash-powerline.sh ]; then
  . ~/bash-powerline.sh
fi
```

If you're using iTerm2 make sure that `Preferences` > `Profiles` > `Text` > `Treat ambiguous-width characters as double-width` is unchecked.