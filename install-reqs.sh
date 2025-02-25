#!/bin/bash

installDir=$(echo $HOME)
user=$(echo $USER)

cd $installDir
mkdir $installDir/LOGS



git clone https://github.com/browser-use/browser-use.git



##### INSTALL LINUX REQUIREMENTS #####
sudo apt-get update -y

sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt update -y

sudo apt-get install libatk1.0-0t64 libatk-bridge2.0-0t64 libcups2t64 libxcomposite1 libxdamage1 libpango-1.0-0 libcairo2 libasound2t64 libatspi2.0-0t64
sudo apt-get install python3.11 python3.11-venv -y
sudo apt-get install xvfb -y


echo "CREATING PYTHON3 VENV"
python3.11 -m venv busevenv
source busevenv/bin/activate

echo "INSTALLING PYTHON PACKAGES"
python3 -m pip install browser-use pytest-playwright
playwright install



# Loop through all the positional parameters
while [ ! -z "$1" ]; do
    case "$1" in

        #--linux64_chrome)
        #    #BROWSER CONFIG
        #    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
        #    sudo add-apt-repository "deb http://dl.google.com/linux/chrome/deb/ stable main" -y
        #    sudo apt-get update -y
        #    sudo apt-get install google-chrome-stable -y
        #    ;;



        --default)
            # Action for DEFAULT CONFIGURATION
            echo "USING DEFAULT AGENT"
            echo "xvfb-run -a $installDir/BROWSER-USE_CONFIGS/agents/default.py >> $installDir/LOGS/\$(date '+%Y-%m-%d_%H-%M-%S').default-agent.log" > $installDir/agent-launcher.sh
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



echo "ENABLING SYSTEMCTL FOR OLLAMA TUNNEL"
sudo cp $installDir/BROWSER-USE_CONFIGS/systemctl/axes-gpu1-ollama-tunnel.service /etc/systemd/system/
sudo systemctl enable --now axes-gpu1-ollama-tunnel
sudo systemctl status axes-gpu1-ollama-tunnel


echo "ENABLING SYSTEMCTL FOR AGENT-LAUNCHER"
sudo cp $installDir/BROWSER-USE_CONFIGS/systemctl/agent-launcher.service /etc/systemd/system/
sudo systemctl enable --now agent-launcher
sudo systemctl status agent-launcher


