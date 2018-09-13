#!bin/sh

# Fetch Gpdb Installer
wget -O ${GPDB_INSTALLER}.zip --post-data="" --header="Authorization: Token ${PIVNET_AUTH_TOKEN}" ${GPDB_INSTALLER_URL}

# Fetch Madlib
wget -O ${MADLIB_INSTALLER}.tar.gz --post-data="" --header="Authorization: Token ${PIVNET_AUTH_TOKEN}" ${MADLIB_INSTALLER_URL}

# Fetch Data Science Python
wget -O ${DATA_SCIENCE_PYTHON_INSTALLER}.gppkg --post-data="" --header="Authorization: Token ${PIVNET_AUTH_TOKEN}" ${DATA_SCIENCE_PYTHON_INSTALLER_URL}

# Fetch PostGIS Installer
wget -O ${POSTGIS_INSTALLER}.gppkg --post-data="" --header="Authorization: Token ${PIVNET_AUTH_TOKEN}" ${POSTGIS_INSTALLER_URL}