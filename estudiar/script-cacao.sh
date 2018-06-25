#!/bin/bash
#
#######################################################################
# CACAO NO HACE NINGUNA REPRESENTACIÓN DE GARANTÍAS SOBRE LOS DERECHOS
# DEL SOFTWARE, YA SEAN EXPRESAS O IMPLÍCITAS, INCLUYENDO PERO NO
# LIMITADO A LAS GARANTÍAS IMPLÍCITAS DE COMERCIALIZACIÓN, PARA UN
# PROPÓSITO PARTICULAR. CACAO NO SE HACE RESPONSABLE DE LOS DAÑOS
# SUFRIDOS POR EL LICENCIATARIO COMO CONSECUENCIA DEL USO, MODIFICACIÓN
# O DISTRIBUCIÓN DE ESTE SOFTWARE O SUS DERIVADOS.
#######################################################################
#
#===================================================================
#                           script-lx
#                       Version 20121127
#
#                       Realizado por:
#                        Alberto Grespan
#               (alberto.grespan@cacaoenbytes.com)
#                 (dario.leon@cacaoenbytes.com)
#                  CACAO Servicios Tecnologicos
#
#
#===================================================================
# Este Script recoge (lee) información sobre sistemas linux. El script
# NO es Intrusivo, es decir NO afecta ni cambia ninguna configuración
# del Equipo donde se ejecute. La salida del script se encuentra en el
# directorio y con un nombre de archivo /tmp/<hostname>_<time>.tar.gz
#===================================================================
#
# Constants declaration.
TMPDIR="/tmp"
OUTDIR=$("hostname")-$(date +%Y%m%d)
NOTFOUNDLOG="/tmp/notfound.log"
PROCVERSION="/proc/version"
HTMLVIEW=$("hostname")-$(date +%Y%m%d).txt
HTMLVIEWFINAL=$("hostname")-$(date +%Y%m%d%S).html

# Checks if the working environment is linux and the user is root
#
# returns none

# This function will initialize the commands that will be used in the script.
#
# it returns the location of the command and if it doesn't exist it will write
# the error in the NOTFOUNDLOG
function InitCmds {

  APTCONFIG=$(which apt-config 2> $NOTFOUNDLOG)
  AWK=$(which awk 2>> $NOTFOUNDLOG)
  BASENAME=$(which basename 2>> $NOTFOUNDLOG)
  CAT=$(which cat 2>> $NOTFOUNDLOG)
  CHKCONFIG=$(which chkconfig 2>> $NOTFOUNDLOG)
  CP=$(which cp 2>> $NOTFOUNDLOG)
  CUT=$(which cut 2>> $NOTFOUNDLOG)
  DATE=$(which date 2>> $NOTFOUNDLOG)
  DEBUGREISERFS=$(which debugreiserfs 2>> $NOTFOUNDLOG)
  DF=$(which df 2>> $NOTFOUNDLOG)
  DMESG=$(which dmesg 2>> $NOTFOUNDLOG)
  DMIDECODE=$(which dmidecode 2>> $NOTFOUNDLOG)
  DPKG=$(which dpkg 2>> $NOTFOUNDLOG)
  DUMPE2FS=$(which dumpe2fs 2>> $NOTFOUNDLOG)
  ECHO=$(which echo 2>> $NOTFOUNDLOG)
  EMERGE=$(which emerge 2>> $NOTFOUNDLOG)
  EGREP=$(which egrep 2>> $NOTFOUNDLOG)
  FDISK=$(which fdisk 2>> $NOTFOUNDLOG)
  FILE=$(which file 2>> $NOTFOUNDLOG)
  FIND=$(which find 2>> $NOTFOUNDLOG)
  FREE=$(which free 2>> $NOTFOUNDLOG)
  GREP=$(which grep 2>> $NOTFOUNDLOG)
  GZIP=$(which gzip 2>> $NOTFOUNDLOG)
  HDPARM=$(which hdparm 2>> $NOTFOUNDLOG)
  HOSTNAME=$(which hostname 2>> $NOTFOUNDLOG)
  HWINFO=$(which hwinfo 2>> $NOTFOUNDLOG)
  IFCONFIG=$(which ifconfig 2>> $NOTFOUNDLOG)
  IOSTAT=$(which iostat 2>> $NOTFOUNDLOG)
  IPCS=$(which ipcs 2>> $NOTFOUNDLOG)
  IPVSADM=$(which ipvsadm 2>> $NOTFOUNDLOG)
  IWCONFIG=$(which iwconfig 2>> $NOTFOUNDLOG)
  LOCALE=$(which locale 2>> $NOTFOUNDLOG)
  LPQ=$(which lpq 2>> $NOTFOUNDLOG)
  LSMOD=$(which lsmod 2>> $NOTFOUNDLOG)
  LSPCI=$(which lspci 2>> $NOTFOUNDLOG)
  LSPNP=$(which lspnp 2>> $NOTFOUNDLOG)
  LS=$(which ls 2>> $NOTFOUNDLOG)
  LVDISPLAY=$(which lvdisplay 2>> $NOTFOUNDLOG)
  MKDIR=$(which mkdir 2>> $NOTFOUNDLOG)
  MODPROBE=$(which modprobe 2>> $NOTFOUNDLOG)
  MOUNT=$(which mount 2>> $NOTFOUNDLOG)
  MV=$(which mv 2>> $NOTFOUNDLOG)
  NETSTAT=$(which netstat 2>> $NOTFOUNDLOG)
  NFSSTAT=$(which nfsstat 2>> $NOTFOUNDLOG)
  PSTREE=$(which pstree 2>> $NOTFOUNDLOG)
  PS=$(which ps 2>> $NOTFOUNDLOG)
  RM=$(which rm 2>> $NOTFOUNDLOG)
  ROUTE=$(which route 2>> $NOTFOUNDLOG)
  RPM=$(which rpm 2>> $NOTFOUNDLOG)
  SLEEP=$(which sleep 2>> $NOTFOUNDLOG)
  SORT=$(which sort 2>> $NOTFOUNDLOG)
  SYSCTL=$(which sysctl 2>> $NOTFOUNDLOG)
  TAIL=$(which tail 2>> $NOTFOUNDLOG)
  TAR=$(which tar 2>> $NOTFOUNDLOG)
  TOP=$(which top 2>> $NOTFOUNDLOG)
  UNAME=$(which uname 2>> $NOTFOUNDLOG)
  UPTIME=$(which uptime 2>> $NOTFOUNDLOG)
  VGDISPLAY=$(which vgdisplay 2>> $NOTFOUNDLOG)
  VGSCAN=$(which vgscan 2>> $NOTFOUNDLOG)
  VMSTAT=$(which vmstat 2>> $NOTFOUNDLOG)
  XVINFO=$(which xvinfo 2>> $NOTFOUNDLOG)
  ZIP=$(which zip 2>> $NOTFOUNDLOG)
  OPENVPN=$(which openvpn 2>> $NOTFOUNDLOG)
  IPTABLESSAVE=$(which iptables-save 2>> $NOTFOUNDLOG)
  IP6TABLESSAVE=$(which ip6tables-save 2>> $NOTFOUNDLOG)
  NMAP=$(which nmap 2>> $NOTFOUNDLOG)
  SHOWMOUNT=$(which showmount 2>> $NOTFOUNDLOG)
  RPCINFO=$(which rpcinfo 2>> $NOTFOUNDLOG)
  FINGER=$(which finger 2>> $NOTFOUNDLOG)
  WHO=$(which who 2>> $NOTFOUNDLOG)
  W=$(which w 2>> $NOTFOUNDLOG)
  RUSERS=$(which rusers 2>> $NOTFOUNDLOG)

}

