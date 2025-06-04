#!/bin/bash

cd $HOME
mkdir $HOME/LOGS

##### INSTALL CUDA REQUIREMENTS #####
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/cuda-keyring_1.1-1_all.deb
sudo dpkg -i cuda-keyring_1.1-1_all.deb
sudo apt-get update -y
sudo apt-get -y install cuda-toolkit-12-9
sudo apt-get install -y cuda-drivers

##### INSTALL LINUX REQUIREMENTS #####
sudo apt-get update -y

sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt update -y
sudo apt-get install python3.11 -y
sudo apt-get install python3.11-venv -y
sudo apt-get install xvfb -y

#### INSTALL OLLAMA
curl -fsSL https://ollama.com/install.sh | sh


#### INSTALL BROWSER USE
python3.11 -m venv buVenv
source buVenv/bin/activate
pip install browser-use
playwright install chromium --with-deps --no-shell

# Loop through all the positional parameters
while [ ! -z "$1" ]; do
    case "$1" in

        --default-phi4-14b)
            # Action for DEFAULT CONFIGURATION
            ollama pull phi4:14b
            echo "USING DEFAULT:Phi 4 14b Configuration"
            echo "source buVenv/bin/activate;xvfb-run -a python3 $HOME/BROWSER-USE_CONFIGS/agents/default_microsoft_phi4-14b.py >> $HOME/LOGS/\$(date '+%Y-%m-%d_%H-%M-%S').default_microsoft_phi4-14b.log" > $HOME/agent-launcher.sh
            ;;

            

        --help)
            # Display usage information
            usage
            ;;
        *)
            # Unknown option
            echo "Unknown option: $1"
            usage
            exit 1
            ;;
    esac
    shift
done


echo "ENABLING SYSTEMCTL FOR AGENT-LAUNCHER"
sudo cp $HOME/BROWSER-USE_CONFIGS/systemctl/agent-launcher.service /etc/systemd/system/
sudo systemctl enable --now agent-launcher
sudo systemctl status agent-launcher


sudo reboot


