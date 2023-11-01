# apt-get update
# apt-get install -y nginx jq

cd omero-docker
docker compose up -d
docker exec -it omeroserver chmod +x /opt/omero/init/populate.sh
docker exec -it omeroserver /opt/omero/init/populate.sh

sed -i '/^PasswordAuthentication/s/no/yes/' /etc/ssh/sshd_config
useradd -m -p omero -s /bin/bash user