# Checks if the target command exists
#
# credit to Kim Willgren for this function.
function IfExists {
  $ECHO "$*" | $AWK '{
    z=split($0, tmparr, "/")
    # --------------------------------------------------------
    # if command initialized by 'which' in function doInit
    # was not found, and no arguments were passed, content of
    # tmparr[z] will be null.
    #
    # If argument was passed, the first character of content
    # is a hyphen.
    #
    # Both indicate a "not found" condition and IfExists will
    # assign NOTFOUND to the return value
    # --------------------------------------------------------
    if ( (tmparr[z] != "") && (substr(tmparr[z],1,1) !~ "-") ) {
      print tmparr[z]
      exit
    } else {
        print "NOTFOUND"
      exit
    }
  }'
}

# Checks if cat command exists if not it will exit the script with
# value = 1
#
function ifCatExists {

  if [[ -f !$CAT ]]; then
    exit 1
  fi

}

function timer {
  $SLEEP 5
}


# Creates or cleans the working directory for the script to work
# The function generates all the folders.
#
function Creating {

  if [[ -f $MKDIR ]]; then
    if [[ -d $TMPDIR/$OUTDIR ]]; then
      $ECHO "The directory target already exists, clearing it"
      rm -rf $TMPDIR/$OUTDIR/*
      $MKDIR -p $TMPDIR/$OUTDIR/Logs/
      $MKDIR -p $TMPDIR/$OUTDIR/LogicConfiguration/setuid
      $MKDIR -p $TMPDIR/$OUTDIR/LogicConfiguration/setgid
      $MKDIR -p $TMPDIR/$OUTDIR/NetworkServices/ssh
      $MKDIR -p $TMPDIR/$OUTDIR/LogicConfiguration/passwrd
      $MKDIR -p $TMPDIR/$OUTDIR/LogicConfiguration/group
      $MKDIR -p $TMPDIR/$OUTDIR/NetworkConfiguration/netstat
      $MKDIR -p $TMPDIR/$OUTDIR/LogicConfiguration/sudoers
      $MKDIR -p $TMPDIR/$OUTDIR/Firewall/iptables
      $MKDIR -p $TMPDIR/$OUTDIR/NetworkConfiguration/services
      $MKDIR -p $TMPDIR/$OUTDIR/NetworkServices/nfs
      $MKDIR -p $TMPDIR/$OUTDIR/NetworkServices/snmp
      $MKDIR -p $TMPDIR/$OUTDIR/NetworkConfiguration/connectionparams
      $MKDIR -p $TMPDIR/$OUTDIR/Applications
      $MKDIR -p $TMPDIR/$OUTDIR/Users
      $MKDIR -p $TMPDIR/$OUTDIR/Hostname
    else
      $ECHO "Creating $TMPDIR/$OUTDIR"
      $MKDIR -p $TMPDIR/$OUTDIR/Logs/
      $MKDIR -p $TMPDIR/$OUTDIR/LogicConfiguration/setuid
      $MKDIR -p $TMPDIR/$OUTDIR/LogicConfiguration/setgid
      $MKDIR -p $TMPDIR/$OUTDIR/NetworkServices/ssh
      $MKDIR -p $TMPDIR/$OUTDIR/LogicConfiguration/passwrd
      $MKDIR -p $TMPDIR/$OUTDIR/LogicConfiguration/group
      $MKDIR -p $TMPDIR/$OUTDIR/NetworkConfiguration/netstat
      $MKDIR -p $TMPDIR/$OUTDIR/LogicConfiguration/sudoers
      $MKDIR -p $TMPDIR/$OUTDIR/Firewall/iptables
      $MKDIR -p $TMPDIR/$OUTDIR/NetworkConfiguration/services
      $MKDIR -p $TMPDIR/$OUTDIR/NetworkServices/nfs
      $MKDIR -p $TMPDIR/$OUTDIR/NetworkServices/snmp
      $MKDIR -p $TMPDIR/$OUTDIR/NetworkConfiguration/connectionparams
      $MKDIR -p $TMPDIR/$OUTDIR/Applications
      $MKDIR -p $TMPDIR/$OUTDIR/Users
      $MKDIR -p $TMPDIR/$OUTDIR/Hostname
    fi
  else
    $ECHO "Couldn't create the working directory mkdir not found"
    exit 1
  fi
}

# The Logger function extracts the complete /var/log folder
#
# The output from this method is saved in $TMPDIR/$OUTDIR/logs in a tar.gz form
function Logger {

  $ECHO "Copying /var/log to $TMPDIR/$OUTDIR/Logs"
  timer

  VARLOG="/var/log"
  FILENAME=$("hostname")_log.tar.gz

  cd $TMPDIR/$OUTDIR/Logs/

  $TAR cvzf $FILENAME $VARLOG > /dev/null 2>&1
  if [[ -f $FILENAME ]]; then
    $ECHO "Writing file $TMPDIR/$OUTDIR/Logs"
    $CP -p $FILENAME $TMPDIR/$OUTDIR/Logs
    $TAR xvf $FILENAME > /dev/null 2>&1
    $RM -r $FILENAME
  else
    $ECHO "Error copying the logs to $TMPDIR/$OUTDIR/Logs" >> $TMPDIR/$OUTDIR/Logs/log.txt > /dev/null
  fi

  cd $TMPDIR

}

# Finding files with bit enabled setuid & setgid
#
# The output from this function is saved in $TMPDIR/$OUTDIR/LogicConfiguration/ folder.
function Setids {

  $ECHO "Finding all files with setuids and setgids bit"
  timer

  if [[ -f $FIND ]]; then
    if [[ -d $TMPDIR/$OUTDIR/LogicConfiguration/setuid ]]; then
      $ECHO "Writing file $TMPDIR/$OUTDIR/LogicConfiguration/setuids/setuids.txt"
      CMD1=$($FIND / \( -perm -4000 \) -print 2> /dev/null >> $TMPDIR/$OUTDIR/LogicConfiguration/setuid/setuid.txt)
      $ECHO "<h2>setuid</h2>" >> $TMPDIR/$HTMLVIEW
      CMD1=$($FIND / \( -perm -4000 \) -print 2> /dev/null >> $TMPDIR/$HTMLVIEW)
    else
      $ECHO "Error copying setuids to $TMPDIR/$OUTDIR/LogicConfiguration/setuid" >> $TMPDIR/$OUTDIR/LogicConfiguration/setuid/setuid.txt
    fi
    if [[ -d $TMPDIR/$OUTDIR/LogicConfiguration/setgid ]]; then
      $ECHO "Writing file $TMPDIR/$OUTDIR/LogicConfiguration/setgid/setgid.txt"
      CMD2=$($FIND / \( -perm -2000 \) -print 2> /dev/null >> $TMPDIR/$OUTDIR/LogicConfiguration/setgid/setgid.txt)
      $ECHO "<h2>setgid</h2>" >> $TMPDIR/$HTMLVIEW
      CMD2=$($FIND / \( -perm -2000 \) -print 2> /dev/null >> $TMPDIR/$HTMLVIEW)
    else
      $ECHO "Error copying setuids to $TMPDIR/$OUTDIR/LogicConfiguration/setgid" >> $TMPDIR/$OUTDIR/LogicConfiguration/setgid/setgid.txt
    fi
  else
    $ECHO "Error Setids function could was not used because it could not find $FIND"
  fi

}

# This function writes network and interface statistics it uses netstat, route
# and ifconfig packages to extract the information.
#
# The output for Netstats function is saved in $TMPDIR/$OUTDIR/NetworkConfiguration/netstat
function Netstats {

  $ECHO "Running netstat to analyze computer network and routing table"
  timer

  for d in \
    "$ROUTE -n" \
    "$NETSTAT -i" "$NETSTAT -t" "$NETSTAT -s" "$NETSTAT -rn" "$NETSTAT -lpe" "$NETSTAT -ape" \
    "$IFCONFIG -a"
  do
    CMD=$($ECHO $d | $AWK '{ z=split($0, tmparr, "/"); print tmparr[z] }')
    OUTFILE=$($ECHO $CMD | $AWK '{ gsub(/ /, ""); print $0}')
    $ECHO "Writing file $TMPDIR/$OUTDIR/NetworkConfiguration/netstat/$OUTFILE"
    $CMD > $TMPDIR/$OUTDIR/NetworkConfiguration/netstat/$OUTFILE 2> /dev/null
    $ECHO "<h2>$OUTFILE</h2>" >> $TMPDIR/$HTMLVIEW
    $CMD >> $TMPDIR/$HTMLVIEW 2> /dev/null
  done

}

# Traerse sshd_conf y ssh_conf
#
# returns none
function SShcfg {

  $ECHO "Copying ssh configuration files"
  timer

  SSHFILE="/etc/ssh"


  if [[ -d $SSHFILE ]]; then
    if [[ -r $SSHFILE/ssh_config ]]; then
      $ECHO "Writing file $TMPDIR/$OUTDIR/NetworkServices/ssh/ssh_conf.txt"
      $CAT $SSHFILE/ssh_config >> $TMPDIR/$OUTDIR/NetworkServices/ssh/ssh_conf.txt 2> /dev/null
      $ECHO "<h2>ssh_conf</h2>" >> $TMPDIR/$HTMLVIEW
      $CAT $SSHFILE/ssh_config >> $TMPDIR/$HTMLVIEW 2> /dev/null
    else
      $ECHO "Error reading $SSHFILE/ssh_conf" >> $TMPDIR/$OUTDIR/NetworkServices/ssh/ssh_conf.txt
    fi
    if [[ -r $SSHFILE/sshd_config ]]; then
      $ECHO "Writing file $TMPDIR/$OUTDIR/NetworkServices/ssh/sshd_conf.txt"
      $CAT $SSHFILE/sshd_config >> $TMPDIR/$OUTDIR/NetworkServices/ssh/sshd_conf.txt 2> /dev/null
      $ECHO "<h2>sshd_conf</h2>" >> $TMPDIR/$HTMLVIEW
      $CAT $SSHFILE/sshd_config >> $TMPDIR/$HTMLVIEW 2> /dev/null
    else
      $ECHO "Error reading $SSHFILE/sshd_conf" >> $TMPDIR/$OUTDIR/NetworkServices/ssh/sshd_conf.txt
    fi
  else
    $ECHO "Error reaching $SSHFILE it doesn't exists" >> $TMPDIR/$OUTDIR/NetworkServices/ssh/ssh_conf.txt
  fi

}

# The function PasswdFile, extracts the information out of passwd file.
#
# The output from PasswdFile function is saved in $TMPDIR/$OUTDIR/LogicConfiguration/passwrd
function PasswdFile {

  $ECHO "Copying passwd file"
  timer

  PASSWDFILE="/etc"

  if [[ -d $PASSWDFILE ]]; then
    if [[ -r $PASSWDFILE/passwd ]]; then
      $ECHO "Writing file $TMPDIR/$OUTDIR/LogicConfiguration/passwrd/passwd.txt"
      $CAT $PASSWDFILE/passwd >> $TMPDIR/$OUTDIR/LogicConfiguration/passwrd/passwd.txt 2> /dev/null
      $ECHO "<h2>passwd_file</h2>" >> $TMPDIR/$HTMLVIEW
      $CAT $PASSWDFILE/passwd >> $TMPDIR/$HTMLVIEW 2> /dev/null
    else
      $ECHO "Error reading $PASSWDFILE/passwd" >> $TMPDIR/$OUTDIR/LogicConfiguration/passwrd/passwd.txt
    fi
  else
    $ECHO "Error reaching $PASSWDFILE it doesn't exists" >> $TMPDIR/$OUTDIR/LogicConfiguration/passwrd/passwd.txt
  fi

}

# The function SudoersFile, extracts the information out of sudoers file.
#
# The output from SudoersFile function is saved in $TMPDIR/$OUTDIR/LogicConfiguration/sudoers
function SudoersFile {

  $ECHO "Copying sudoers file"
  timer

  SUDOERSF="/etc/sudoers"

  if [[ -e $SUDOERSF ]]; then
    if [[ -r $SUDOERSF ]]; then
      $ECHO "Writing file $TMPDIR/$OUTDIR/LogicConfiguration/sudoers/sudoers.txt"
      $CAT $SUDOERSF >> $TMPDIR/$OUTDIR/LogicConfiguration/sudoers/sudoers.txt 2> /dev/null
      $ECHO "<h2>sudoers_file</h2>" >> $TMPDIR/$HTMLVIEW
      $CAT $SUDOERSF >> $TMPDIR/$HTMLVIEW 2> /dev/null
    else
      $ECHO "Can't read $SUDOERSF file " >> $TMPDIR/$OUTDIR/LogicConfiguration/sudoers/sudoers.txt
    fi
  else
    $ECHO " The file $SUDOERSF doesn't exist" >> $TMPDIR/$OUTDIR/LogicConfiguration/sudoers/sudoers.txt
  fi

}

# Looks out for iptables-save command and redirects the output to a file
# Looks out for ip6tables-save command and redirects the output to a file
#
# The output from IptablesFiles function is saved in $TMPDIR/$OUTDIR/Firewall/iptables
function  IptablesFiles {

  $ECHO "Copying iptables rules file"
  timer

  # ipv4
  if [[ -f $IPTABLESSAVE ]]; then
    $ECHO "Writing file $TMPDIR/$OUTDIR/Firewall/iptables/iptables-rules.txt"
    $IPTABLESSAVE >> $TMPDIR/$OUTDIR/Firewall/iptables/iptables-rules.txt 2> /dev/null
    $ECHO "<h2>iptables_ipv4</h2>" >> $TMPDIR/$HTMLVIEW
    $IPTABLESSAVE >> $TMPDIR/$HTMLVIEW 2> /dev/null
  else
    $ECHO " iptables command not found " >> $TMPDIR/$OUTDIR/Firewall/iptables/iptables-rules.txt 2> /dev/null
  fi

  # ipv6
  if [[ -f $IP6TABLESSAVE ]]; then
    $ECHO "Writing file $TMPDIR/$OUTDIR/Firewall/iptables/ip6tables-rules.txt"
    $$IP6TABLESSAVE >> $TMPDIR/$OUTDIR/Firewall/iptables/ip6tables-rules.txt 2> /dev/null
    $ECHO "<h2>iptables_ipv6</h2>" >> $TMPDIR/$HTMLVIEW
    $IP6TABLESSAVE >> $TMPDIR/$HTMLVIEW 2> /dev/null
  else
    $ECHO " ip6tables command not found " >> $TMPDIR/$OUTDIR/Firewall/iptables/ip6tables-rules.txt 2> /dev/null
  fi

}

# UfwStatus function will look for ufw command to know the status of the firewall
# on the machine, and the rules that it have.
#
# The output from UfwStatus function is saved in $TMPDIR/$OUTDIR/Firewall/ufw
function UfwStatus {

  $ECHO "Searching for ufw"
  timer

  UFW=$(which ufw 2>> $NOTFOUNDLOG)

  if [[ -f $UFW ]]; then
    $MKDIR -p $TMPDIR/$OUTDIR/Firewall/ufw
    $ECHO "Writing file $TMPDIR/$OUTDIR/Firewall/ufw/ufwstatus.txt"
    $UFW status >> $TMPDIR/$OUTDIR/Firewall/ufw/ufwstatus.txt 2> /dev/null
    $ECHO "<h2>ufw_status</h2>" >> $TMPDIR/$HTMLVIEW
    $UFW status >> $TMPDIR/$HTMLVIEW 2> /dev/null
  else
    $MKDIR -p $TMPDIR/$OUTDIR/Firewall/ufw
    $ECHO " Uncomplicated Firewall (ufw) doesn't exist " >> $TMPDIR/$OUTDIR/Firewall/ufw/ufwstatus.txt 2> /dev/null
  fi

}

# The Services function will copy the /etc/services file with the file permissions
#
# The output from Services function is saved in $TMPDIR/$OUTDIR/NetworkConfiguration/services
function Services {

  $ECHO "Copying $SERVICESFILE file"
  timer

  SERVICESFILE="/etc/services"

  if [[ -e $SERVICESFILE ]]; then
    if [[ -r $SERVICESFILE ]]; then
      $ECHO "Writing file $TMPDIR/$OUTDIR/NetworkConfiguration/services/services.txt"
      $ECHO '--------- file permissions ---------' >> $TMPDIR/$OUTDIR/NetworkConfiguration/services/services.txt
      $LS -l $SERVICESFILE >> $TMPDIR/$OUTDIR/NetworkConfiguration/services/services.txt 2> /dev/null
      $ECHO "<h2>file_permissions</h2>" >> $TMPDIR/$HTMLVIEW
      $LS -l $SERVICESFILE >> $TMPDIR/$HTMLVIEW 2> /dev/null
      $ECHO '--------- available services ---------' >> $TMPDIR/$OUTDIR/NetworkConfiguration/services/services.txt
      $CAT $SERVICESFILE >> $TMPDIR/$OUTDIR/NetworkConfiguration/services/services.txt 2> /dev/null
      $ECHO "<h2>available_services</h2>" >> $TMPDIR/$HTMLVIEW
      $CAT $SERVICESFILE >> $TMPDIR/$HTMLVIEW 2> /dev/null
    else
      $ECHO "the file $SERVICESFILE is not readable" >> $TMPDIR/$OUTDIR/NetworkConfiguration/services/services.txt 2> /dev/null
    fi
  else
    $ECHO "the file $SERVICESFILE doesn't exist " >> $TMPDIR/$OUTDIR/NetworkConfiguration/services/services.txt 2> /dev/null
  fi

}

# Checks if nfsstat is installed and runs a nfsstat -v, to extract all the
# information.
#
# The output from Nfsconf function is saved in $TMPDIR/$OUTDIR/NetworkServices/nfs
function Nfsconf {

  $ECHO "Searching for nfs configuration"
  timer

  for d in \
  "$NFSSTAT -v"
  do
    CMD=$(IfExists $d)
    if [[ $CMD != "NOTFOUND" && $CMD != "" ]]; then
      $ECHO "Writing file $TMPDIR/$OUTDIR/NetworkServices/nfs/nfsall.txt"
      $CMD >> $TMPDIR/$OUTDIR/NetworkServices/nfs/nfsall.txt 2> /dev/null
      $ECHO "<h2>$CMD</h2>" >> $TMPDIR/$HTMLVIEW
      $CMD >> $TMPDIR/$HTMLVIEW 2> /dev/null
    else
      $ECHO " $CMD $d doesn't exist " >> $TMPDIR/$OUTDIR/NetworkServices/nfs/nfsall.txt 2> /dev/null
    fi
  done

}

# ConnectionParams function extracts the hosts files (hosts.allow, .deny and .equiv)
#
# The output from connectionparams function is saved in $TMPDIR/$OUTDIR/NetworkConfiguration/connectionparams
function ConnectionParams {

  $ECHO "Retrieving connection params (hosts.allow and hosts.deny)"
  timer

  HALLOW="/etc/hosts.allow"
  HDENY="/etc/hosts.deny"

  if [[ -e $HALLOW && -e $HDENY ]]; then
    if [[ -r $HALLOW && -r $HDENY ]]; then
      $ECHO "Writing file $TMPDIR/$OUTDIR/NetworkConfiguration/connectionparams/connectionparams.txt"
      $CAT $HALLOW >> $TMPDIR/$OUTDIR/NetworkConfiguration/connectionparams/connectionparams.txt 2> /dev/null
      $CAT $HDENY >> $TMPDIR/$OUTDIR/NetworkConfiguration/connectionparams/connectionparams.txt 2> /dev/null
      $ECHO "<h2>connectionparams</h2>" >> $TMPDIR/$HTMLVIEW
      $CAT $HALLOW >> $TMPDIR/$HTMLVIEW 2> /dev/null
      $CAT $HDENY >> $TMPDIR/$HTMLVIEW 2> /dev/null
    else
      $ECHO "files not readable"
    fi
  else
    $ECHO "$HALLOW or $HDENY doesn't exist" >> $TMPDIR/$OUTDIR/NetworkConfiguration/connectionparams/connectionparams.txt 2> /dev/null
  fi

}

# The EtcFiles function extract lots of information from the /etc folder
#
# The output from EtcFiles function is saved in $TMPDIR/$OUTDIR/etc
function EtcFiles {

  $ECHO "Copying inetd.conf, xinetd, cups, mail, cron"
  timer

  INETD="/etc/inetd.conf"

  if [[ -e $INETD ]]; then
    $MKDIR -p $TMPDIR/$OUTDIR/NetworkConfiguration/inetd
    $ECHO "Writing file $TMPDIR/$OUTDIR/NetworkConfiguration/inetd/inetdcfg.txt"
    $CAT $INETD >> $TMPDIR/$OUTDIR/NetworkConfiguration/inetd/inetdcfg.txt 2> /dev/null
    $ECHO "<h2>inet.d</h2>" >> $TMPDIR/$HTMLVIEW
    $CAT $INETD >> $TMPDIR/$HTMLVIEW 2> /dev/null
  else
    $MKDIR -p $TMPDIR/$OUTDIR/NetworkConfiguration/inetd
    $ECHO "inetd file doesn't exist" >> $TMPDIR/$OUTDIR/NetworkConfiguration/inetd/inetdcfg.txt 2> /dev/null
  fi

  for d in \
  /etc/xinetd.d \
  /etc/cups \
  /etc/mail \
  /etc/cron.daily \
  /etc/cron.hourly \
  /etc/cron.monthly \
  /etc/cron.weekly
  do
    if [[ -d $d ]]; then
      if  [[ $($LS -l  $d) != "total 0" ]]; then
        TGTDIR=$($ECHO $d | $AWK '{ z=split($0, tmparr, "/"); print tmparr[z] }')
        $MKDIR -p $TMPDIR/$OUTDIR/Applications/$TGTDIR
        cd $d
        $ECHO "Writing dir  $TMPDIR/$OUTDIR/Applications/$TGTDIR"
        cp -pR ./* $TMPDIR/$OUTDIR/Applications/$TGTDIR/ 2> /dev/null
      else
        TGTDIR=$($ECHO $d | $AWK '{ z=split($0, tmparr, "/"); print tmparr[z] }')
        $MKDIR -p $TMPDIR/$OUTDIR/Applications/$TGTDIR$d
        $ECHO "the directory $d is empty" >> $TMPDIR/$OUTDIR/Applications/$TGTDIR$d.txt 2> /dev/null
      fi
    fi
  done

}

# Apachecfg function will look for the apache or httpd configuration file and
# extract that information if apache or httpd is installed.
#
# The output from Apachecfg function is saved in $TMPDIR/$OUTDIR/WebServer/apache
function Apachecfg {

  $ECHO "Searching and copying apache configuration"
  timer

  APACHDEB="/etc/apache2/apache2.conf"
  APACHERPM="/etc/httpd/conf/httpd.conf"

  if [[ -e $APACHDEB ]]; then
    $MKDIR -p $TMPDIR/$OUTDIR/WebServer/apache
    $ECHO "Writing file $TMPDIR/$OUTDIR/WebServer/apache/apacheconf.txt"
    $CAT $APACHDEB >>  $TMPDIR/$OUTDIR/WebServer/apache/apacheconf.txt 2> /dev/null
    $ECHO "<h2>Apachecfg</h2>" >> $TMPDIR/$HTMLVIEW
    $CAT $APACHDEB >> $TMPDIR/$HTMLVIEW 2> /dev/null
  else
    $MKDIR -p $TMPDIR/$OUTDIR/WebServer/apache
    $ECHO "$APACHDEB file doesn't exist " >> $TMPDIR/$OUTDIR/WebServer/apache/apacheconf.txt 2> /dev/null
  fi

  if [[ -e $APACHERPM ]]; then
    $MKDIR -p $TMPDIR/$OUTDIR/WebServer/httpd
    $ECHO "Writing file $TMPDIR/$OUTDIR/WebServer/httpd/httpdconf.txt"
    $CAT $APACHERPM >>  $TMPDIR/$OUTDIR/WebServer/httpd/httpdconf.txt 2> /dev/null
    $ECHO "<h2>Httpdcfg</h2>" >> $TMPDIR/$HTMLVIEW
    $CAT $APACHERPM >> $TMPDIR/$HTMLVIEW 2> /dev/null
  else
    $MKDIR -p $TMPDIR/$OUTDIR/WebServer/httpd
    $ECHO "$APACHERPM file doesn't exist " >> $TMPDIR/$OUTDIR/WebServer/httpd/httpdconf.txt 2> /dev/null
  fi

}

# Nfsavailable will run an amount of commands to know if nfs services is installed
# and running
#
# The output from Nfsavailable function is saved in $TMPDIR/$OUTDIR/NetworkServices/nfs
function Nfsavailable {

  $ECHO "Searching for nfs status if available"
  timer

  RPC="/etc/rpc"

  if [[ -e $RPC ]]; then
    $ECHO "Writing file $TMPDIR/$OUTDIR/NetworkServices/nfs/Nfsavailable.txt"
    $ECHO "-------- writing cat $RPC --------">> $TMPDIR/$OUTDIR/NetworkServices/nfs/Nfsavailable.txt 2> /dev/null
    $CAT $RPC >> $TMPDIR/$OUTDIR/NetworkServices/nfs/Nfsavailable.txt 2> /dev/null
    $ECHO "<h2>RPC</h2>" >> $TMPDIR/$HTMLVIEW
    $CAT $RPC >> $TMPDIR/$HTMLVIEW 2> /dev/null
  else
    $ECHO "$RPC file doesn't exist " >> $TMPDIR/$OUTDIR/NetworkServices/nfs/Nfsavailable.txt 2> /dev/null
  fi

  for d in \
  "$SHOWMOUNT -e localhost" \
  "`$MOUNT | $EGREP nfs`" \
  "$RPCINFO -p"
  do
    if [[ "$d" != "" && $($ECHO $d | $CUT -c1) != " " ]]; then
      CMD=$(IfExists $d)
      if [[ $CMD != "NOTFOUND" && $CMD != "" ]]; then
        $ECHO "-------- writing $CMD ---------">> $TMPDIR/$OUTDIR/NetworkServices/nfs/Nfsavailable.txt 2> /dev/null
        $CMD >> $TMPDIR/$OUTDIR/NetworkServices/nfs/Nfsavailable.txt 2> /dev/null
        $ECHO "<h2>$CMD</h2>" >> $TMPDIR/$HTMLVIEW
        $CMD >> $TMPDIR/$HTMLVIEW 2> /dev/null
      else
        $ECHO " $CMD $d doesn't exist " >> $TMPDIR/$OUTDIR/NetworkServices/nfs/Nfsavailable.txt 2> /dev/null
      fi
    fi
  done

}

# Findrhosts function will look for the existence of an .rhost file in the
# machine and copy it's information (if exists)
#
# The output from Findrhosts function is saved in $TMPDIR/$OUTDIR/NetworkConfiguration/rhosts
function Findrhosts {

  $ECHO "Searching for .rhost or hosts.equiv"
  timer

  HEQUIV="/etc/hosts.equiv"

  CMD=$($FIND / -name .rhosts)
  if [[ $CMD != "" ]]; then
    $MKDIR -p $TMPDIR/$OUTDIR/NetworkConfiguration/rhosts
    $ECHO "Writing file $TMPDIR/$OUTDIR/NetworkConfiguration/rhosts/rhosts.txt"
    $CAT $CMD >> $TMPDIR/$OUTDIR/NetworkConfiguration/rhosts/rhosts.txt 2> /dev/null
    $ECHO "<h2>rhosts</h2>" >> $TMPDIR/$HTMLVIEW
    $CAT $CMD >> $TMPDIR/$HTMLVIEW 2> /dev/null
  else
    $MKDIR -p $TMPDIR/$OUTDIR/NetworkConfiguration/rhosts
    $ECHO ".rhosts file doesn't exist" >> $TMPDIR/$OUTDIR/NetworkConfiguration/rhosts/rhosts.txt 2> /dev/null
  fi

  if [[ -e $HEQUIV ]]; then
    if [[ -r $HEQUIV ]]; then
      $MKDIR -p $TMPDIR/$OUTDIR/NetworkConfiguration/rhosts
      $ECHO "Writing file $TMPDIR/$OUTDIR/NetworkConfiguration/rhosts/hostsequiv.txt"
      $CAT $HEQUIV >> $TMPDIR/$OUTDIR/NetworkConfiguration/rhosts/hostsequiv.txt 2> /dev/null
      $ECHO "<h2>hosts.equiv</h2>" >> $TMPDIR/$HTMLVIEW
      $CAT $HEQUIV >> $TMPDIR/$HTMLVIEW 2> /dev/null
    else
      $MKDIR -p $TMPDIR/$OUTDIR/NetworkConfiguration/rhosts
      $ECHO "files not readable" >> $TMPDIR/$OUTDIR/NetworkConfiguration/rhosts/hostsequiv.txt 2> /dev/null
    fi
  else
    $MKDIR -p $TMPDIR/$OUTDIR/NetworkConfiguration/rhosts
    $ECHO "$HEQUIV doesn't exist" >> $TMPDIR/$OUTDIR/NetworkConfiguration/rhosts/hostsequiv.txt 2> /dev/null
  fi

}

# The nmap function scans from outside the network possible open ports only if
# nmap package is isntalled or exists in the machine.
#
# It saves the output from the scan in $TMPDIR/$OUTDIR/NetworkConfiguration/nmap
function Nmap {

  $ECHO "Using nmap if installed for scanning network"
  timer

  for d in \
  "$NMAP -sS localhost" \
  "$NMAP -sS -O localhost" \
  "$NMAP -sN localhost" \
  "$NMAP -sV localhost" \
  "$NMAP -sO localhost" \
  "$NMAP -f localhost" \
  "$NMAP -sU localhost" \
  "$NMAP -sT localhost" \
  "$NMAP -sX localhost"
  do
    CMD=$(IfExists $d)
    if [[ $CMD != "NOTFOUND" && $CMD != "" ]]; then
      $MKDIR -p $TMPDIR/$OUTDIR/NetworkConfiguration/nmap
      $ECHO "------- writing $CMD -------" >> $TMPDIR/$OUTDIR/NetworkConfiguration/nmap/nmap.txt 2> /dev/null
      $CMD >> $TMPDIR/$OUTDIR/NetworkConfiguration/nmap/nmap.txt 2> /dev/null
      $ECHO "<h2>$CMD</h2>" >> $TMPDIR/$HTMLVIEW
      $CMD >> $TMPDIR/$HTMLVIEW 2> /dev/null
    fi
  done

  if [[ $CMD == "NOTFOUND" ]]; then
    $MKDIR -p $TMPDIR/$OUTDIR/NetworkConfiguration/nmap
    $ECHO "nmap is not installed" >> $TMPDIR/$OUTDIR/NetworkConfiguration/nmap/nmap.txt 2> /dev/null
  fi

}

# ChkcfgList function searches for chkconfig package installed. if it's installed
# it will execute a --list to know which services of the machine are running, if
# it doesn't it will run netstat -a.
#
# The output from the ChkcfgList is saved in $TMPDIR/$OUTDIR/NetworkServices/chkconfig
function ChkcfgList {

  $ECHO "Searching for chkconfig"
  timer

  if [[ -f $CHKCONFIG ]]; then
    $MKDIR -p $TMPDIR/$OUTDIR/NetworkServices/chkconfig
    $ECHO "Writing file $TMPDIR/$OUTDIR/NetworkServices/chkconfig/chkconfig.txt"
    $CHKCONFIG --list >> $TMPDIR/$OUTDIR/NetworkServices/chkconfig/chkconfig.txt 2> /dev/null
    $ECHO "<h2>CHKCONFIG</h2>" >> $TMPDIR/$HTMLVIEW
    $CHKCONFIG --list >> $TMPDIR/$HTMLVIEW 2> /dev/null
  else
    $MKDIR -p $TMPDIR/$OUTDIR/NetworkServices/chkconfig
    $ECHO "chkconfig command doesn't exist" >> $TMPDIR/$OUTDIR/NetworkServices/chkconfig/chkconfig.txt 2> /dev/null
  fi

}

function ActiveUsers {

  $ECHO "Searching for active users"
  timer

  if [[ -f $WHO ]]; then
    $ECHO "Writing file $TMPDIR/$OUTDIR/Users/who.txt"
    $WHO >> $TMPDIR/$OUTDIR/Users/who.txt 2> /dev/null
    $ECHO "<h2>WHO</h2>" >> $TMPDIR/$HTMLVIEW
    $WHO >> $TMPDIR/$HTMLVIEW 2> /dev/null
  else
    $ECHO "who command doesn't exist" >> $TMPDIR/$OUTDIR/Users/who.txt 2> /dev/null
  fi

  if [[ -f $W ]]; then
    $ECHO "Writing file $TMPDIR/$OUTDIR/Users/w.txt"
    $W >> $TMPDIR/$OUTDIR/Users/w.txt 2> /dev/null
    $ECHO "<h2>W</h2>" >> $TMPDIR/$HTMLVIEW
    $W >> $TMPDIR/$HTMLVIEW 2> /dev/null
  else
    $ECHO "w command doesn't exist" >> $TMPDIR/$OUTDIR/Users/w.txt 2> /dev/null
  fi

  if [[ -f $FINGER ]]; then
    $ECHO "Writing file $TMPDIR/$OUTDIR/Users/finger.txt"
    $FINGER >> $TMPDIR/$OUTDIR/Users/finger.txt 2> /dev/null
    $ECHO "<h2>Finger</h2>" >> $TMPDIR/$HTMLVIEW
    $FINGER >> $TMPDIR/$HTMLVIEW 2> /dev/null
  else
    $ECHO "finger command doesn't exist" >> $TMPDIR/$OUTDIR/Users/finger.txt 2> /dev/null
  fi

  if [[ -f $RUSERS ]]; then
    $ECHO "Writing file $TMPDIR/$OUTDIR/Users/rusers.txt"
    $RUSERS >> $TMPDIR/$OUTDIR/Users/rusers.txt 2> /dev/null
    $ECHO "<h2>Rusers</h2>" >> $TMPDIR/$HTMLVIEW
    $RUSERS >> $TMPDIR/$HTMLVIEW 2> /dev/null
  else
    $ECHO "rusers command doesn't exist" >> $TMPDIR/$OUTDIR/Users/rusers.txt 2> /dev/null
  fi

}

function SnmpConf {

  $ECHO "Copying snmp conf to $TMPDIR/$OUTDIR/NetworkServices/snmp/snmpconf.txt"
  timer

  SNMP="/etc/cups/snmp.conf"
  SNMP2="/etc/snmp/snmpd.conf"

  if [[ -f $SNMP || -f $SNMP2 ]]; then
    $ECHO "Writing file $TMPDIR/$OUTDIR/NetworkServices/snmp/snmpconf.txt"
    $CAT $SNMP >> $TMPDIR/$OUTDIR/NetworkServices/snmp/snmpconf.txt 2> /dev/null
    $ECHO "<h2>snmp</h2>" >> $TMPDIR/$HTMLVIEW
    $CAT $SNMP >> $TMPDIR/$HTMLVIEW 2> /dev/null
  else
    $ECHO "$SNMP file doesn't exist" >> $TMPDIR/$OUTDIR/NetworkServices/snmp/snmpconf.txt 2> /dev/null
  fi
}

function EtcGroup {

  $ECHO "Copying /etc/group to $TMPDIR/$OUTDIR/LogicConfiguration/group/group.txt"
  timer

  GROUP="/etc/group"

  if [[ -f $GROUP ]]; then
    $ECHO "Writing file $TMPDIR/$OUTDIR/LogicConfiguration/group/group.txt"
    $CAT $GROUP >> $TMPDIR/$OUTDIR/LogicConfiguration/group/group.txt 2> /dev/null
    $ECHO "<h2>/etc/group</h2>" >> $TMPDIR/$HTMLVIEW
    $CAT $GROUP >> $TMPDIR/$HTMLVIEW 2> /dev/null
  else
    $ECHO "$GROUP file doesn't exist" >> $TMPDIR/$OUTDIR/LogicConfiguration/group/group.txt 2> /dev/null
  fi

}

function Hostname {

  $ECHO "Copying hostname to $TMPDIR/$OUTDIR/Hostname/hostname.txt"
  timer

  if [[ -e $HOSTNAME ]]; then
    $HOSTNAME >> $TMPDIR/$OUTDIR/Hostname/hostname.txt 2> /dev/null
  else
    $ECHO "$HOSTNAME command doesn't exist" >> $TMPDIR/$OUTDIR/Hostname/hostname.txt 2> /dev/null
  fi

}

# MoveNotFoundLog function will copy the log "NOTFOUNDLOG" that contains the
# information if a command exists in the machine
#
# It will copy the log to $TMPDIR/$OUTDIR/notfound
function MoveNotFoundLog {

  $ECHO "MoveNotFoundLog function"

  if [[ -e $NOTFOUNDLOG ]]; then
    $MKDIR -p $TMPDIR/$OUTDIR/notfound
    $ECHO "Writing file $TMPDIR/$OUTDIR/notfound/notfoundlog.txt"
    $CP $NOTFOUNDLOG  $TMPDIR/$OUTDIR/notfound/notfoundlog.txt 2> /dev/null
  else
    $ECHO " $NOTFOUNDLOG doesn't exist "
  fi
}

# Compress $TMPDIR/$OUTDIR directory when script is done
#
# returns none
function Archive {

  $ECHO ""
  $ECHO "Starting to compress output."
  $SLEEP 2

  FILETOCOMP=$("hostname")_$(date +%Y%m%d-%H-%M-%S).tar.gz
  sed -e 's/$/<\/\br>/' $TMPDIR/$HTMLVIEW >> $TMPDIR/$HTMLVIEWFINAL

  cd $TMPDIR
  $RM -r $TMPDIR/$HTMLVIEW
  $TAR cvzf $FILETOCOMP $OUTDIR > /dev/null 2>&1
  $RM -r $OUTDIR

  if [[ -e $FILETOCOMP ]]; then
    $ECHO "compression successful"
    $ECHO "done."
    $ECHO "You can find the output in /tmp directory."
    $ECHO "the name of the output folder is $FILETOCOMP and $HTMLVIEWFINAL"
    $ECHO "If you wish you can upload the $HTMLVIEWFINAL to the site"
    exit 0
  else
    $ECHO " Error compressing $FILETOCOMP "
    exit 1
  fi

}

# Function exec calls.

CheckEnvironment
InitCmds
Creating
ifCatExists
Logger
Setids
Netstats
SShcfg
PasswdFile
SudoersFile
IptablesFiles
UfwStatus
Services
Nfsconf
Nfsavailable
ConnectionParams
EtcFiles
Apachecfg
Findrhosts
ChkcfgList
ActiveUsers
SnmpConf
Nmap
EtcGroup
Hostname
#MoveNotFoundLog
Archive

