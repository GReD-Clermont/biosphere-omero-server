# General parameters
source /etc/profile.d/ifb.sh

SERVICE_NAME="omero"
SERVICE_PORT="4080"
SERVICE_PUB="-p ${SERVICE_PORT}:${SERVICE_PORT}"


HTTP_ENDP="https://$INSTANCE_HOSTNAME"
if [ -n "$IFB_PROXY_ENABLED" ]; then
    # Cloud site WITH a site proxy
    echo IFB_PROXY_ENABLED
    SERVICE_PUB="-p 80:${SERVICE_PORT}"
    systemctl stop nginx
else
    # Cloud site WOUT a site proxy
    if [ ! -f "/etc/ssl/private/approxy.key" ]; then
        openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/approxy.key -out /etc/ssl/certs/approxy.crt 
        openssl dhparam -out /etc/ssl/certs/approxy.pem 2048
    fi

    cp -a nginx/* /etc/nginx/
    sed -i "s|biosphere_instance_hostname|${INSTANCE_HOSTNAME}|" /etc/nginx/conf.d/approxy.conf
    sed -i "s|biosphere_service_port|${SERVICE_PORT}|" /etc/nginx/conf.d/approxy.conf
    rm /etc/nginx/sites-enabled/*
    systemctl restart nginx
fi

