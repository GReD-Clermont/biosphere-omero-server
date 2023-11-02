#!/bin/bash
set -eux

OMERO_INIT=/opt/omero/init
OMERO_DIST=${OMERO_DIST:-/opt/omero/server/OMERO.server}

# trap cleanup EXIT

export PATH=$PATH:${OMERO_DIST}/bin

omero login root@localhost -w omero

# add the root user to a second group
omero group add testGroup
omero group adduser --name testGroup --user-name root
omero user add testUser firstname lastname testGroup -P password