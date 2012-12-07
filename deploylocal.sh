#!/bin/bash
# jekyll && rsync -avz --delete _site/ simon@simon4.com:html/
jekyll --url http://simon4.com/blog && rm -rf ~/http/blog && mkdir ~/http/blog && cp ~/blog/_site/* ~/http/blog -R
