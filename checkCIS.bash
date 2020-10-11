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
export PATH

# *** check start
echo ""
echo -e "========================================="
echo -e "Report of `hostname` `date`              "
echo -e "========================================="
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
		echo -e "Section 1.1.3 to 1.1.5: \c"
		echo "FAIL" | awk '{printf("%50s\n",$1);}'
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
