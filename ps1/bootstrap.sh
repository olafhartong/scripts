#! /bin/bash

export DEBIAN_FRONTEND=noninteractive
sed -i 's/archive.ubuntu.com/us.archive.ubuntu.com/g' /etc/apt/sources.list

apt_install_prerequisites() {
  # Install prerequisites and useful tools
  apt-get update
  apt-get install -y jq whois build-essential git docker docker-compose unzip htop curl
}

install_python() {
  # Install Python 3.6.4
  if ! which /usr/local/bin/python3.6 > /dev/null; then
    echo "Installing Python v3.6.4..."
    wget https://www.python.org/ftp/python/3.6.4/Python-3.6.4.tgz
    tar -xvf Python-3.6.4.tgz
    cd Python-3.6.4 || exit
    ./configure && make && make install
    cd /home/vagrant || exit
  else
    echo "Python seems to be downloaded already.. Skipping."
  fi
}

install_splunk() {
  # Check if Splunk is already installed
  if [ -f "/opt/splunk/bin/splunk" ]; then
    echo "Splunk is already installed"
  else
    echo "Installing Splunk..."
	# Get download.splunk.com into the DNS cache. Sometimes resolution randomly fails during wget below
	dig @8.8.8.8 download.splunk.com > /dev/null
	dig @8.8.8.8 splunk.com > /dev/null
	mkdir splunk
	LATEST_SPLUNK=$(curl https://www.splunk.com/en_us/download/splunk-enterprise.html | grep -i deb | grep -Eo "data-link=\"................................................................................................................................" | cut -d '"' -f 2)
	wget --progress=bar:force -P splunk/ "$LATEST_SPLUNK"
	dpkg -i splunk/*.deb
	/opt/splunk/bin/splunk start --accept-license --answer-yes --no-prompt --seed-passwd empty-laboring-Find-Elegant-Droop-Aftermost
	/opt/splunk/bin/splunk add index windows -auth 'admin:empty-laboring-Find-Elegant-Droop-Aftermost'
    /opt/splunk/bin/splunk add index threathunting -auth 'admin:empty-laboring-Find-Elegant-Droop-Aftermost'
    /opt/splunk/bin/splunk add index linux -auth 'admin:empty-laboring-Find-Elegant-Droop-Aftermost'
	
    # Install ThreatHunting app
    cd /opt/splunk/etc/apps
    git clone https://github.com/olafhartong/ThreatHunting
    mkdir -p /opt/splunk/etc/users/admin/search/local
    echo -e "[search-tour]\nviewed = 1" > /opt/splunk/etc/system/local/ui-tour.conf
    mkdir /opt/splunk/etc/apps/user-prefs/local
    echo '[general]
    render_version_messages = 0
    hideInstrumentationOptInModal = 1
    dismissedInstrumentationOptInVersion = 2
    [general_default]
     hideInstrumentationOptInModal = 1
    showWhatsNew = 0' > /opt/splunk/etc/system/local/user-prefs.conf
    # Enable SSL Login for Splunk
    echo -e "[settings]\nenableSplunkWebSSL = true" > /opt/splunk/etc/system/local/web.conf
    # Skip Splunk Tour and Change Password Dialog
    touch /opt/splunk/etc/.ui_login
    # Add a Splunk TCP input on port 9997
    echo -e "[splunktcp://9997]\nconnection_host = ip" > /opt/splunk/etc/apps/search/local/inputs.conf
    # Reboot Splunk to make changes take effect
    /opt/splunk/bin/splunk set web-port 443
    /opt/splunk/bin/splunk restart
    /opt/splunk/bin/splunk enable boot-start
     fi
}


main() {
  apt_install_prerequisites
  install_python
  install_splunk
}

main
exit 0
