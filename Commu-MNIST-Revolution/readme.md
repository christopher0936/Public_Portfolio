# Commu-MNIST Revolution: Implementing and Comparing Different Machine Learning Models in Handwritten Cyrillic Text Recognition!

This was done as a group final project for a Data Mining course. My portion of the code is here, as well a copy of our group's final report and poster, which we presented to the class at the end of term.

# Overview

The topic we chose to tackle was character recognition in the Cyrillic alphabet, which in contrast to the Latin alphabet has had relatively little research effort applied to it in the field. My portion of the project involved:

## Dataset Generation

While we were fortunate enough to find an [open source repository of handwritten Cyrillic characters]([https://www.kaggle.com/code/gregvial/load-and-display-cyrillic-alphabet](https://www.kaggle.com/code/gregvial/load-and-display-cyrillic-alphabet)), we found the processed data from  unusable and therefore I set about generating a MNIST-like dataset from the source images. This process resulted in a clean dataset mapping of 28x28px greyscale images to Cyrillic characters, which were output as dataX and dataY.

## SVM Implementation

My standout contribution to the codebase of the project was to implement and analyse results from a support vector machines using a variety of different hyperparameters, allowing for a detailed breakdown in the final report and poster. The SVMs themselves were implemented using scikit-learn while plots were created with matplotlib interfacing with the Jupyter Notebook environment.

## Poster and Report - Including Graphic Design

I created the graphical layout and artistic flow of the final poster, adding comedic and attention-grabbing flair with stereotypical Soviet imagery while allowing ample room for the detailed display of information. The content of the poster and report was a group effort, with each team member largely doing the writeup for the own contributions while we collaboratively edited each others work and discussed the overall flow of the presentation.