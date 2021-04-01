# PHL_cEEGrid_masterthesis

This repository contains Matlab code I used for recording, importing, and analyzing data in the scope of my Master thesis
"Development and Validation of an Integrated Portable Setup for Time-Synchronized Acoustic Stimuli Presentation and EEG Recording".

## Usage

For both technical and physiological validation, the analysis pipeline is contained in the overview scripts "timing_00_main.m" and "eval_00_main.m", which include calls to several other functions.
The folder "measurements_scripts" contains the basic scripts and openMHA [1] configurations used to perform a measurement using the Portable Hearing Laboratory [2].
For this a detailed instruction guide will be published. As soon as this is available, it will be linked here.

## Dependencies

For both pipelines EEGLAB (Version 2020.0, [3]) was used.

## Other Sources

In some cases, code was adopted from [4] and [5]. The sources are listed again at the respective places in the comments of the code.

## References

[1] http://batandcat.com/portable-hearing-laboratory-phl.html
[2] http://www.openmha.org/
[3] https://sccn.ucsd.edu/eeglab/index.php
[4] https://github.com/s4rify/fEEGrid_paper
[5] https://osf.io/adhxf/
