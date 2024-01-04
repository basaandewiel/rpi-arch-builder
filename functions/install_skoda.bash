sudo pacman -S --needed python
sudo pacman -S --needed python-pip
cd ~/scripts/skoda
# create a venv:
python3 -m venv .venv
source .venv/bin/activate
pip install skodaconnect
pip install paho-mqtt

