#
#
# *** purpose
#	check CIS Level 1
# *** version
#	1.0 11-10-2020
#	Property of Hanan Inc www.sitihanan.xyz

#
# *** general stuff
umask 022
PATH=/usr/sbin:/sbin:/usr/bin:/bin:/etc:/usr/local/bin:/usr/local/sbin
Rand=`echo $RANDOM`
export PATH

#
# *** check command line
if [ $# -lt 2 ]
	then
		echo ""
		echo "usage: $0 -o out-file"
		echo ""
		exit 1
	else
		:
fi

while getopts "o:" args
do
	case ${args} in
	o) echo ""
		Outfile=${OPTARG}
		;;
	esac
done
# *** check start
echo ""
echo -e "====================================================================="
echo -e "Report of `hostname` `date`."
echo -e "Report ID: ${Outfile}.${Rand} \c"
echo -e "IPv4: `ip addr|grep " inet "|grep -v 127\.|head -1|awk '{print($2)}'`"
echo -e "====================================================================="
echo ""
echo -e "Section 1.1.1.1 to 1.1.1.4 (modprobe): \c"
if [ -d /etc/modprobe.d ]
	then
		cd /etc/modprobe.d
fi
cd /var/tmp

cp /dev/null modprobe.txt
cat << EOF >> modprobe.txt
install cramfs /bin/true
install squashfs /bin/true
install udf /bin/true
install fat /bin/true
install vfat /bin/true
install msdos /bin/true
install usb-storage /bin/true
install dccp /bin/true
install sctp /bin/true
EOF
echo "ENFORCED" | awk '{printf("%39s\n",$1);}'
cp modprobe.txt /etc/modprobe.d/harden.conf
chown root:root /etc/modprobe.d/harden.conf
chmod 444 /etc/modprobe.d/harden.conf

# *** Section 1.1.2 to 1.1.5
echo -e "Section 1.1.2 (/tmp FS): \c"
grep -v "\#" /etc/fstab | grep " \/tmp " 1>/dev/null ; export Tmp1=$?
if [ $Tmp1 -ne 0 ]
	then
		echo "FAIL" | awk '{printf("%49s\n",$1);}' 
	else
		echo "PASS" | awk '{printf("%49s\n",$1);}' 
fi
if [ $Tmp1 -ne 0 ]
	then
		echo -e "Section 1.1.3 to 1.1.5 (/tmp mount-opt): \c"
		echo "FAIL" | awk '{printf("%33s\n",$1);}'
	else
		echo -e "Section 1.1.3 to 1.1.5 (/tmp mount-opt): "
		for Device in noexec nodev nosuid
		do
			grep " \/tmp " /etc/fstab | grep -v "\#" | \
				grep "${Device}" 1>/dev/null ; Tmp2=$?
			if [ $Tmp2 -ne 0 ]
				then
					echo "${Device} FAIL" | \
					awk '{printf("%40s %33s\n",$1,$2);}'
				else
					echo "${Device} PASS" | \
					awk '{printf("%40s %33s\n",$1,$2);}'

			fi
		done
fi


echo -e "Section 1.1.6 (/dev/shm FS):\c"
grep -v "\#" /etc/fstab | grep " \/dev\/shm " 1>/dev/null ; export Shm1=$?
if [ $Shm1 -ne 0 ]
	then
		echo "FAIL" | awk '{printf("%46s\n",$1);}' 
	else
		echo "PASS" | awk '{printf("%46s\n",$1);}' 
fi
if [ $Shm1 -ne 0 ]
	then
		echo -e "Section 1.1.7 to 1.1.9 (/dev/shm mount-opt):\c"
		echo "FAIL" | awk '{printf("%30s\n",$1);}'
	else
		echo -e "Section 1.1.7 to 1.1.9 (/dev/shm mount-opt):"
		for Device in noexec nodev nosuid
		do
			grep " \/tmp " /etc/fstab | grep -v "\#" | \
				grep "${Device}" 1>/dev/null ; Shm2=$?
			if [ $Shm2 -ne 0 ]
				then
					echo "${Device} FAIL" | \
					awk '{printf("%40s %33s\n",$1,$2);}'
				else
					echo "${Device} PASS" | \
					awk '{printf("%40s %33s\n",$1,$2);}'

			fi
		done
fi

echo -e "Section 1.1.10 (/var FS): \c"
grep -v "\#" /etc/fstab | grep " \/var " 1>/dev/null ; export Var1=$?
if [ $Var1 -ne 0 ]
	then
		echo "FAIL" | awk '{printf("%48s\n",$1);}' 
	else
		echo "PASS" | awk '{printf("%48s\n",$1);}' 
fi
echo -e "Section 1.1.11 (/var/tmp FS):\c"
grep -v "\#" /etc/fstab | grep " \/var\/tmp " 1>/dev/null ; export Vart1=$?
if [ $Vart1 -ne 0 ]
	then
		echo "FAIL" | awk '{printf("%45s\n",$1);}' 
	else
		echo "PASS" | awk '{printf("%45s\n",$1);}' 
