#!/bin/bash
###########################################################################
# récupération des information
userName="$USER"
now=$(date +"%T")
node="node"
npm="npm"
angular="angular"
finishScript=$false

#Fonction
# Define a timestamp function
timestamp() {
  date +"%F %T"
}

timestamp

# shellcheck disable=SC1035
if [["$now" <"12:00:00"]]; then
  echo "bonjour [ $userName ]"
else
  echo "bonne apres-midi [ $userName ]"
fi
mkdir projectOs
cd projectOs
echo "souhaitez vous lancer les Container Docker? [y,n]"
read input

echo "************$(timestamp)***********" >>logOS.log
echo "$(timestamp) l'utilisateur [ $userName ] a lancer le script" >>logOS.log

if [[ $input == "Y" || $input == "y" ]]; then

  echo "========================= vérification si docker et docker compose sont installé=================="
  echo "$(timestamp) [ $userName ] vérification si docker est installé sur la machine" >>logOS.log
  if [ -x "$(command -v docker)" ]; then
    echo "Update docker"
    echo "$(timestamp) [ $userName ] docker et docker compose sont installé sur la machine" >>logOS.log

    echo "$(command -v docker)"
    echo "$(timestamp) [ $userName ] chemin d'accès => $(command -v docker)" >>logOS.log
  # command
  else
    echo "$(timestamp) [ $userName ] installation de docker" >>logOS.log
    echo "Installation de  docker"
    #update
    sudo apt-get update
    #debut d'installation
    sudo apt-get install \
      apt-transport-https \
      ca-certificates \
      curl \
      gnupg-agent \
      software-properties-common
    # command
    # Add Docker’s official GPG key:
    echo "$(timestamp) [ $userName ] récuperation de GPG Key de docker" >>logOS.log
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    #vérification de la clé
    echo "$(timestamp) [ $userName ] vérificationd de la clé" >>logOS.log
    sudo apt-key fingerprint 0EBFCD88
    #install suite
    sudo add-apt-repository \
      "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
       $(lsb_release -cs) \
      stable"
    # install docker engine
    echo "$(timestamp) [ $userName ] installation de docker engine" >>logOS.log
    sudo apt-get update
    sudo apt-get install docker-ce docker-ce-cli containerd.io
    # test hello world docker
    echo "$(timestamp) [ $userName ] test du bon fonctionnement de docker" >>logOS.log
    sudo docker run hello-world
    #installation de docker compose
    echo "$(timestamp) [ $userName ] installation docker compose" >>logOS.log
    sudo curl -L "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    #ajout des permissions
    echo "$(timestamp) [ $userName ] ajout des permissions" >>logOS.log
    sudo chmod +x /usr/local/bin/docker-compose
    #verification de l'installation
    echo "$(timestamp) [ $userName ]  version de docker compose => docker-compose --version " >>logOS.log
    docker-compose --version

  fi

  echo "$(timestamp) [ $userName ] début du process" >>logOS.log
  echo "nous allons faire un update tout d'abord et installer toute les dépendance le bon fonctionnement du projet"

  echo "$(timestamp) [ $userName ] verification si docker est présent" >>logOS.log

  echo "$(timestamp) [ $userName ] update de l'OS" >>logOS.log
  sudo apt-get update

  echo "=============== maintenant l'installation des packages suivants $node , $npm ,$angular======================="

  echo "$(timestamp) [ $userName ] installer des logiciels node et npm" >>logOS.log
  echo "=================== installation de $node et $npm ==========================="

  npm install	
  curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
  sudo apt install nodejs 	
  # vérification des versions
  echo "$(timestamp) [ $userName ] vérification des version" >>logOS.log
  echo "$node version => "
  node --version
  echo "$npm version =>"
  npm --version
  echo "$(timestamp) [ $userName ] fin de l'installation de node et npm" >>logOS.log
  echo "======================= Installation d'angular cli ==========================="

  echo "$(timestamp) [ $userName ] Installation d'angular CLI" >>logOS.log
  sudo npm install -g d @angular/cli

else
  echo "lancement annulé"
  echo "$(timestamp) [ $userName ] procédure annulé" >>logOS.log
fi

echo "================ installation de git ==============="
echo "$(timestamp) [ $userName ] verification de l'installation de git" >>logOS.log
if [ -x "$(command -v git)" ]; then
  echo "$(timestamp) [ $userName ] git est déja présent sur la machine" >>logOS.log
  echo "git est installé"
  else
    echo "$(timestamp) [ $userName ] procédure d'installation de git" >>logOS.log
    echo "installation de git"
sudo apt-get install git

fi
echo "récupération du projet sur GitHub"
echo "$(timestamp) [ $userName ] pull request vers le github" >>logOS.log
echo "$(timestamp) [ $userName ] clone du repository" >>logOS.log
git clone https://github.com/gangachris/mean-docker
echo "$(timestamp) [ $userName ] installation des dépendances" >>logOS.log
cd mean-docker/angular-client/
npm install 
echo "$(timestamp) [ $userName ] lancement de docker-compose" >>logOS.log
cd ..
echo "ouverture de firefox et lancement des containter"
docker-compose up & firefox "http://localhost:4200/";
cd ..
echo "$(timestamp) [ $userName ] lancement de firefox" >>logOS.log
echo "ouverture de firefox"

##check activité des container
#echo "dock activ"
#echo docker container inspect 3b1fa27ee134 

echo "$(timestamp) [ $userName ] affichage des containers lancés par docker" >>logOS.log
echo "**************** affichage des containers lancés par docker **********************" 
echo "==============" >>logOS.log
echo "$(timestamp) [ $userName ] $(docker ps -a)" >>logOS.log
docker ps -a 
echo "==============" >>logOS.log
echo "dock activ"

echo "=============dock top============="
docker container top 3b1fa27ee134
echo "=============dock attach============="
docker container attach 3b1fa27ee134


echo "********************** fin des installations *****************************"
cd mean-docker/
while [[ $input != "Y" || $input != "y" || $input != "N" || $input != "n" ]]
do
echo "Voulez-vous connaître les infos du fichier docker-compose [y/n] ?"
read input
if [[ $input == "Y" || $input == "y" ]]; then
echo "localisation / lignes / bytes du logOS.log : "
find . -type f -iname "docker-compose*" 
wc -l -c docker-compose.yml
cd ..
echo "$(timestamp) [ $userName ] rechecher le fichier .yml" >>logOS.log
break
elif [[ $input == "N" || $input == "n" ]]; then
cd ..
echo "$(timestamp) [ $userName ] interruption de la recherche du fichier .yml" >>logOS.log
echo "fin" 
break
else 
echo " --> appuyez sur les bonnes touches svp !"
fi
done
