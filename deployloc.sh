#!/bin/bash
# jekyll && rsync -avz --delete _site/ simon@simon4.com:html/
jekyll && rm -rf ~/http/blog && mkdir ~/http/blog && cp ~/blog/_site/* ~/http/blog -R
