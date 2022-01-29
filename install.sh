#!/bin/bash
#
# NQNext Agent Installation Script
# This script is heavily inspired by https://github.com/nodequery/nq-agent/blob/master/nq-install.sh
#
# @version		0.0.1
# @date			2022-01-01
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.


# Set environment
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
NQ_HOME=/etc/nqnext

# Prepare output
echo -e "|\n|   NQNext Installer\n|   ===================\n|"

# Root required
if [ $(id -u) != "0" ];
then
	echo -e "|   Error: You need to be root to install the NQNext agent\n|"
	echo -e "|          The agent itself will NOT be running as root but instead under its own non-privileged user\n|"
	exit 1
fi

# Parameters required
if [ $# -lt 1 ]
then
	echo -e "|   Usage: bash $0 'token'\n|"
	exit 1
fi

# Check if crontab is installed
if [ ! -n "$(command -v crontab)" ]
then

	# Confirm crontab installation
	echo "|" && read -p "|   Crontab is required and could not be found. Do you want to install it? [Y/n] " input_variable_install

	# Attempt to install crontab
	if [ -z $input_variable_install ] || [ $input_variable_install == "Y" ] || [ $input_variable_install == "y" ]
	then
		if [ -n "$(command -v apt-get)" ]
		then
			echo -e "|\n|   Notice: Installing required package 'cron' via 'apt-get'"
		    apt-get -y update
		    apt-get -y install cron
		elif [ -n "$(command -v yum)" ]
		then
			echo -e "|\n|   Notice: Installing required package 'cronie' via 'yum'"
		    yum -y install cronie

		    if [ ! -n "$(command -v crontab)" ]
		    then
		    	echo -e "|\n|   Notice: Installing required package 'vixie-cron' via 'yum'"
		    	yum -y install vixie-cron
		    fi
		elif [ -n "$(command -v pacman)" ]
		then
			echo -e "|\n|   Notice: Installing required package 'cronie' via 'pacman'"
		    pacman -S --noconfirm cronie
		fi
	fi

	if [ ! -n "$(command -v crontab)" ]
	then
	    # Show error
	    echo -e "|\n|   Error: Crontab is required and could not be installed\n|"
	    exit 1
	fi
fi

# Check if cron is running
if [ -z "$(ps -Al | grep cron | grep -v grep)" ]
then

	# Confirm cron service
	echo "|" && read -p "|   Cron is available but not running. Do you want to start it? [Y/n] " input_variable_service

	# Attempt to start cron
	if [ -z $input_variable_service ] || [ $input_variable_service == "Y" ] || [ $input_variable_service == "y" ]
	then
		if [ -n "$(command -v apt-get)" ]
		then
			echo -e "|\n|   Notice: Starting 'cron' via 'service'"
			service cron start
		elif [ -n "$(command -v yum)" ]
		then
			echo -e "|\n|   Notice: Starting 'crond' via 'service'"
			chkconfig crond on
			service crond start
		elif [ -n "$(command -v pacman)" ]
		then
			echo -e "|\n|   Notice: Starting 'cronie' via 'systemctl'"
		    systemctl start cronie
		    systemctl enable cronie
		fi
	fi

	# Check if cron was started
	if [ -z "$(ps -Al | grep cron | grep -v grep)" ]
	then
		# Show error
		echo -e "|\n|   Error: Cron is available but could not be started\n|"
		exit 1
	fi
fi

# Attempt to delete previous agent
if [ -f $NQ_HOME/agent/uninstall.sh ]
then
  bash $NQ_HOME/agent/uninstall.sh || exit 1
fi

# Create dirs
mkdir -p $NQ_HOME/probes


# Download agent
mkdir nqnext-install-tmp && cd nqnext-install-tmp || exit 1
curl -L https://github.com/ovenator/nqnext-agent/archive/refs/heads/master.tar.gz | tar -xz --strip-components 1 || exit 1
cp -R agent/ $NQ_HOME/agent/
cd .. && rm -rf nqnext-install-tmp || exit 1

if [ -f $NQ_HOME/agent/run.sh ]
then
	# Create env file
	NQ_ENV_FILE=$NQ_HOME/agent/env.txt
	echo "NQ_AUTH='$1'" >> $NQ_ENV_FILE
	echo "NQ_HOST='https://ingest.logwars.com'" >> $NQ_ENV_FILE
	echo "NQ_HOME='$NQ_HOME'" >> $NQ_ENV_FILE

	# Create user
	useradd nqnext -r -d $NQ_HOME -s /bin/false

	# Modify user permissions
	chown -R nqnext:nqnext $NQ_HOME && chmod -R 700 $NQ_HOME

	# Modify ping permissions
	chmod +s `type -p ping`

	# Configure cron
	crontab -u nqnext -l 2>/dev/null | { cat; echo "*/1 * * * * cd $NQ_HOME/agent && bash run.sh > cron.log 2>&1"; } | crontab -u nqnext -

	# Show success
	echo -e "|\n|   Success: The NQNext agent has been installed\n|"

	# Attempt to delete installation script
	if [ -f $0 ]
	then
		rm -f $0
	fi
else
	# Show error
	echo -e "|\n|   Error: The NQNext agent could not be installed\n|"
fi