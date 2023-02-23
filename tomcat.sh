
#!/bin/bash
echo "This script is successfully tested on ubuntu 18.04 machine for the Installation of tomcat and modifying manager credentials"
echo "Pay attention to the Screen for failures"
VER="8.5.75"
tomcat_url="https://archive.apache.org/dist/tomcat/tomcat-8/v${VER}/bin/apache-tomcat-${VER}.tar.gz"
# If you want to download tomcat 9.0.48 change value of variable VER=9.0.48 and change tomcat-8 to tomcat-9 in the url"
echo "Download tomcat "
sudo wget $tomcat_url -P /tmp/
sudo tar zxvf /tmp/apache-tomcat-${VER}.tar.gz -C /opt/
echo "Rename tomcat Directory"
mv /opt/apache-tomcat-${VER} /opt/tomcat
# "This tomcat.service file is written and tested for ubuntu server on which java-8-openjdk is installed"
echo "create tomcat.service file"
touch /etc/systemd/system/tomcat.service
echo "[Unit]" >> /etc/systemd/system/tomcat.service
echo "Description=Apache Tomcat Web Application Container" >> /etc/systemd/system/tomcat.service
echo "After=network.target" >> /etc/systemd/system/tomcat.service
echo "[Service]" >> /etc/systemd/system/tomcat.service
echo "Type=oneshot" >> /etc/systemd/system/tomcat.service
echo "Environment=JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64" >> /etc/systemd/system/tomcat.service
# Make sure the JAVA_HOME is defined correct
echo "Environment=CATALINA_PID=/opt/tomcat/temp/tomcat.pid" >> /etc/systemd/system/tomcat.service
echo "Environment=CATALINA_HOME=/opt/tomcat" >> /etc/systemd/system/tomcat.service
echo "Environment=CATALINA_BASE=/opt/tomcat" >> /etc/systemd/system/tomcat.service
echo "Environment='CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC'" >> /etc/systemd/system/tomcat.service
echo "Environment='JAVA_OPTS=-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom'" >> /etc/systemd/system/tomcat.service
echo "ExecStart=/opt/tomcat/bin/startup.sh" >> /etc/systemd/system/tomcat.service
echo "ExecStop=/opt/tomcat/bin/shutdown.sh" >> /etc/systemd/system/tomcat.service
echo "User=root" >> /etc/systemd/system/tomcat.service
echo "Group=root" >> /etc/systemd/system/tomcat.service
echo "UMask=0007" >> /etc/systemd/system/tomcat.service
echo "RestartSec=10" >> /etc/systemd/system/tomcat.service
echo "RemainAfterExit=yes" >> /etc/systemd/system/tomcat.service
echo "[Install]" >> /etc/systemd/system/tomcat.service
echo "WantedBy=multi-user.target" >> /etc/systemd/system/tomcat.service
# Allowing manager access from outside
echo "Changing Access for manager & host-manager applications by editing context.xml"
sed -i 's/<Valve className="org.apache.catalina.valves.RemoteAddrValve"/<!-- <Valve className="org.apache.catalina.valves.RemoteAddrValve"  -->/' /opt/tomcat/webapps/manager/META-INF/context.xml
sed -i 's/<Valve className="org.apache.catalina.valves.RemoteAddrValve"/<!-- <Valve className="org.apache.catalina.valves.RemoteAddrValve"  -->/' /opt/tomcat/webapps/host-manager/META-INF/context.xml
# Creating users and assigning mananger-gui and manager-script roles"
sed -i 's+</tomcat-users>+<user username="admin" password="admin@123" roles="manager-gui,manager-script"/>    </tomcat-users>+' /opt/tomcat/conf/tomcat-users.xml
echo "Enabling tomcat service"
sudo systemctl enable tomcat
echo "starting tomcat service"
serv=java
sstat=$(pidof $serv | wc -l )
if [ $sstat -gt 0 ]
then
echo "Tomcat is running!!"
else
systemctl start tomcat
echo "Tomcat is UP now!!!"
fi
echo " Successfully launched Tomcat"
echo "username for "manager-gui" and "mananger-script" is "admin" and the password is "admin@123""
