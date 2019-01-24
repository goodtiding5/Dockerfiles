#!/usr/local/bin/python

import jinja2
import os
import sys
import subprocess
import glob
import codecs

# Utility functions
convert = lambda src, dst, environ: open(dst, "w").write(jinja2.Template(open(src).read()).render(**environ))

def check_arguments(environ, args):
    for argument in args:
        if argument not in environ:
            print("Environment variable %s is mandatory, exiting." % argument)
            sys.exit(2)

def check_dirs(dirs):
    if type(dirs) == type(""): dirs = [ dirs ]
    for d in dirs:
        if not os.path.exists(d): os.mkdir(d)

def generate_secrets(environ, secrets):
    for name, secret in secrets.items():
        if secret not in environ:
            filename = "/synapse/tmp/%s.%s.key" % (environ["SYNAPSE_SERVER_NAME"], name)
            if os.path.exists(filename):
                with open(filename) as handle: value = handle.read()
            else:
                print("Generating a random secret for {}".format(name))
                value = codecs.encode(os.urandom(32), "hex").decode()
                with open(filename, "w") as handle: handle.write(value)
            environ[secret] = value

# Prepare the configuration
if __name__ == '__main__':
    environ = os.environ.copy()
    ownership = "{}:{}".format(environ.get("UID", 1000), environ.get("GID", 1000))
    args = ["python3", "-m", "synapse.app.homeserver"]

    # Prepare directory structure
    check_dirs(["/synapse/ssl", "/synapse/run", "/synapse/db", "/synapse/tmp",
                "/synapse/logs", "/synapse/media", "/synapse/uploads", "/synapse/appservices"])
    
    check_arguments(environ, ("SYNAPSE_SERVER_NAME", "SYNAPSE_REPORT_STATS"))
    generate_secrets(environ, {
        "registration": "SYNAPSE_REGISTRATION_SHARED_SECRET",
        "macaroon": "SYNAPSE_MACAROON_SECRET_KEY"
    })

    if "TURN_REALM" in environ and "TURN_SECRET" in environ:
        realm = environ.get("TURN_REALM")
        ports = [3478, 3479, 5349, 5350]
        turis = []
        for p in ports:
            turis.append("turn:{}:{}?transport=udp".format(realm, p))
            turis.append("turn:{}:{}?transport=tcp".format(realm, p))
        environ["SYNAPSE_TURN_URIS"] = ','.join(turis)
        environ["SYNAPSE_TURN_SECRET"] = environ.get("TURN_SECRET")

    environ["SYNAPSE_APPSERVICES"] = glob.glob("/synapse/appservices/*.yaml")

    # Parse the configuration file
    convert("/opt/conf/homeserver.yaml", "/synapse/homeserver.yaml", environ)
    convert("/opt/conf/log.config", "/synapse/log.config", environ)
    
    # Generate missing keys
    args += ["--config-path", "/synapse/homeserver.yaml"]
    subprocess.check_output(args + ["--generate-keys"])

    # fix permissions
    subprocess.check_output(["chown", "-R", ownership, "/synapse"])
