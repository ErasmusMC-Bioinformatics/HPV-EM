#!/usr/bin/env bash

curl -L http://hgdownload.soe.ucsc.edu/goldenPath/hg38/bigZips/hg38.fa.gz -o reference/hg38.fa.gz
curl -L http://hgdownload.soe.ucsc.edu/goldenPath/hg38/bigZips/genes/hg38.knownGene.gtf.gz -o reference/hg38.knownGene.gtf.gz
