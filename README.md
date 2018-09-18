# dotfiles

Here is how to clone this repository in your non empty home folder. This also works if files already exist (they will be overwritten!!!):

```
cd ~
git init
git remote add origin https://gitlab.com/rickowski/dotfiles.git
git fetch
git checkout -t origin/master -f
```

After that execute the setup script and follow the instructions:
```
./dotfiles-setup.sh
```
