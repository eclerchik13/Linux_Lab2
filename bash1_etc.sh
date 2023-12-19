#!/bin/bash
if stat -c %a /etc/shadow | grep "640"
then echo "/etc/shadow valid perm=640" > log6_1.txt
else
echo '/etc/shadow with ivalid perm' > log6_1.txt
fi

srdir="/root/.ssh/"

for entry in $(sudo ls $srdir)
do
for file in $(sudo stat -c %a $srdir$entry)
do
if [ \( "$file" == "600" \) -o \( "$file" -eq "640" \) -o \( "$file" -eq "644" \) ]
then echo "file $srdir$entry with $file perm" >> log6_1.txt
else
echo "file $srdir$entry with ivalid perm ($file)" >> log6_1.txt
fi
done
done

for file_with_suid in $(find . -type -f -executable  -perm -u=s)
do
echo "$file_with_suid has suid bit" >> log6_1.txt
done

res=$(sudo cat /etc/ssh/sshd_config | grep -E 'PermitRootLogin yes|PermitEmptyPassword yes')
if ['$res' != '']
then echo "this host has unsage ssdh option" >> log6_1.txt
else
echo "OK" >> log6_1.txt
fi

# пункт 3 pwnkit - проверить версию
res_pwnkit = $(apt-cache policy policykit-1 | grep "18.04.5")
if ['$res_pwnkit' != '']
then echo "this host vulnerable to pwnkit" >> log6_1.txt
fi
# пункт 3 0847 - тоже проверить версию (уяз с 5.8 по 5.15)
res_0847=$(uname -rs | grep -E '5\.8\.|5\.9|5\.1[0-5]')
if ['$res_0847' != '']
then echo "this host vulnerable to cve-2022-0847" >> log6_1.txt
fi
# пункт 3 5195 - тоже версия
res_5195=$(uname -rs | grep -E '2\.6\.3[89]|4\.[0-9]|4\.1[0-4]')
if ['$res_5195' != '']
then echo "this host vulnerable to cve-2016-5195" >> log6_1.txt
fi
