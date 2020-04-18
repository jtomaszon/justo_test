#!/bin/bash
yum install httpd -y
echo "Subnet for Firewall: ${firewall_subnets}" >> /var/www/html/index.html
service httpd start
chkconfig httpd on
pip install celery
pip install redis
echo "from celery import Celery" >> /home/ec2-user/tasks.py
echo "" >> /home/ec2-user/tasks.py
echo "app = Celery('tasks', broker='redis://${redis_address}:6379//')" >> /home/ec2-user/tasks.py
echo "" >> /home/ec2-user/tasks.py
echo "@app.task" >> /home/ec2-user/tasks.py 
echo "def add(x, y):" >> /home/ec2-user/tasks.py 
echo "    return x + y" >> /home/ec2-user/tasks.py
chown ec2-user:ec2-user /home/ec2-user/tasks.py
su - ec2-user -c "cd /home/ec2-user && celery -A tasks worker --loglevel=info --detach"
