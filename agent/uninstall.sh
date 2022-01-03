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

# Prepare output
echo -e "|\n|   NQNext Uninstaller\n|   ===================\n|"

# Root required
if [ $(id -u) != "0" ];
then
	echo -e "|   Error: You need to be root to uninstall the NQNext agent\n|"
	echo -e "|          The agent itself will NOT be running as root but instead under its own non-privileged user\n|"
	exit 1
fi


# Remove cron entry and user
if id -u nqnext >/dev/null 2>&1
then
	(crontab -u nqnext -l | grep -v "/etc/nqnext/agent") | crontab -u nqnext - && userdel nqnext
else
	(crontab -u root -l | grep -v "/etc/nqnext/agent") | crontab -u root -
fi

# Remove agent dir
rm -Rf /etc/nqnext/agent

echo -e "|\n|   Success: The NQNext agent has been uninstalled\n|"
