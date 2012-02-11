function createFolders
{
  local sSiteFullPathAndName=$BASE_DIR"/"$sSiteName"."$sSiteDomain

  if [ -d "$sSiteFullPathAndName" ]; 
  then
    read -p "Do you want to recreate folder!? [y]: " bRF
    if [ "$bRF" = "" ];
    then
      bRF="y"
    fi
    
    # Is user wants to remove existing folder
    if [ "$bRF" = "y" ];
    then
      removeFolders
    else
      exit
    fi
  fi
  

  # Create site dir
  mkdir $sSiteFullPathAndName
  echo "Folder $sSiteFullPathAndName successfully created!"
  mkdir "$sSiteFullPathAndName/sess"
  echo "Folder $sSiteFullPathAndName/sess successfully created!"
  mkdir "$sSiteFullPathAndName/log"
  echo "Folder $sSiteFullPathAndName/log successfully created!"
  mkdir "$sSiteFullPathAndName/tmp"
  echo "Folder $sSiteFullPathAndName/tmp successfully created!"
  mkdir "$sSiteFullPathAndName/www"
  echo "Folder $sSiteFullPathAndName/www successfully created!"      
  # change mod
  chmod -R 777 "$sSiteFullPathAndName"
  echo "$sSiteFullPathAndName successfully rights changed!"
}

function removeFolders
{
  read -p "Do you want to create backup of your site? [$MAKE_BACKUP]: " bMB
  if [ "$bMB" = "" ];
  then
    bMB=$MAKE_BACKUP
  fi
  
  if [ "$bMB" = "y" ];
  then
    makeBackup
  fi

  local sSiteFullPathAndName=$BASE_DIR"/"$sSiteName"."$sSiteDomain
  
  rm -R $sSiteFullPathAndName
  echo "Folder $sSiteFullPathAndName deleted successfully"
}

function createConfig
{
  local sDefaultSite=$DEFAULT_SITENAME"."$DEFAULT_DOMAIN
  local sUserSite=$sSiteName"."$sSiteDomain

  if [ -f $sConfigFile -a -r $sConfigFile ];
  then
    sudo sed "s/$sDefaultSite/$sUserSite/g" "$sConfigFile" > $S_A_CONFIGS"/"$sUserSite
    sudo ln $S_A_CONFIGS"/"$sUserSite $S_E_CONFIGS"/"$sUserSite
    echo "Configs successfully created"
  fi
}

function removeConfig
{
  local sUserSite=$sSiteName"."$sSiteDomain
  
  sudo rm $S_E_CONFIGS"/"$sUserSite
  sudo rm $S_A_CONFIGS"/"$sUserSite
  echo "Configs removed for $sUserSite"
}

function addHost
{
  local sUserSite=$sSiteName"."$sSiteDomain
  
  sudo echo $IP" "$sUserSite" www."$sUserSite >> $HOSTS
  echo "Site added to hosts list"
}

function removeHost
{
  local sUserSite=$sSiteName"."$sSiteDomain
  
  sudo sed "/$sUserSite/d" $HOSTS > $HOSTS_TMP
  sudo rm $HOSTS
  sudo cp $HOSTS_TMP $HOSTS
  echo "Site removed from hosts list"
}

function restartServer
{
  sudo $APACHE restart
}

function makeBackup
{
  local sSiteFullPathAndName=$BASE_DIR"/"$sSiteName"."$sSiteDomain
  
  tar zcvf $sSiteName"."$sSiteDomain".tar.gz" $sSiteFullPathAndName

  # check for backup folder existing
  if [ ! -d "$BACKUP_FOLDER" ];
  then
    mkdir $BACKUP_FOLDER
  fi
  mv $sSiteName"."$sSiteDomain".tar.gz" $BACKUP_FOLDER
  sudo chmod -R 777 $BACKUP_FOLDER

  echo "Backup created successfully: $sSiteName.$sSiteDomain.tar.gz"
}
