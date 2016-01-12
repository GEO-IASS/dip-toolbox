# dip-toolbox
Algorithms for digital image processing - MATLAB codes

This toolbox is created during my phd studies, each folder contains an algorithm for digital image processing which was (or will be) published.

## Root folder
Contains very simple algorithms for fastening of debugging of algorithms for image enhancement.
* rescaleRange - shifts values (of any dimensional matrix) into range [0, 1].
* visualizeDifference - Algorithm published in Digital Heritage 2013 "Image Fusion for Difference
... Visualization in Art Analysis". Algorithm makes visualization of diff on
... intensity image. Difference is mapped to colour. Expected values of
... difference are \[-1, 1\] (but if not normalization is applied).

## ig folder
ig is a shortcut for *Information Gain*, which means information contained only in target modality (unpredictible from input signal). 

Folder contains algorithm now in review process in Signal Processing journal (Elsevier). This algorithm enhances invisible information contained in invisible spectral subband and not contained in visible subband. In other words - takes input signal and tries to create best estimation (by using ANN) of target signal. Error of this estimation is marked as information gain of target signal (+ noise).
*Usage*:
  informationGain(visible, target, 'annCount', 10, 'layers', [10, 10], 'trainingSetSize', 3000, 'useGPU', 'yes')

---

I will be glad you leave a notice if you are interested in this code (if you download, use or improves it).

In other branches there are lions ... Be careful.
