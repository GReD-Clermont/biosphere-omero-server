apt-get update
apt-get install -y nginx jq

cd omero-docker
docker compose up -d
docker exec -it omeroserver /opt/omero/init/populate.sh
