#!/bin/bash

# This script is executed as geonode user

echo "Installing OSGEO in virtualenvwrapper"

deactivate geonode
echo "Host gdal version: "
GDAL_VERSION=${python -c "from osgeo import gdal; print gdal.__version__"}
echo $GDAL_VERSION

workon geonode

cd ~/.virtualenvs/geonode
mkdir build
pip install --download build GDAL==$GDAL_VERSION
cd build
tar -xzf GDAL-$GDAL_VERSION.tar.gz
sed -i s/gdal_config = ..\/..\/apps\/gdal-config/gdal_config = \/usr\/bin\/gdal-config/g \
    GDAL-$GDAL_VERSION/setup.cfg
cd GDAL-$GDAL_VERSION

python setup.py build_ext --include-dirs=/usr/include/gdal
python setup.py install
cd ~
echo "Installed virtualenv gdal version: "
python -c "from osgeo import gdal; print gdal.__version__"
