#!/bin/bash
jekyll && rsync -avz --delete --max-delete=10 _site/ simon@simon4.com:http/blog