fi
if [ $Vart1 -ne 0 ]
	then
		echo -e "Section 1.1.12 to 1.1.14 (/var/tmp mount-opt):\c"
		echo "FAIL" | awk '{printf("%28s\n",$1);}'
	else
		echo -e "Section 1.1.12 to 1.1.14 (/var/tmp mount-opt):"
		for Device in noexec nodev nosuid
		do
			grep " \/var\/tmp " /etc/fstab | grep -v "\#" | \
				grep "${Device}" 1>/dev/null ; Shm2=$?
			if [ $Shm2 -ne 0 ]
				then
					echo "${Device} FAIL" | \
					awk '{printf("%40s %33s\n",$1,$2);}'
				else
					echo "${Device} PASS" | \
					awk '{printf("%40s %33s\n",$1,$2);}'

			fi
		done
fi

echo -e "Section 1.1.15 (/var/log FS):\c"
grep -v "\#" /etc/fstab | grep " \/var\/log " 1>/dev/null ; export Varl1=$?
if [ $Varl1 -ne 0 ]
	then
		echo "FAIL" | awk '{printf("%45s\n",$1);}' 
	else
		echo "PASS" | awk '{printf("%45s\n",$1);}' 
fi
echo -e "Section 1.1.16 (/var/log/audit FS):\c"
grep -v "\#" /etc/fstab | grep " \/var\/log\/audit " 1>/dev/null 
export Vara1=$?
if [ $Vara1 -ne 0 ]
	then
		echo "FAIL" | awk '{printf("%39s\n",$1);}' 
	else
		echo "PASS" | awk '{printf("%39s\n",$1);}' 
fi
echo -e "Section 1.1.17 (/home FS):\c"
grep -v "\#" /etc/fstab | grep " \/home " 1>/dev/null 
export Home1=$?
if [ $Home1 -ne 0 ]
	then
		echo "FAIL" | awk '{printf("%48s\n",$1);}' 
	else
		echo "PASS" | awk '{printf("%48s\n",$1);}' 
fi

echo -e "Section 1.1.18 (/home mount-opt):"
grep -v "\#" /etc/fstab | grep " \/home " | grep nodev ; Home2=$?
if [ $Home2 -ne 0 ]
	then
		echo "nodev FAIL" | awk '{printf("%40s %33s\n",$1,$2);}' 
	else
		echo "nodev PASS" | awk '{printf("%40s %33s\n",$1,$2);}' 
fi
echo -e "Section 1.1.19 to 1.1.21 (removable media):\c"
echo "DEFFERED" | awk '{printf("%35s\n",$1);}'

echo -e "Section 1.1.22 (World writable dir):\c"
cp /dev/null /var/tmp/wwd
for i in `df -hT| grep -v tmpfs | grep -v Mount | awk '{printf("%s\n",$7);}'`
do
	find $i -mount -type d -perm -0007 -ls | grep "rwx " 1>>/var/tmp/wwd
done
if [ `wc -c /var/tmp/wwd | awk '{print($1)}'` -gt 1 ]
	then
		echo "FAIL" | awk '{printf("%38s\n",$1);}'
	else
		echo "PASS" | awk '{printf("%38s\n",$1);}'
fi

# See Section 1.1.1.1 to 1.1.1.4 above
echo -e "Section 1.1.23 (autofs):\c"
systemctl disable autofs 1>/dev/null 2>&1
echo "ENFORCED" | awk '{printf("%54s\n",$1);}'

echo -e "Section 1.1.24 (usb-storage):\c"
echo "ENFORCED" | awk '{printf("%49s\n",$1);}'
# See Section 1.1.1.1 to 1.1.1.4 above

echo -e "Section 1.2.1 GPG keys:\c"
echo "DEFFERED" | awk '{printf("%55s\n",$1);}'

echo -e "Section 1.2.2 (patch repo):\c"
if [ -d /etc/yum.repos.d ]
	then
		if [ -f *.repo ]
			then
				echo "PASS" | \
				awk '{printf("%47s\n",$1);}'
			else
				echo "FAIL" | \
				awk '{printf("%47s\n",$1);}'
		fi
	else
		echo "FAIL" | \
		awk '{printf("%s\n",$1);}'
fi

echo -e "Section 1.2.3 (gpgcheck):\c"
if [ -f /etc/yum.conf ]
	then
		grep "gpgcheck=1" /etc/yum.conf 1>/dev/null 2>&1 ; Yum1=$?
		if [ $Yum1 -eq 0 ]
			then
				echo "PASS" | awk '{printf("%s\n",$1);}'	
			else
				echo "FAIL" | awk '{printf("%s\n",$1);}'	
		fi
	else
		echo "FAIL" | awk '{printf("%49s\n",$1);}'	
fi

echo -e "Section 1.2.4 (RHEL registration):\c"
echo "DEFFERED" | awk '{printf("%44s\n",$1);}'

echo -e "Section 1.2.5 (rhnsd):\c"
systemctl disable rhnsd 1>/dev/null 2>&1
echo "ENFORCED" | awk '{printf("%56s\n",$1);}'

echo -e "Section 1.3.1 (sudo):\c"
which sudo 1>/dev/null 2>&1 ; Sudo1=$?
if [ $Sudo1 -eq 0 ]
	then
		echo "PASS" | awk '{printf("%53s\n",$1);}'
	else
		echo "FAIL" | awk '{printf("%53s\n",$1);}'
fi
