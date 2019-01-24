#!/bin/sh

WORKDIR=/synapse

UID=${UID:-1000}
GID=${GID:-1000}
USER=matrix
GROUP=matrix

set -ex

fix_matrix_user() {
    userdel $USER || true
    groupdel $GROUP || true
    groupadd -g $GID $GROUP || true
    useradd -u $UID -g $GID -d /synapse -M $USER || true
}

fix_permissions() {
    chown -R $USER:$GROUP /synapse
}

# -- Program starts ...

case $1 in
    genconfig)
	echo "Generating configs ..."

	# ensure workdir
	[ ! -d $WORKDIR ] && mkdir -p $WORKDIR
	[ -z "$TURN_SECRET" ] && echo "Quit! Need valid turn secret." && exit 1
	[ -z "$TURN_REALM" ] && echo "Quit! Need valid turn realm." && exit 1

	python3 /opt/bin/makeconf.py

	echo ""
	echo "Please review the homeserver config file!"
	
	break
	;;

    matrix-synapse)
	echo "Running matrix synapse home server ..."
	if [ ! -f $WORKDIR/homeserver.yaml ]; then
	    echo "Please create config file first."
	    exit -1
	fi

	# fix matrix user UID and GID
	fix_matrix_user

	# wait for DB to come up
	[ -z "$POSTGRES_HOST" ] && POSTGRES_HOST="db" # by default
	[ -z "$POSTGRES_PORT" ] && POSTGRES_PORT="5432"
	while ! nc -z $POSTGRES_HOST $POSTGRES_PORT; do
	    echo "Sleeping for 1 second ..."
	    sleep 1;
	done
	echo "Postgres DB is ready ..."

	# start matrix synapse service
	exec gosu $USER:$GROUP \
	     python3 -m synapse.app.homeserver \
		     -c $WORKDIR/homeserver.yaml

	break
	;;

    *)
	exec $@
	;;

esac

echo 
echo "Quitting ..."
exit 0
