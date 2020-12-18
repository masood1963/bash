#!/bin/bash
#
# *** purpose
#	perform GIT operation
# *** version
#	v1.1 15-12-2020 property of atfmcloudops@ncs.com.sg
#
# *** General
/usr/bin/umask 022
#
# *** Check command line
if [ $# -ne 1 ]
	then
		echo -e "\n\tUsage: $0 option -c / -p / -P / -h\n"
		exit 1
fi
#
# *** Check user
if [ "${LOGNAME}" != "root" ]
	then
		echo ""
		echo -e "\texiting because this has to be performed by root"
		exit 1
fi
#
# *** Check parent 
if [ -d /data ]
	then
		cd /data
	else
		echo ""
		echo -e "\tGIT parent does not exist. MAJOR PROBLEM"
		exit 1
fi
#
# *** perform work - git config
gitConfig () {
	echo ""
	echo -e "\tyour name: \c"
	read yourName 
	echo -e "\tyour NCS email name@ncs.com.sg: \c"
	read yourEmail
	/usr/bin/git config --global user.name "${yourName}"
	/usr/bin/git config --global user.email "${yourEmail}"
	echo ""
}
#
# *** run function gitConfig
gitConfig 

#
#
echo -e "\tperforming git operation \n"
while getopts "cpPh" cmdline
do
	case $cmdline in
		h) echo ""
			echo -e "\t-h prints help information"
			echo -e "\t-c perform [0;31mCLONE[1;37m"
			echo -e "\t-p perform [0;31mPULL[1;37m"
			echo -e "\t-P perform [0;31mPUSH[1;37m"
			echo ""
			exit 1
			;;
		c) echo ""
			cd /data
			echo -e "\tperforming GIT as ${yourName} ${yourEmail}"
			echo -e "\tperform git CLONE"
			echo ""
			# /usr/bin/git clone https://git-codecommit.ap-southeast-1.amazonaws.com/v1/repos/cc-seab-sxm-uat-infra
			echo ""
			;;
		p) echo ""
			echo -e "\tperforming GIT PULL"
			echo ""
			if [ -d /data/cc-seab-sxm-uat-infra ]
				then
					cd /data/cc-seab-sxm-uat-infra
					/usr/bin/git pull https://git-codecommit.ap-southeast-1.amazonaws.com/v1/repos/cc-seab-sxm-uat-infra
				else
					echo ""
					echo -e "\tMAJOR ISSUE /data/cc-seab-sxm-uat-infra missing"
					echo ""
					exit 1
			fi
			;;
		P) echo ""
			cd /data/cc-seab-sxm-uat-infra
			echo -e "\tdescription of task: \c"
			read myTask
			/usr/bin/git add --all --verbose .
			echo -e "\tcommiting with ${myTask}"
			/usr/bin/git commit -m "${myTask}"
			/usr/bin/git push --all --verbose
			;;
		*) break
			;;
	esac
done
echo -e "\tcomplete "
echo ""
