#!/bin/bash -e

WEBDAV_SHARE=$1
WEBDAV_PASSWORD=$2

print_usage() {
  echo "Usage: $0 <webdav_share_folder> <webdav_password>"
}

if [ "" == "$WEBDAV_SHARE" ]; then
  print_usage
  exit -1
fi
if [ "" == "$WEBDAV_PASSWORD" ]; then
  print_usage
  exit -1
fi

# Prepare
sudo mkdir -p /etc/nginx/logs
sudo mkdir -p /etc/nginx/auth
sudo mkdir -p /etc/nginx/conf
sudo mkdir -p /usr/local/bin

# Setup password
sudo htpasswd -c /etc/nginx/auth/webdav webdav $WEBDAV_PASSWORD

# Install
sudo cp bin/nginx /usr/local/bin/
sudo chmod a+x /usr/local/bin/nginx

# Config file
cat > nginx.conf <<EOF
worker_processes 2;
events {
  worker_connections  1024;
}
http {
    include       mime.types;
    default_type  application/octet-stream;
    sendfile      on;
    tcp_nopush    on;
    tcp_nodelay   on;
    keepalive_timeout 65;
    types_hash_max_size 2048;
    server {
        listen       80;
        server_name  localhost;
        root ${WEBDAV_SHARE};
        client_body_temp_path /tmp;

        dav_methods     PUT DELETE MKCOL COPY MOVE;
        dav_ext_methods   PROPFIND OPTIONS;
        dav_access    user:rw group:rw all:rw;
        create_full_put_path  on;

        auth_basic "Restricted access";
        auth_basic_user_file /etc/nginx/auth/webdav;

        autoindex     on;
        allow all;
  }
}
EOF
sudo mv nginx.conf /etc/nginx/conf

# Stop / kill existing processes
sudo launchctl stop nginx || true
sudo pkill nginx || true

# Register nginx as a service 
sudo cp ../nginx.plist /System/Library/LaunchDaemons/
sudo chown root:staff /System/Library/LaunchAgents/nginx.plist
sudo launchctl load -F /System/Library/LaunchDaemons/nginx.plist
sudo launchctl start nginx 
