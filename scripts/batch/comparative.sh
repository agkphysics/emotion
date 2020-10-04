#!/usr/bin/sh

# This script runs all combinations of classifier, feature set and corpus.
# Must be run from the root directory of the project.

export CUDA_VISIBLE_DEVICES=0
export TF_CPP_MIN_LOG_LEVEL=1

for corpus in cafe crema-d demos emodb emofilm enterface iemocap jl msp-improv portuguese ravdess savee shemo smartkom tess; do
    for features in IS09 IS13 eGeMAPS GeMAPS boaw_20_500 boaw_50_1000 boaw_100_5000 audeep-0.05-0.025-240-60_b64_l0.001; do
        for kind in linear poly2 poly3 rbf; do
            python scripts/training/comparative.py --clf svm --kind $kind --reps 5 --data output/$corpus/$features.nc --results results/comparative2020/$corpus/svm/$kind/$features.csv
        done
        for kind in basic 1layer 2layer 3layer; do
            python scripts/training/comparative.py --clf dnn --kind $kind --reps 5 --data output/$corpus/$features.nc --results results/comparative2020/$corpus/dnn/$kind/$features.csv
        done
    done
    python scripts/training/comparative.py --clf cnn --kind aldeneh2017 --reps 3 --data output/$corpus/logmel.nc --datatype seq --results results/comparative2020/$corpus/cnn/aldeneh2017/logmel.csv
    python scripts/training/comparative.py --clf cnn --kind latif2019 --reps 3 --data output/$corpus/raw_audio.nc --datatype seq --results results/comparative2020/$corpus/cnn/latif2019/raw_audio.csv
done
