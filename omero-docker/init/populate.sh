#!/bin/bash
set -eux

OMERO_INIT=/opt/omero/init
OMERO_DIST=${OMERO_DIST:-/opt/omero/server/OMERO.server}

trap cleanup EXIT

export PATH=$PATH:${OMERO_DIST}/bin

omero login root@localhost -w omero

# add the root user to a second group
omero group add testGroup
omero group add testGroup1 --perms='rwr---'
omero group add testGroup2
omero group add testGroup3 --type=read-annotate
omero group adduser --name testGroup --user-name root
omero user add testUser firstname lastname testGroup -P password
omero user add testUser2 firstname2 lastname2 testGroup -P password2
omero user add testUser3 firstname3 lastname3 testGroup2 -P password3
omero user add testUser4 firstname4 lastname4 testGroup3 -P password4
omero group adduser --name testGroup1 testUser
omero group adduser --name testGroup3 testUser3
omero group adduser --name testGroup3 testUser4 --as-owner
omero quit

omero login testUser@localhost -w password -g testGroup

# create a simple project/dataset/image hierarchy
PROJECT1=$(omero obj new Project name=TestProject description=description)
PROJECT2=$(omero obj new Project name=TestProject2)

DATASET1=$(omero obj new Dataset name=TestDataset description=description)
DATASET2=$(omero obj new Dataset name=TestDatasetImport)
DATASET3=$(omero obj new Dataset name=TestDataset)
DATASET4=$(omero obj new Dataset name=TestDataset4)

omero obj new ProjectDatasetLink parent="$PROJECT1" child="$DATASET1"
omero obj new ProjectDatasetLink parent="$PROJECT1" child="$DATASET2"
omero obj new ProjectDatasetLink parent="$PROJECT2" child="$DATASET3"
omero obj new ProjectDatasetLink parent="$PROJECT1" child="$DATASET4"

IMAGE1=$(omero import --output=ids "$OMERO_INIT/image1.fake" -T "$DATASET1")
IMAGE2=$(omero import --output=ids "$OMERO_INIT/image1.fake" -T "$DATASET1")
IMAGE3=$(omero import --output=ids "$OMERO_INIT/image2.fake" -T "$DATASET1")
IMAGE4=$(omero import --output=ids "$OMERO_INIT/image1.fake" -T "$DATASET3")

omero obj new DatasetImageLink parent="$DATASET4" child="$IMAGE1"

# import screens
SCREEN1=$(omero obj new Screen name=TestScreen description=description)
SCREEN2=$(omero obj new Screen name=TestScreen2)
PLATE1=$(omero import "$OMERO_INIT/screen1.fake" -T "$SCREEN1")
omero import "$OMERO_INIT/screen2.fake" -T "$SCREEN2"

# add annotations
TAG1=$(omero obj new TagAnnotation textValue=tag1 description=description)
TAG2=$(omero obj new TagAnnotation textValue=tag2)
omero obj new TagAnnotation textValue=tag3
omero obj new ProjectAnnotationLink parent="$PROJECT2" child="$TAG1"
omero obj new DatasetAnnotationLink parent="$DATASET3" child="$TAG1"
omero obj new ImageAnnotationLink parent="$IMAGE1" child="$TAG1"
omero obj new ImageAnnotationLink parent="$IMAGE1" child="$TAG2"
omero obj new ImageAnnotationLink parent="$IMAGE2" child="$TAG1"
omero obj new ImageAnnotationLink parent="$IMAGE4" child="$TAG1"
omero obj new ScreenAnnotationLink parent="$SCREEN1" child="$TAG1"
omero obj new PlateAnnotationLink parent="$PLATE1" child="$TAG1"
omero obj new WellAnnotationLink parent="Well:1" child="$TAG1"

MAP1=$(omero obj new MapAnnotation)
omero obj map-set "$MAP1" mapValue testKey1 testValue1
omero obj map-set "$MAP1" mapValue testKey2 20
omero obj new ImageAnnotationLink parent="$IMAGE1" child="$MAP1"
omero obj new ImageAnnotationLink parent="$IMAGE3" child="$MAP1"

MAP2=$(omero obj new MapAnnotation)
omero obj map-set "$MAP2" mapValue testKey1 testValue2
omero obj map-set "$MAP2" mapValue testKey2 30
omero obj new ImageAnnotationLink parent="$IMAGE2" child="$MAP2"
