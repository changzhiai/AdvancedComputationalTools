#!/bin/sh

source /dtu/sw/dcc/dcc-sw.bash
module load 2019-jun-dcc-setup
module load python/3.7.3
module load gpaw/20.1.0
module load gpaw-setups/0.9.20000

# Put bsub.py and other scripts on the PATH
export PATH=+++TOOLS_FOLDER+++:$PATH
