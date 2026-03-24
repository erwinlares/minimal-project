#!/bin/bash

mkdir results-folder
Rscript analysis.R ${1}
tar -czf ${1}-analysis-results.tar.gz results-folder
