#!/bin/sh

setup_git() {
 git config --global user.email "bot@openvision.tech"
 git config --global user.name "Open Vision settings bot"
 git config advice.addignoredfile false
}

commit_files() {
 git clean -fd
 git checkout master

 ./CI/gioppygio.sh
 ./CI/henksat.sh
 ./CI/morph883.sh
 ./CI/ciefp.sh
 ./CI/hans.sh
 ./CI/vhannibal.sh
 ./CI/matze.sh
 ./CI/dona.sh
 ./CI/predrag.sh
 echo "no" > force

 cd feed
 rm -f ./feed/Packages.gz &> /dev/null
 chmod 755 IPKFeedGenerator.jar
 java -jar IPKFeedGenerator.jar 
 cd ..
 git add -u
 git add *
 git commit -m "Fetch latest settings."
}

upload_files() {
 git remote add upstream https://${GITHUB_TOKEN}@github.com/OpenVisionE2/settings-feed.git > /dev/null 2>&1
 git push --quiet upstream master || echo "failed to push with error $?"
}

setup_git
commit_files
upload_files
