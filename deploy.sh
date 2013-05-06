#! /bin/bash

HOST=$(hostname)

if [[ $1 = -deploy ]]; then
    echo "running with simongoudie.com/blog and deploying"
    glynn
elif [[ $HOST = RexBook ]]; then
    echo "running with jekyll.dev"
    jekyll build --config _rexbookconfig.yml
elif [[ $HOST = simon4.com ]]; then
    echo "running with simon4.com/blog"
    jekyll build --config _simon4config.yml && sudo rm -rf ~/http/blog && sudo mkdir ~/http/blog && sudo cp ~/blog/_site/* ~/http/blog -R
elif [[ $HOST = rexpi ]]; then
    echo "running with goudz.com/blog"
    jekyll build --config _goudzconfig.yml && sudo rm -rf ~/http/blog && sudo mkdir ~/http/blog/ && sudo cp ~/blog/_site/* ~/http/blog -R
else
    echo "Unknown machine or switch, try something else"
fi
