#!/bin/bash

tool/alevin/salmon-latest_linux_x86_64/bin/salmon \
index -i data/salmon_index -k 31 --gencode -p 4 \
-t data/gencode.v32.pc_transcripts.fa.gz
