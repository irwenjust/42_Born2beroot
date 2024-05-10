#!/bin/bash

# Architecture for OS
arch=$(uname -a)

# Physical Cores
phys_co=$(grep "physical id" /proc/cpuinfo | wc -l)

# Virtual Cores
virt_co=$(grep "processor" /proc/cpuinfo | wc -l)

# RAM
ram_total=$(free --mega | awk '$1 == "Mem:" {print $2}')
ram_use=$(free --mega | awk '$1 == "Mem:" {print $3}')
ram_percent=$(free --mega | awk '$1 == "Mem:" {printf("%.2f"), $3/$2*100}')

# DISK
disk_total=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{total += $2} END {printf("%.1fGb\n"), total/1024}')
disk_use=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{use += $3} END {print use}')
disk_percent=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{use += $3} {total += $2} END {printf("%d\n"), use/total*100}')

# CPU usage percentage
cpu_load=$(vmstat 1 2 | tail -1 | awk '{printf("%.1f%%\n"), 100 - $15}')
#cpu_load=$(top -n1 | grep "%Cpu" | awk '{printf("%.1f%%", $2)}')

# LAST BOOT
last_boot=$(who -b | awk '$1 == "system" {print $3 " " $4}')

# LVM USE
lvm_use=$(if [ $(lsblk | grep "lvm" | wc -l) -gt 0 ]; then echo yes; else no; fi)

# TCP CONNECTIONS
tcp_con=$(ss -ta | grep ESTAB | wc -l)

# USER LOG
usr_log=$(users | wc -w)

# NETWORK
ip=$(hostname -I)
mac=$(ip link | grep "link/ether" | awk '{print $2}')

# SUDO
com_sudo=$(journalctl _COMM=sudo | grep COMMAND | wc -l)

wall "	#Architecture: $arch
	#CPU physical: $phys_co
	#vCPU: $virt_co
	#Memory Usage: $ram_use/${ram_total}MB ($ram_percent%)
	#Disk Usage: $disk_use/$disk_total ($disk_percent%)
	#CPU load: $cpu_load
	#Last boot: $last_boot
	#LVM use: $lvm_use
	#Connections TCP: $tcp_con ESTABLISHED
	#User log: $usr_log
	#Network: IP $ip ($mac)
	#Sudo: $com_sudo cmd
"
