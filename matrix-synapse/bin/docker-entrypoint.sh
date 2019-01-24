#!/bin/sh

WORKDIR=/synapse
SERVER=${SERVER:matrix.server.ltd}
UID=${UID:-1000}
GID=${GID:-1000}
USER=matrix
GROUP=matrix

set -ex

create_matrix_user()
{
    deluser --remove-home $USER || true
    delgroup $GROUP || true
    addgroup -g $GID
    adduser -h $WORKDIR -u $UID -G $GROUP -H $USER
}

generate_matrix_config()
{
    exec su-exec $USER:$GROUP \
    python3 -m synapse.app.homeserver \
	    --server-name $SERVER \
	    --config-path homeserver.yml \
	    --generate-config \
	    --report-stats=no
}

run_matrix_synapse()
{
    exec su-exec $USER:$GROUP \
    python3 -m synapse.app.homeserver \
	    -c homeserver.yaml
}

# Program starts ...

case $1 in
    "generate_config")
	echo "Generating configs ..."
	if [ ! -d $WORKDIR ]; then
	    echo "Matrix synapse home directory does not exist."
	    echo "Please check the volume mount!"
	    exit -1
	fi
	create_matrix_user()
	chown -R $USER:$GROUP $WORKDIR
	cd $WORKDIR
	generate_matrix_config()
	;;

    "matrix-synapse")
	echo "Running matrix synapse home server ..."
	if [ ! -f $WORKDIR/homeserver.yml ]; then
	    echo "Please create config file first."
	    exit -1
	fi
	create_matrix_user()
	chown -R $USER:$GROUP $WORKDIR
	cd $WORKDIR
	run_matrix_synapse()
	;;

    *)
	exec `eval "echo $@"`
	;;

esac

echo
echo "Quitting ..."
