# Bazarr

The backup and restore is mostly broken. You cannot upload a backup to restore from, and you cannot restore the .zip when you copy it into the pod. What i had to do was:

1. extract the `.zip`
2. rename the following files, appending `.old`
    1. `/config/config/config.yaml`
    2. `/config/db/bazarr.db`
3. copy the above named files from `/config/backup` to the same locations
4. set the user/group.  in this case it was `abc:users`
5. restart Bazarr
6. cleanup the `.old` files