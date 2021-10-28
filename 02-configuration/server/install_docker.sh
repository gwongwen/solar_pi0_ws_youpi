echo "Downloading get-docker.sh"
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
echo "Setting docker permissions for pi"
sudo usermod -aG docker pi
echo "Docker version"
docker version
echo "Install docker compose"
sudo apt-get install libffi-dev libssl-dev
sudo apt install python3-dev
sudo apt-get install -y python3 python3-pip
sudo pip3 install docker-compose

