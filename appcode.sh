#!/bin/bash
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

### JBOSS_HOME
JBOSS_HOME=/opt/jboss-eap-7.4

### CONFIG FILE
CONFIG_FILE_NAME=config-app.sh
CONFIG_FILE_PATH=/wl_config

### INJECTION SCRIPT
echo "#!/bin/bash" >> /$CONFIG_FILE_PATH/$CONFIG_FILE_NAME
echo "aws s3api get-object --bucket "'${1}'" --key "'${2}'" "'${3}'"" >> /$CONFIG_FILE_PATH/$CONFIG_FILE_NAME
echo killall java >> /$CONFIG_FILE_PATH/$CONFIG_FILE_NAME
echo systemctl restart jboss-eap-rhel >> /$CONFIG_FILE_PATH/$CONFIG_FILE_NAME
chmod +x /$CONFIG_FILE_PATH/$CONFIG_FILE_NAME

### UPDATE FILE
UPDATE_FILE_NAME=update-file.sh
UPDATE_FILE_PATH=/wl_config

### INJECTION SCRIPT
echo "#!/bin/bash" >> /$UPDATE_FILE_PATH/$UPDATE_FILE_NAME
echo "aws s3api get-object --bucket "'${1}'" --key "'${2}'" "'${3}'"" >> /$UPDATE_FILE_PATH/$UPDATE_FILE_NAME
chmod +x /$UPDATE_FILE_PATH/$UPDATE_FILE_NAME

### BUCKET
BUCKET_OPERATIONS=iberia-configs-files-apps-integration-operations

### CLUSTERNAME
CLUSTER_NAME=operations--sla1--eap--8015--infra

### DATASOURCE
DATASOURCE_FILE_NAME=standalone.xml
DATASOURCE_CLUSTER=Datasource/$CLUSTER_NAME/$DATASOURCE_FILE_NAME

### STANDALONE
STANDALONE_FILE_NAME=standalone.conf
STANDALONE_CLUSTER=Standalone/$CLUSTER_NAME/$STANDALONE_FILE_NAME

### PEOPLESOFT
PEOPLESOFT_CNX=cnx.properties
PEOPLESOFT_CONFIG=config_PeopleSoft.properties
PEOPLESOFT_PATH=/wl_internet/PeopleSoft/apli/config
PEOPLESOFT_FOLDER=Peoplesoft

### SWM
SWM_CONFIG=swm-config.xml
SWM_PATH=/wl_intranet/swm/apli/config
SWM_FOLDER=Swm

### ETC
ETC_FILE_NAME=hosts
ETC_CLUSTER=Etc/$CLUSTER_NAME/$ETC_FILE_NAME

echo "STANDALONE CALL SCRIPT"
bash /$UPDATE_FILE_PATH/$UPDATE_FILE_NAME $BUCKET_OPERATIONS $STANDALONE_CLUSTER $JBOSS_HOME/bin/$STANDALONE_FILE_NAME

### DATASOURCE CALL SCRIPT
echo "DATASOURCE CALL SCRIPT"
bash /$UPDATE_FILE_PATH/$UPDATE_FILE_NAME $BUCKET_OPERATIONS $DATASOURCE_CLUSTER $JBOSS_HOME/standalone/configuration/$DATASOURCE_FILE_NAME

### PEOPLESOFT CALL SCRIPT
echo "PEOPLESOFT CALL SCRIPT"
bash /$UPDATE_FILE_PATH/$UPDATE_FILE_NAME $BUCKET_OPERATIONS $PEOPLESOFT_FOLDER/$PEOPLESOFT_CNX $PEOPLESOFT_PATH/$PEOPLESOFT_CNX
bash /$UPDATE_FILE_PATH/$UPDATE_FILE_NAME $BUCKET_OPERATIONS $PEOPLESOFT_FOLDER/$PEOPLESOFT_CONFIG $PEOPLESOFT_PATH/$PEOPLESOFT_CONFIG

### SWM CALL SCRIPT
echo "SWM CALL SCRIPT"
bash /$UPDATE_FILE_PATH/$UPDATE_FILE_NAME $BUCKET_OPERATIONS $SWM_FOLDER/$SWM_CONFIG $SWM_PATH/$SWM_CONFIG

### ETC CALL SCRIPT
echo "ETC CALL SCRIPT"
bash /$UPDATE_FILE_PATH/$UPDATE_FILE_NAME $BUCKET_OPERATIONS $ETC_CLUSTER /etc/$ETC_FILE_NAME

killall java
systemctl restart jboss-eap-rhel

##########Fix NTP Issues##############
cp /etc/chrony.conf /etc/chrony.conf.back
sed -i "$(grep -n "rhel.pool.ntp.org" /etc/chrony.conf | cut -d : -f 1) s/./#&/" /etc/chrony.conf
sed -i "$(grep -n "leapsectz right/UTC" /etc/chrony.conf | cut -d : -f 1) s/./#&/" /etc/chrony.conf
systemctl restart chronyd

###REGISTER IN RH INSIGHTS###
sudo subscription-manager register --org=3732146 --activationkey=insights --force
sudo insights-client --register