# PSY6422_250134696_Project

This repository is for presenting my final project for PSY6422.

## Overview

The goal of this project is to create a map of the regions of England and show how they are increasing or decreasing in alcohol-specific hospital admissions over time. The rest of this README file is meant to provide viewers with all the necessary background information to navigate the repository and to recreate the visualization themselves.

## Installing Packages

In order for this to work, the following packages need to be installed.

```{r}
#install these packages if not already on your device
install.packages("here")
install.packages("tidyverse")
install.packages("ggplot2")
install.packages("naniar")
install.packages("sf")
install.packages("ggiraph")
install.packages("svglite")
install.packages("base64enc")
```

## Accessing Data

For this project, I used a data set from the UK Department of Health and Social Care called "Alcohol Profile 2025." You can access this data set [here](https://fingertips.phe.org.uk/profile/local-alcohol-profiles/data#page/9/gid/1938132984/pat/15/par/E92000001/ati/6/are/E12000008/iid/92906/age/1/sex/4/cat/-1/ctp/-1/yrr/1/cid/4/tbm/1/page-options/ine-yo-1:2023:-1:-1_ine-ct-146_ine-pt-0_tre-ao-0). To download the correct data set, scroll down on the linked webpage to the "Get the data" section. There are three subheadings, the first of which is "Profile: Alcohol Profile." Under that are two hyper-linked data sets. The correct data set to download is the first one, which is called "Data for Government Office Region (E12)." Because I am using the "here" package, I saved the downloaded data to my project in a new subfolder called "Data."

-   Note: there are three hyper-links called "Data for Government Office Region (E12)." We only need the one from the "Profile: Alcohol Profile" heading.

-   Note: if you are accessing this data organically from a web search rather than through the provided link, be sure to change the "Area type" tab to "Regions (Statistical)" to ensure you download the data set that includes statistics across the regions of England.

n order to build the map itself, we need a shapefile of England's nine regions (which include the North East, North West, Yorkshire and the Humber, East Midlands, West Midlands, East of England, London, South East, and South West). I obtained this shapefile from the Open Geography Portal by the Office of National Statistics. The shapefile called "Regions (December 2023) Boundaries EN BGC." You can download the shapefile [here](https://geoportal.statistics.gov.uk/datasets/6acd1e2fc3d1482e9f5da27d935216dd_0/explore?location=52.391944%2C-2.489483%2C6.71). On this linked webpage, hit download on the left-hand side, and when you do, ten download options will be available. Choose the second option called "Shapefile." Because I am using the "here" package, I saved the downloaded data to my project in the "Data" subfolder, like before.

-   Note: this download will need to be unzipped in order to access it.

## Repository Structure

-   The Data folder contains the raw data in the form of a csv file as well as the unzipped data for the shapefile.

-   The LICENSE contains information on the MIT license used for this repository.

-   The PSY6422_250134696.R file contains all the original code I completed before creating this repository.

-   The PSY6422_250134696_Project.Rproj is the project in R Studio where the code and quarto files are held.

-   This is the README file to provide the overall structure of the repository and provide precursor information to run the visualization's code.

-   The index files are where the code for the quarto page are located.
