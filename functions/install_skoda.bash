sudo pacman -S --needed python
sudo pacman -S --needed python-pip
cd ~/scripts/skoda
# create a venv:
python3 -m venv .venv
source .venv/bin/activate
.venv/bin/pip install skodaconnect
.venv/bin/pip install paho-mqtt

