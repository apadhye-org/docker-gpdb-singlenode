#!bin/sh

# Fetch Gpdb Installer
wget -O greenplum-db-5.10.2-rhel6-x86_64.zip --post-data="" --header="Authorization: Token ${PIVNET_AUTH_TOKEN}" https://network.pivotal.io/api/v2/products/pivotal-gpdb/releases/158026/product_files/191889/download

# Fetch Madlib
wget -O madlib-1.14-gp5-rhel6-x86_64.tar.gz --post-data="" --header="Authorization: Token ${PIVNET_AUTH_TOKEN}" https://network.pivotal.io/api/v2/products/pivotal-gpdb/releases/158026/product_files/191898/download

# Fetch Data Science Python
wget -O DataSciencePython-1.1.1-gp5-rhel6-x86_64.gppkg --post-data="" --header="Authorization: Token ${PIVNET_AUTH_TOKEN}" https://network.pivotal.io/api/v2/products/pivotal-gpdb/releases/35017/product_files/66375/download

# Fetch PostGIS Installer
wget -O postgis-2.1.5-gp5-rhel6-x86_64.gppkg --post-data="" --header="Authorization: Token ${PIVNET_AUTH_TOKEN}" https://network.pivotal.io/api/v2/products/pivotal-gpdb/releases/35017/product_files/66356/download