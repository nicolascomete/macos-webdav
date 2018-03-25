#!/bin/bash -e
NGINX_VERSION=1.12.2

# Get extension module
if [ -d "nginx-dav-ext-module" ]; then
  cd nginx-dav-ext-module
  git pull
  cd -
else
  git clone https://github.com/arut/nginx-dav-ext-module.git
fi

# Get nginx sources
curl http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz | tar xvz

# Configure & make
echo
echo "*** Building NGINX ${NGINX_VERSION}"
echo
cd nginx-${NGINX_VERSION}
./configure \
	--with-http_dav_module --add-module=../nginx-dav-ext-module \
	--prefix=/etc/nginx \
	--sbin-path=/usr/local/bin \
	--user=$(id -un) --group=$(id -gn)
make
cp objs/nginx ../bin/nginx 
