#!/bin/bash

HOST=$(hostname)

if [[ $1 = -deploy ]]; then
    echo "running with simongoudie.com/blog and deploying"
    glynn
elif [[ $1 = -deploys4 ]]; then
    echo "running with simon4.com/blog and deploying to test"
    jekyll && rsync -avz --delete _site/ simon@simon4.com:html/
elif [[ $HOST = RexBook ]]; then
    echo "running with jekyll.dev"
    jekyll --url http://jekyll.dev
elif [[ $HOST = simon4.com ]]; then
    echo "running with simon4.com/blog"
    jekyll --url http://simon4.com/blog && rm -rf ~/http/blog && mkdir ~/http/blog && cp ~/blog/_site/* ~/http/blog -R
elif [[ $HOST = rexpi ]]; then
    echo "running with goudz.com/blog"
    jekyll --url http://goudz.com/blog && rm -rf ~/http/blog && mkdir ~/http/blog/ && cp ~/blog/_site/* ~/http/blog -R
else
    echo "Unknown machine or switch, try something else"
fi
