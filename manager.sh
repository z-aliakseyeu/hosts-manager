#!/bin/bash
. ./library.sh

# your folder where you are storing your sites
BASE_DIR="/web"
# current folder
CURRENT_FOLDER="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# apache demon
APACHE="/etc/init.d/apache2"
# localhost ip
IP="127.0.0.1"
# hosts file
HOSTS="/etc/hosts"
# apache sites-available configs
S_A_CONFIGS="/etc/apache2/sites-available"
# apache sites-enabled configs
S_E_CONFIGS="/etc/apache2/sites-enabled"
# default config file, which consists apache configuration
DEFAULT_CONFIG="default.cfg"
# default site name
DEFAULT_SITENAME="site"
# default site domain
DEFAULT_DOMAIN="local"
# backup
MAKE_BACKUP="y"
BACKUP_FOLDER="backups"

# all operations
OPERATIONS[0]="create"
OPERATIONS[1]="remove"
OPERATIONS[2]="host-add"
# default operation
DEFAULT_OPERATION=${OPERATIONS[0]}
# temp hosts file
HOSTS_TMP="hosts"



# get operation
read -p "Please enter operation type [$DEFAULT_OPERATION]: " sOperation
# flag: finded operation or not
bFinded=0
if [ "$sOperation" = "" ]; then
  # if inputted text is empty and operation will be by default
  sOperation=$DEFAULT_OPERATION
  bFinded=1
else
  # find operation in operations array
  for index in 0 1 2
  do
    if [ "$sOperation" = ${OPERATIONS[$index]} ]; then
      bFinded=1
      break
    fi
  done
fi

if [ "$bFinded" = 0 ]; then
  echo -e "${red}Could not find such operation type $sOperation"
  exit
fi

# if operation is remove maybe user wants to make backup of the files. Set flag

### backup check

# get user site name
read -p "Please enter the name of your site [$DEFAULT_SITENAME]: " sSiteName
if [ "$sSiteName" = "" ]; then
  sSiteName=$DEFAULT_SITENAME
fi

# get user domain name. Such as *.my, *.local
read -p "Please enter the domain name [$DEFAULT_DOMAIN]: " sSiteDomain
if [ "$sSiteDomain" = "" ]; then
  sSiteDomain=$DEFAULT_DOMAIN
fi

#******************* actions check ********************#
if [ "$sOperation" = ${OPERATIONS[0]} ]; 
then
  ######## create
  echo "in config sitename need to be $DEFAULT_SITENAME and domain $DEFAULT_DOMAIN"
  read -p "Default config filename[$DEFAULT_CONFIG]: " sConfigFile
  if [ "$sConfigFile" = "" ]; 
  then
    sConfigFile=$DEFAULT_CONFIG
  fi
  #### operations
  createFolders
  createConfig
  addHost
  restartServer
elif [ "$sOperation" = ${OPERATIONS[1]} ]; then
  ####### remove
  removeFolders
  removeConfig
  removeHost
  restartServer
elif [ "$sOperation" = ${OPERATIONS[2]} ]; then
  ###### add host to hosts list
  addHost
  restartServer
fi