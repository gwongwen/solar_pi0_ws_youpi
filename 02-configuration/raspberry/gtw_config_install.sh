# install dependencies
sudo apt-get update
sudo apt-get -y install build-essential
sudo apt-get -y install libpcre3 libpcre3-dev cmake autotools-dev nodejs-dev automake python-dev bison
cd ~
mkdir -p src

# install swig from source
cd ~/src
git clone https://github.com/swig/swig.git
cd swig
./autogen.sh
./configure
make
sudo make install

# install eclipse Mraa libraries from source
cd ~/src
git clone https://github.com/intel-iot-devkit/mraa.git
cd mraa
#nano src/spi/spi.c
#sudo npm -g i n
#sudo n
#mkdir build ; cd $_
mkdir build
cd build
cmake .. -DBUILDSWIGNODE=ON -DBUILDSWIGPYTHON=OFF
make
sudo make install

# install UPM library source
cd ~
git clone https://github.com/intel-iot-devkit/upm.git
cd upm
#mkdir build ; cd $_
mkdir build
cd build
cmake .. -DCMAKE_CXX_FLAGS::STRING=-march=native -DCMAKE_C_FLAGS:STRING=-march=native
make
sudo make install

# install lora-gw from source
cd ~
git clone https://github.com/4refr0nt/lora-gw.git
cd lora-gw
npm i

# configuration
cd ~/lora-gw
cp ./config-distr.js ./config.js
