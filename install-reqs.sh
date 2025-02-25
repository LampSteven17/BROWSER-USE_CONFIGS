#!/bin/bash

# Function to display usage information
usage() {
    echo "Usage: $0 [options]"
    echo "--option1 - Performs action 1"
    echo "--option2 - Performs action 2"
    echo "--help    - Displays this help message"
}

# Check if no arguments were provided
if [ $# -eq 0 ]; then
    usage
    exit 1
fi


installDir=$(echo $HOME)
user=$(echo $USER)

for arg in "$@"
do
    if [[ $arg == --installpath=* ]]; then
        # Extract the value after "="
        installDir="${arg#*=}"
    fi

    echo "BROWSER-USE WILL BE INSTALLED AT $installDir"

done

cd $installDir

sudo apt-get update -y

sudo apt-get install python3-pip -y
sudo apt-get install python3-venv -y

sudo apt-get install xvfb -y
sudo apt-get install xdg-utils -y
sudo apt-get install libxml2-dev libxslt-dev -y
sudo apt-get install python3-tk python3-dev -y

echo "CREATING PYTHON3 VENV"
python3.11 -m venv browser-use
source browser-use/bin/activate

echo "INSTALLING PYTHON PACKAGES"
python3 -m pip install browser-use pytest-playwright
playwright install


# Loop through all the positional parameters
while [ ! -z "$1" ]; do
    case "$1" in

        --linux64_chrome)
            #BROWSER CONFIG
            wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
            sudo add-apt-repository "deb http://dl.google.com/linux/chrome/deb/ stable main" -y
            sudo apt-get update -y
            sudo apt-get install google-chrome-stable -y
            ;;

        --linux64_firefox)
            sudo apt-get install firefox -y
            echo "Downloading Geckodriver for Linux x86-64"
            wget https://github.com/mozilla/geckodriver/releases/download/v0.34.0/geckodriver-v0.34.0-linux64.tar.gz
            tar -xvzf geckodriver-v0.34.0-linux64.tar.gz
            rm -f geckodriver-v0.34.0-linux64.tar.gz
            ;;

        --armv7_firefox)
            sudo apt-get install firefox -y
            echo "Downloading Geckodriver for ARMv7l"
            wget https://github.com/jamesmortensen/geckodriver-arm-binaries/releases/download/v0.34.0/geckodriver-v0.34.0-linux-armv7l.tar.gz
            tar -xvzf geckodriver-v0.34.0-linux-armv7l.tar.gz
            rm -f geckodriver-v0.34.0-linux-armv7l.tar.gz
            ;;





        --default)
            # Action for DEFAULT CONFIGURATION
            echo "INSTALLING DEFAULT MCHP"
            echo "DEFAULT CONFIGURATION CHOSEN: NO CHANGES MADE TO human.py"
            echo "xvfb-run -a $installDir/mchp/bin/python3 $installDir/MCHP_CONFIGS/DEFAULT/pyhuman/human.py >> $installDir/LOGS/\$(date '+%Y-%m-%d_%H-%M-%S').mchp.log" > $installDir/run_mchp.sh
            ;;

        --sleepy)
            echo "INSTALLING SLEEPY MCHP"
            echo "xvfb-run -a $installDir/mchp/bin/python3 $installDir/MCHP_CONFIGS/DEFAULT/pyhuman/human.py --gtbstart='22:00:00' --gtbend='04:00:00' --sleepmin=14400 --sleepmax=36000 >> $installDir/LOGS/\$(date '+%Y-%m-%d_%H-%M-%S').mchp.log" > $installDir/run_mchp.sh
            ;;

        --dopey)
            echo "INSTALLING DOPEY MCHP"
            echo "xvfb-run -a $installDir/mchp/bin/python3 $installDir/MCHP_CONFIGS/DEFAULT/pyhuman/human.py --taskgroupinterval=3600 >> $installDir/LOGS/\$(date '+%Y-%m-%d_%H-%M-%S').mchp.log" > $installDir/run_mchp.sh
            ;;

        --doc)
            echo "INSTALLING DOC MCHP"
            (cd $installDir/MCHP_CONFIGS/DOC/out-queries-char && cat ckpt.part_*.gz | gunzip > ckpt.pt)
            python3 -m pip install torch tiktoken numpy
            cp $installDir/MCHP_CONFIGS/DOC/google_search_nanogpt_enabled.py $installDir/MCHP_CONFIGS/DEFAULT/pyhuman/app/workflows/
            rm $installDir/MCHP_CONFIGS/DEFAULT/pyhuman/app/workflows/google_search.py
            echo "xvfb-run -a $installDir/mchp/bin/python3 $installDir/MCHP_CONFIGS/DEFAULT/pyhuman/human.py --gtbstart='22:00:00' --gtbend='4:00:00' --sleepmin=14400 --sleepmax=36000 >> $installDir/LOGS/\$(date '+%Y-%m-%d_%H-%M-%S').mchp.log" > $installDir/run_mchp.sh
            ;;

        --grumpy)
            #ONLY GOOGLE SEARCHES
            echo "INSTALLING GRUMPY MCHP"
            echo "GRUMPY CONFIGURATION CHOSEN: NO CHANGES MADE TO human.py"
            echo "xvfb-run -a $installDir/mchp/bin/python3 $installDir/MCHP_CONFIGS/DEFAULT/pyhuman/human.py >> $installDir/LOGS/\$(date '+%Y-%m-%d_%H-%M-%S').mchp.log" > $installDir/run_mchp.sh
            rm $installDir/MCHP_CONFIGS/DEFAULT/pyhuman/app/workflows/browse_youtube.py
            rm $installDir/MCHP_CONFIGS/DEFAULT/pyhuman/app/workflows/browse_web.py
            ;;

        --happy)
            #ONLY BROWSES THE WEB
            echo "INSTALLING GRUMPY MCHP"
            echo "GRUMPY CONFIGURATION CHOSEN: NO CHANGES MADE TO human.py"
            echo "xvfb-run -a $installDir/mchp/bin/python3 $installDir/MCHP_CONFIGS/DEFAULT/pyhuman/human.py >> $installDir/LOGS/\$(date '+%Y-%m-%d_%H-%M-%S').mchp.log" > $installDir/run_mchp.sh
            rm $installDir/MCHP_CONFIGS/DEFAULT/pyhuman/app/workflows/browse_youtube.py
            rm $installDir/MCHP_CONFIGS/DEFAULT/pyhuman/app/workflows/google_search.py
            ;;

        --bashful)
            #ONLY BROWSES YOUTUBE
            echo "INSTALLING GRUMPY MCHP"
            echo "GRUMPY CONFIGURATION CHOSEN: NO CHANGES MADE TO human.py"
            echo "xvfb-run -a $installDir/mchp/bin/python3 $installDir/MCHP_CONFIGS/DEFAULT/pyhuman/human.py >> $installDir/LOGS/\$(date '+%Y-%m-%d_%H-%M-%S').mchp.log" > $installDir/run_mchp.sh
            rm $installDir/MCHP_CONFIGS/DEFAULT/pyhuman/app/workflows/browse_web.py
            rm $installDir/MCHP_CONFIGS/DEFAULT/pyhuman/app/workflows/google_search.py
            ;;

        --browsy)
            # Action for DEFAULT CONFIGURATION
            echo "INSTALLING BROWSING HEAVY MCHP"
            rm $installDir/MCHP_CONFIGS/DEFAULT/pyhuman/human.py
            mv $installDir/MCHP_CONFIGS/BROWSY/human.py $installDir/MCHP_CONFIGS/DEFAULT/pyhuman/
            rm $installDir/MCHP_CONFIGS/DEFAULT/pyhuman/app/workflows/spawn_shell.py
            rm $installDir/MCHP_CONFIGS/DEFAULT/pyhuman/app/workflows/execute_command.py
            echo "xvfb-run -a $installDir/mchp/bin/python3 $installDir/MCHP_CONFIGS/DEFAULT/pyhuman/human.py >> $installDir/LOGS/\$(date '+%Y-%m-%d_%H-%M-%S').mchp.log" > $installDir/run_mchp.sh
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

echo "ENABLING SYSTEMCTL"
sudo cp $installDir/mchp.service /etc/systemd/system/
sudo systemctl enable --now mchp
sudo systemctl status mchp