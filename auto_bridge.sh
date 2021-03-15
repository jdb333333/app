#! /bin/sh
cd /sys/class/pwm/pwmchip0/
echo 0 > export
echo 500000000 > pwm0/period
echo 250000000 > pwm0/duty_cycle
echo 1 > pwm0/enable

sleep 2

ifconfig eth1 down
ifconfig eth1 up

ip link add br0 type bridge
ip link set eth0 master br0
ip link set eth1 master br0

repeat()
{
x=0;
while true
do
x=$(ifconfig $1 | egrep -o "inet [^ ]*" | grep -o "[0-9.]*");
if [ -z "$x" ]; then
if [ $1 = "eth1" ]; then
ifconfig $1 down;
ifconfig $1 up;
sleep 10;
fi
sleep 1;
else
ifconfig $1 0.0.0.0;
ifconfig $1 down
ifconfig $1 up 
return;
fi
done
}

repeat br0
repeat eth0
repeat eth1
