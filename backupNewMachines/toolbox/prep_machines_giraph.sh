#!/usr/bin/env bash

GROUP="@dco_rack1"

# Giraph

clush -w $GROUP hostname

#clush -w $GROUP -l root yum install -y java-1.7.0-openjdk-devel
#clush -w $GROUP -l root "yum install -y git"
#clush -w $GROUP -l root "wget http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo && yum install -y apache-maven"

#clush -w $GROUP -l root "group hadoop && adduser hduser && usermod -g hadoop hduser"
#clush -w $GROUP -l root "cd /usr/local && wget http://archive.apache.org/dist/hadoop/core/hadoop-0.20.203.0/hadoop-0.20.203.0rc1.tar.gz && tar xzf hadoop-0.20.203.0rc1.tar.gz && mv hadoop-0.20.203.0 hadoop && chown -R hduser:hadoop hadoop"

#clush -w $GROUP -l root "echo \"export HADOOP_HOME=/usr/local/hadoop\" >> /local/home/hduser/.bashrc"
#clush -w $GROUP -l root "echo \"export JAVA_HOME=/usr/lib/jvm/java-1.7.0-openjdk-1.7.0.71.x86_64\" >> /local/home/hduser/.bashrc"
#clush -w $GROUP -l root "echo \"export GIRAPH_HOME=/usr/local/giraph\" >> /local/home/hduser/.bashrc"

#clush -w $GROUP -l root "echo \"export JAVA_HOME=/usr/lib/jvm/java-1.7.0-openjdk-1.7.0.71.x86_64\" >> /usr/local/hadoop/conf/hadoop-env.sh"
#clush -w $GROUP -l root "echo \"export HADOOP_OPTS=-Djava.net.preferIPv4Stack=true\" >> /usr/local/hadoop/conf/hadoop-env.sh"

#clush -w $GROUP -l root "mkdir -p /media/hdd/hadoop-tmp && chmod 777 /media/hdd/hadoop-tmp"
#clush -w $GROUP -l root "mkdir -p /media/ssd/hadoop-tmp && chmod 777 /media/ssd/hadoop-tmp"

#clush -w $GROUP -l lbindsch "rm -rf /tmp/hadoop && cp -R ~/toolbox/hadoop /tmp/hadoop"
#clush -w $GROUP -l root "cp /tmp/hadoop/* /usr/local/hadoop/conf/."

#clush -w $GROUP -l root "su - hduser -c \"rm -f ~/.ssh/id_rsa* && ssh-keygen -t rsa -b 4096 -q -f ~/.ssh/id_rsa -N ''\""
#for i in `seq 1 32`; do ssh root@dco-node$(printf "%03d" $i) "cat /local/home/hduser/.ssh/id_rsa.pub" >> ~/authorized_keys; done
#clush -w $GROUP -l lbindsch "cp ~/authorized_keys /tmp/."
#clush -w $GROUP -l root "cp /tmp/authorized_keys /local/home/hduser/.ssh/. && chown hduser:hadoop /local/home/hduser/.ssh/authorized_keys"
#rm -f ~/authorized_keys

#clush -w $GROUP -l root "su - hduser -c \"/usr/local/hadoop/bin/hadoop namenode -format\""
#clush -w $GROUP -l root "su - hduser -c \"/usr/local/hadoop/bin/stop-dfs.sh\""
#clush -w $GROUP -l root "su - hduser -c \"/usr/local/hadoop/bin/stop-mapred.sh\""
#clush -w $GROUP -l root "su - hduser -c \"/usr/local/hadoop/bin/start-dfs.sh\""
#clush -w $GROUP -l root "su - hduser -c \"/usr/local/hadoop/bin/start-mapred.sh\""
#clush -w $GROUP -l root "su - hduser -c \"jps\""

#clush -w $GROUP -l root "cd /usr/local && git clone https://github.com/apache/giraph.git && chown -R hduser:hadoop giraph"

clush -w $GROUP -l root "su - hduser -c \"cd /usr/local/giraph && mvn package -DskipTests\""
