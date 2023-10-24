# place in /bin directory of Tomcat installation

NANOTASK_CONFPATH="{path to confpath directory}"

export JAVA_OPTS="$JAVA_OPTS -Dnanotask.confpath=${NANOTASK_CONFPATH} -Dnanotask.allcanupdate=false -Dnanotask.archiveWebUrl=localhost:8087/nanotask -Dnanotask.archiveDir=/rv/data/library/pywb/collections/nanotask/archive"

