#!/bin/bash
jekyll && rsync -avz --delete _site/ simon@simon4.com:html/
