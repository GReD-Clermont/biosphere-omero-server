# apt-get update
# apt-get install -y nginx jq

cd omero-docker
docker compose up -d
docker exec -it omeroserver sh -c "chmod +x /opt/omero/init/populate.sh && sh /opt/omero/init/populate.sh"

sed -i '/^PasswordAuthentication/s/no/yes/' /etc/ssh/sshd_config
systemctl restart ssh

# add user and change password
useradd -m -s /bin/bash user
yes omero | sudo passwd user
