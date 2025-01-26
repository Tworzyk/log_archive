#!bin/bash

read -p "Write location to archivizate: " location
read -p "How old in days files havet to be?: " how_long
read -p "How long would like you hold tar files ?: " how_last

time=$(date +%Y%m%d_%H%M%S)
file="/var/log/log_archive_${time}"
tarname="${file}/log_archive_${time}"
mkdir -p "$file"

if [[ "$how_long" -eq 0 ]]; then
       tar -czvf "${tarname}.tar.gz" "$location"
else
find "$location" -type f -mtime +$how_long -print0 | tar -czvf "$tarname.tar.gz" "${location}"--null -T -
fi

if [[ "$how_last" -ne 0 ]]; then
        find "$location" -type f -mtime +$how_last -exec rm -r {} \;
fi
echo "Archive created in : ${tarname}.tar.gz"


echo -n "Would you like to enable cron systme ? (You have to earlier install cron): 1. YES. 2.NO "
read  cron

if [[ "$cron" -eq 1 ]]; then

        cron_line="0 2 * * * /usr/local/bin/log_archive.sh"
        (crontab -l 2>/dev/null; echo "$cron_line") | crontab -
        echo "Cron job added : $cron_line"
else
        echo "Cron job not added"
fi
~
