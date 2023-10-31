apt-get update
apt-get install -y nginx jq

unzip omero-docker -d .
cd omero-docker
docker compose up -d
docker exec -it omeroserver /opt/omero/init/populate.sh
