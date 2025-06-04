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

# sudo add-apt-repository ppa:deadsnakes/ppa -y
# sudo apt update -y
#sudo apt-get install python3.11 -y
sudo apt-get install python3.12-venv -y
sudo apt-get install xvfb -y

#### INSTALL OLLAMA
curl -fsSL https://ollama.com/install.sh | sh


#### INSTALL BROWSER USE
python3.12 -m venv buVenv
source buVenv/bin/activate
pip install browser-use
playwright install chromium --with-deps --no-shell


# Function to create agent launcher
create_agent_launcher() {
    local model="$1"
    
    # Pull the model
    ollama pull "$model"
    
    # Display configuration message
    echo "USING DEFAULT: $model Configuration"
    
    # Inject the model line into default_agent.py at line 15
    sed -i '15i\llm = ChatOllama(model="'$model'")' "$HOME/BROWSER-USE_CONFIGS/agents/default_agent.py"
    
    # Create the agent launcher script
    echo "source buVenv/bin/activate;xvfb-run -a python3 $HOME/BROWSER-USE_CONFIGS/agents/default_agent.py >> $HOME/LOGS/\$(date '+%Y-%m-%d_%H-%M-%S').default_agent.log" > "$HOME/agent-launcher.sh"
}

# Loop through all the positional parameters
while [ ! -z "$1" ]; do
    case "$1" in
        --default-phi4-14b)
            create_agent_launcher "phi4:14b"
            ;;

        --default-qwen3-8b)
            create_agent_launcher "qwen3:8b"
            ;;

        --default-gemma3-27b)
            create_agent_launcher "gemma3:27b"
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


