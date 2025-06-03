#!/bin/bash

cd $HOME
mkdir $HOME/LOGS

##### INSTALL LINUX REQUIREMENTS #####
sudo apt-get update -y
sudo apt-get install python3.12-venv -y
sudo apt-get install xvfb -y

#### INSTALL OLLAMA
curl -fsSL https://ollama.com/install.sh | sh


#### INSTALL BROWSER USE
python3.12 -m venv buVenv
source buVenv/bin/activate
pip install browser-use
playwright install chromium --with-deps --no-shell

# Loop through all the positional parameters
while [ ! -z "$1" ]; do
    case "$1" in

        --default-deepseek8b)
            # Action for DEFAULT CONFIGURATION
            ollama pull deepseek-r1:8b
            echo "USING DEFAULT:Deepseek R1 8B Configuration"
            echo "source buVenv/bin/activate;xvfb-run -a python3 $HOME/BROWSER-USE_CONFIGS/agents/default_deepseek-r1-8b.py >> $HOME/LOGS/\$(date '+%Y-%m-%d_%H-%M-%S').default-agent.log" > $HOME/agent-launcher.sh
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


