---
title: Getting and Cleaning Data Course Project
author: Marija Grjazniha
date: October 20, 2020
---

# Content

- `UCI HAR Dataset` Data folder
- `run_analysis.R` The code that cleans the data 
- `averages.txt` Output file 
- `CodeBook.md` Code Book explaining the data and transformations made

# Running script in R
```R
source('run_analysis.R')
```

# Opening output in R

```R
averages <- read.table("averages.txt", header=TRUE, sep=",", check.names=FALSE)
```

