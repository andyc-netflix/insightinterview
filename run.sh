#!/usr/bin/env bash

chmod a+x ./src/wordcount.rb
chmod a+x ./src/runningmedian.rb

ruby ./src/wordcount.rb ./wc_input/ ./wc_output/wc_result.txt
ruby ./src/runningmedian.rb ./wc_input/ ./wc_output/med_result.txt
