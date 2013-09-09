#! /bin/bash

HOST=$(hostname)

if [[ $1 = -deploy ]]; then
    echo "running with simongoudie.com/blog and deploying"
    glynn
elif [[ $HOST = macair ]]; then
    echo "running with jekyll.dev"
    jekyll build --config _config.yml,_macairconfig.yml
elif [[ $HOST = simon4.com ]]; then
    echo "running with simon4.com/blog"
    jekyll build --config _config.yml,_simon4config.yml && sudo rm -rf ~/http/blog && sudo mkdir ~/http/blog && sudo cp ~/blog/_site/* ~/http/blog -R
elif [[ $HOST = rexrexpi ]]; then
    echo "running with goudz.com/blog"
    jekyll build --config _config.yml,_goudzconfig.yml && sudo rm -rf ~/http/blog && sudo mkdir ~/http/blog/ && sudo cp ~/blog/_site/* ~/http/blog -R
else
    echo "Unknown machine or switch, try something else"
fi
