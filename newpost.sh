#!/bin/bash
#! Script to make a new post with the date and title, add the yaml data, save it in the right folder and open it for editing in vim

echo "Please enter post title:"
read TITLE

TITLEF=${TITLE// /-}
DATE=$(date +"%Y-%m-%d")
FILENAME=_drafts/$DATE-$TITLEF.md

touch $FILENAME

echo "---" >> $FILENAME
echo "layout: post" >> $FILENAME
echo "title: $TITLE" >> $FILENAME
echo "---" >> $FILENAME
echo "" >> $FILENAME
echo "POST CONTENT HERE" >> $FILENAME

vim $FILENAME
