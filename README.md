# spring_migDist

![](https://img.shields.io/github/license/g-rppl/spring_migDist)

This repository contains data and code to reproduce results from [Rüppel, G., Hüppop, O., Schmaljohann, H. & Brust, V. The urge to breed early: Similar responses to environmental conditions in short- and long-distance migrants during spring migration.]().

## Abstract

Most migratory birds alternate between migratory endurance flights and stopovers. Migration, hence, is often characterised by a series of sequential trade-off decisions regarding departure, routing, and landing. Depending on the temporal, energetic, physiological, and physical constraints encountered during migration, individual migratory decisions are presumably well adapted to minimise the costs of migration. Consequently, in bird species that differ in those constraints, e.g. short- versus long-distance migrants, selection will favour different outcomes in the trade-off decisions, as it recently was shown with respect to environmental conditions at stopover in autumn. Yet, it remains unclear whether they also differ during spring, when early arrivals at the breeding grounds should be ultimately favoured regardless of migration type. We radio-tagged songbirds of both types at stopover sites along the German North Sea coast during spring and automatically tracked their migratory behaviour by a large-scale network of radio-receiving stations. Once departed, birds could either cross the sea or detour along the coast. We corrected for spatially biased detection data, using a hierarchical multistate model to assess how birds respond to variation in environmental conditions in their day-to-day departure decisions and route selection. The day-to-day departure probability was higher in long-distance migrants independently of the routing decision. Irrespective of migration type, all species more likely departed under light winds and rainless conditions, while the influence of air pressure change and relative humidity was species-specific. By accounting for detection probabilities, we estimated that about half of all individuals crossed the sea. Offshore flights were more likely when winds blew offshore and began earlier within the night compared to onshore flights. Our results suggest that selection more similarly affects birds of different migration types in spring than in autumn. These findings put the focus toward how ultimate mechanisms may shape departure and routing decisions differently between migration seasons.

## Content
- **modelling.qmd**: script for the complete modelling process. A rendered version can be found [here](https://g-rppl.github.io/spring_migDist/modelling.html).
- /**R**: contains code for helper functions in R. 
- /**data**: contains data ready for analysis.
    - data_detection-history.RData: detection history matrix ready to analyse.
    - data_individuals.RData: data for individual flights and weather data at departure.
    - data_weather.RData: weather data at sunset per individual flight.
- /**stan**: contains stan code for the models.

## Required packages outside of CRAN
- `cmdstanr` package. Install with `devtools::install_github("stan-dev/cmdstanr")` and, for the first time you install it, `cmdstanr::install_cmdstan()`. You can find more information [here](https://mc-stan.org/cmdstanr/index.html).