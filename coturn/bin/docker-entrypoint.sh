#!/bin/sh

# Environment variables: -
#  EXTERNAL_IP
#  SECRET
#  DOMAIN
#  CERT
#  PKEY
#  DHFILE

UID=${UID:-1000}
GID=${GID:-1000}
USER=turnserver
GROUP=turnserver
WORKDIR=${WORKDIR:-/coturn}

set -ex

generate_coturn_config()
{
    conf=$1; shift

    cat > $conf <<EOF
# coturn server parameters

lt-cred-mech
use-auth-secret
static-auth-secret=$SECRET

realm=$REALM

cert=$CERT
pkey=$PKEY
dh-file=$DHFILE

cipher-list="HIGH"
EOF
}

fix_turn_user() {
    deluser $USER || true
    delgroup $GROUP || true
    addgroup -g $GID $GROUP || true
    adduser -D -h $WORKDIR -u $UID -G $GROUP -H $USER || true
}

fix_permissions() {
    conf=$1; shift
    chown turnserver:turnserver $conf

    chmod go+w /var/run
    chown -R turnserver:turnserver /var/lib/coturn
}

# PROGRAM starts here ...

OPTION=$1
CONF="$WORKDIR/turnserver.conf"

case $OPTION in
    "genconfig")
	# fix the turn user/group
	fix_turn_user

	# checking parameters
	[ -z "$SECRET" ] && echo "QUIT! Parameter SECRET is not defined." && exit 1
	[ -z "$REALM" ] && echo "QUIT! Parameter REALM is not defined." && exit 1
	[ -z "$CERT" ]  && echo "QUIT! Parameter CERT is not defined." && exit 1
	[ -z "$PKEY" ]  && echo "QUIT! Parameter PKEY is not defined." && exit 1
	[ -z "$DHFILE" ]  && echo "QUIT! Parameter DHFILE is not defined." && exit 1

	[ ! -f "$CERT" ]  && echo "QUIT! Failed to find $CERT." && exit 1
	[ ! -f "$PKEY" ]  && echo "QUIT! Failed to find $PKEY." && exit 1
	[ ! -f "$DHFILE" ]  && echo "QUIT! Failed to find $DHFILE." && exit 1

	generate_coturn_config $CONF

	# fix permissions
	fix_permissions $CONF

	break
	;;

    "turnserver")
	$0 genconfig

	# Get real external IP
	EXTERNAL_IP=${EXTERNAL_IP:-$(curl -4 https://icanhazip.com 2>/dev/null)}
	
	# start coturn process
	exec su-exec turnserver:turnserver \
	     turnserver \
	     --log-file=stdout \
	     --external-ip=$EXTERNAL_IP \
	     -c $CONF

	;;

    *)
	exec $@
	;;
esac

exit 0
