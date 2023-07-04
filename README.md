# spring_migDist

![](https://img.shields.io/github/license/g-rppl/spring_migDist)
[![DOI](https://zenodo.org/badge/592222892.svg)](https://zenodo.org/badge/latestdoi/592222892)

This repository contains data and code to reproduce results from Rüppel, G., Hüppop, O., Schmaljohann, H. & Brust, V. (2023). The urge to breed early: Similar responses to environmental conditions in short- and long-distance migrants during spring migration. *Ecology and Evolution*, **13**, e10223. [https://doi.org/10.1002/ece3.10223](https://doi.org/10.1002/ece3.10223)

## Abstract

Birds migrating different distances experience different temporal, energetic, physiological, and physical constraints throughout migration, which is reflected in their migration strategy. Consequently, we predict different behavioural decisions to similar environmental cues between short- and long-distance migrants, which has been documented for autumn migration. Here we focus on the question whether trade-off decisions regarding departure, routing, and landing when alternating between migratory endurance flights and stopovers also differ during spring migration. As early arrivals at the breeding grounds should be ultimately favoured regardless of migration distance, selection may favour more similar behavioural decisions in spring than in autumn. We radio-tagged short- and long-distance migratory songbirds at stopover sites along the German North Sea coast during spring and automatically tracked their migratory behaviour using a large-scale network of receiver stations. Once departed, birds could either cross the sea or detour along the coast. We corrected for spatially biased detection data, using a hierarchical multistate model to assess how birds respond to variation in environmental conditions in their day-to-day departure decisions and route selection. The day-to-day departure probability was higher in long-distance migrants independently of the routing decision. Irrespective of migration distance, all species more likely departed under light winds and rainless conditions, while the influence of air pressure change and relative humidity was species-specific. By accounting for detection probabilities, we estimated that about half of all individuals of each species crossed the sea, but did not find differences between short- and long-distance migrants. Offshore flights were more likely when winds blew offshore and began earlier within the night compared to onshore flights. Our results suggest that selection more similarly affects birds of different migration distances in spring than in autumn. These findings put the focus toward how ultimate mechanisms may shape departure and routing decisions differently between migration seasons.

## Content
- **modelling.qmd**: script for the complete modelling process. A rendered version can be found [here](https://g-rppl.github.io/Science/spring_migDist/).
- /**R**: contains code for helper functions in R. 
- /**data**: contains data ready for analysis.
    - data_detection-history.RData: detection history matrix ready to analyse.
    - data_individuals.RData: data for individual flights and weather data at departure.
    - data_weather.RData: weather data at sunset per individual flight.
- /**stan**: contains stan code for the models.

## Required packages outside of CRAN
- `cmdstanr` package. Install with `devtools::install_github("stan-dev/cmdstanr")` and, for the first time you install it, `cmdstanr::install_cmdstan()`. You can find more information [here](https://mc-stan.org/cmdstanr/index.html).