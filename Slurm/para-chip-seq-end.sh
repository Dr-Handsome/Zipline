#!/bin/bash
cd `pwd`
tail -n 100 qc/*.raw.flagstat > qc/sum.before.flagstat
tail -n 100 qc/*.filt.flagstat > qc/sum.filt.flagstat
tail -n 100 qc/*.qc > qc/sum.qc
