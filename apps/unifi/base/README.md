# Unifi

needs fleshing out

## git crypt creation:

```shell
git-crypt init
git-crypt export-key ../git-crypt-key
```

## git crypt working flow:

1.  `git pull origin master`
2.  `git-crypt unlock /home/drake/Documents/git_crypt_keys/gatus.gpg`
3.  do work
4.  `git add *.*`
    - and/or `git add .*` for .dotfiles
5.  `git commit -m "<commit message>"`
6.  `git-crypt lock`
7.  `git push origin master`
