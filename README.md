---
title: Getting and Cleaning Data Course Project
author: Marija Grjazniha
date: October 20, 2020
---

# Content

- [`UCI HAR Dataset`](https://github.com/marija-grj/RCleaningProject/tree/main/UCI%20HAR%20Dataset) Data folder
- [`run_analysis.R`](https://github.com/marija-grj/RCleaningProject/blob/main/run_analysis.R) The code that cleans the data 
- [`averages.txt`](https://github.com/marija-grj/RCleaningProject/blob/main/averages.txt) Output file 
- [`CodeBook.md`](https://github.com/marija-grj/RCleaningProject/blob/main/CodeBook.md) Code Book explaining the data and transformations made

# Running script in R
```R
source('run_analysis.R')
```

# Opening output in R

```R
averages <- read.table("averages.txt", header=TRUE, sep=",", check.names=FALSE)
```

