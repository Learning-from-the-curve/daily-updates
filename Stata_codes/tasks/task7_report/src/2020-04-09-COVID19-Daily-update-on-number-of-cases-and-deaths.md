---
layout: post
title: COVID-19 - Daily update on number of cases and deaths
date: 2020-04-09 13:00:00 +0100
category: daily-updates
---
[Federico Gallina](https://www.ulb.be/fr/federico-gallina) [(ECARES, ULB)](https://ecares.ulb.be) and [Glenn Magerman (ECARES, ULB)](http://www.glennmagerman.com), with the [Learning from the curve](https://github.com/Learning-from-the-curve) team.

This article presents daily insights on COVID-19 for Belgium, the EU28 and the most infected countries in the world. We report detailed information on cases, hospitalizations and deaths for Belgium. We also compare life expectancy with COVID deaths by age groups, and calibrate a real-time epidemic curve. We then report patterns on cases and deaths for other countries, and epicurves for several countries. By combining these different statistics, we aim to better understand where we are in the trajectory of the epidemic.
This article is updated daily after 13:30.

Today's key numbers:

- Global: 1,476,819 total cases, and 87,816 deaths in 205 countries with reported COVID-19 cases.
- EU28: 658,073, and 59,421 deaths.
- Belgium: 24,535 total cases, 5,590 total hospitalised, 1,285 in intensive care, 992 on respiration, 2,523 deceased, and 5,163 released.

<!--more-->

Statistics on the number of COVID cases and deaths are useful and are the best that are available cross-country, but they are not perfect. Some cautions on the interpretation of the numbers:

**Note 1**:  The number of infections is much higher than reported. Not everyone is, will be, nor can be, tested, due to a combination of (i) technical constraints (impossible to test the whole population), (ii) policy constraints (who to test if there are limited resources to test), and (iii) the presence of infected people who are asymptomatic. See e.g. [Bloomberg](https://www.bloomberg.com/opinion/articles/2020-03-28/confirmed-coronavirus-cases-is-an-almost-meaningless-metric) for a discussion on testing policies.

**Note 2**: Differences in testing policies drive part of the variation in infection rates across countries, as some countries implement more aggressive testing than others. Testing policies can also change within countries over time. Therefore, both across- and within-country numbers not only reflect the evolution of the virus per se, but also policies.

**Note 3**:  The number of cases does not convey the severity of the disease. For some countries (including Belgium), information on the number of hospitalized patients is available. Further detailed information on demographics and pre-existing conditions of tested people would be important to make targeted policy decisions.

**Note 4**: There are [several sources of over, under and late reporting](https://www.bbc.com/future/article/20200401-coronavirus-why-death-and-mortality-rates-differ) which vary over time and across countries.

We share all code for this report (Python and Stata versions) on [GitHub](https://github.com/Learning-from-the-curve/daily-updates). Also see our other projects at [Learning from the curve](https://github.com/Learning-from-the-curve). Any comments are highly welcomed at [glenn.magerman@ulb.ac.be](glenn.magerman@ulb.ac.be)

**Data sources:**

- Detailed COVID data for Belgium from [Epistat](https://epistat.wiv-isp.be/covid/).
- Shape files for Belgium from [geo.be](geo.be).
- Geojson data used for interactive maps can be found [here](https://github.com/Datafable/rolling-blackout-belgium/blob/master/data/geospatial/municipalities-belgium.geojson).
- Life tables and population for Belgium from [Statbel](https://statbel.fgov.be).
- COVID data by country around the world from [ECDC](https://www.ecdc.europa.eu/en/publications-data/download-todays-data-geographic-distribution-covid-19-cases-worldwide).
- Country population data from [UN](https://population.un.org/wpp/Download/Standard/CSV).

**Table of Contents**:<a name="tbc"></a>

1. [Daily updates for Belgium](#cap1)
2. [Daily updates, world and EU28](#cap2)

### 1. Daily updates for Belgium <a name="cap1"></a>
[*Back to Table of Contents*](#tbc)

-------------------------------------

#### 1.1 Cases, hospitalizations and mortality

We start with the analysis for Belgium. Figure 1 shows total COVID numbers for cases, hospitalizations and deceased patients by date.[^1]

[^1]: A case is recorded as the date of symptoms onset, sampling, diagnosis, or reporting. There are possible reporting lags, as different sources have to record and transmit their data to Epistat. We present the latest available numbers.

There are currently 24,535 confirmed infections, 5,590 hospitalized patients, 1,285 patients in intensive care, with 992 patients on respiratory aid, and 2,523 people have died from the infection. On the up side, 5,163 patients have been released from the hospital. There is a current maximum capacity of 2,293 ICU beds reserved for COVID patients, and 56.04% of capacity of ICU beds is taken.

{% include plots/daily-update-2020-04-09/2020-04-09-Belgium-cumulative.html %}
<p style="text-align: center; font-style: italic;">Figure 1: Number of cases, hospitalizations and deaths in Belgium.</p>

Figure 2 shows the number of cases and hospitalized patients by province, for the latest available date.[^2]

[^2]: Numbers by province can be lagged; we present the latest available data. There is currently no information on the number of deceased patients by province.

{% include plots/daily-update-2020-04-09/2020-04-09-Belgium-province.html %}
<p style="text-align: center; font-style: italic;">Figure 2: Number of cases and hospitalizations by province.</p>

Figure 3 shows the number of cases by municipality.[^3] The city with the highest number of infections is Antwerpen (Antwerp) with 927. Luik (Liège) follows with 541 and Bergen (Mons) is third with 428 cases. In absolute terms, Flanders is much more infected than Wallonia, and these infections are also spread out across most cities. We also show the number of cases as a percentage of the population for each municipality. When controlling for population by municipality, the pattern changes significantly. Relatively hard hit regions are around Hasselt/Sint-Truiden, Mons and Liège.[^4]

[^3]: Currently, there is no information hospitalized or deceased patients by municipality.

[^4]: The geographic data used to build the map are from 2014. For the Belgian municipalities that merged in 2019 we include the former municipalities (pre-2019) separately, and we impute the cases for the merged municipality in 2019 to each per-2019 municipality. Some of the polygons in the map are empty due to missing data for that municipality or a problem with the geographic data in the geojson file. For example, Elsene (Ixelles) is not on the map, but we know that it has 176 cumulative cases, that is 0.203 of its population is infected.

{% include plots/daily-update-2020-04-09/2020-04-09-Belgium-map.html %}
<p style="text-align: center; font-style: italic;">Figure 3: Number of cases by municipality.</p>

#### 1.2 COVID mortality by age groups and regions

In Figure 4, we compare the life expectancy for Belgium (blue) against COVID deaths (red) across age groups.[^5] The COVID density is calculated as the share of deaths by age group. For both sexes, we see that the distribution of COVID mortality is skewed towards the elderly, with a turning point at around 70 years. More elderly people die from COVID than predicted by the life expectancy tables, relative to other age groups.
This curve might change over the course of the disease. For instance if elderly people die faster, but also younger people die over the epidemic, the distribution might shift its gravitational point to younger ages.
Importantly, this data does not account for pre-existing conditions, some of which might be a plausible risk factor for COVID (diabetes, vascular diseases etc.): age and pre-existing conditions correlate strongly, and without more information, we cannot disentangle both causes of mortality.

[^5]: In 2018, there was an influenza epidemic that generated significant over-mortality in the elderly. We average the densities over the years 2015-2017 to wash out year-specific peaks in mortality. There are some deaths reported without information on age, we drop these for the COVID CDF calculations. Since COVID mortality is given by age bins, we also bin the life tables. For each age bin (0-24 years, 25-44, 45-64, 65-74, 75-84, 85+), we take the midpoint.

We also compare COVID deaths by age group across regions (Brussels, Flanders, Wallonia). There might be regional differences (e.g. from health care capacity or quality). For instance, there seems to be a slighly lower mortality rate for elderly in Wallonia, but we await more data to reinforce the pattern.

{% include plots/daily-update-2020-04-09/2020-04-09-Belgium-life-expectancy.html %}
<p style="text-align: center; font-style: italic;">Figure 4: Life expectancy versus distribution of COVD deaths by age groups and region.</p>

#### 1.3 Epicurve for Belgium

We conclude the analysis for Belgium with a real-time epidemic curve for both cases and deaths in Figure 5.
The epicurve reports the fraction of total cases or deaths over the span of the disease. When people talk about "flattening the curve", THIS is the curve. Some examples of epicurves for [Mers-CoV](https://www.nature.com/articles/s41598-019-43586-9), [SARS](https://www.who.int/csr/sars/epicurve/epiindex/en/index1.html), [influenza in Canada](https://onlinelibrary.wiley.com/doi/full/10.1111/j.1750-2659.2010.00154.x) and [influenza in Belgium](https://epistat.wiv-isp.be/influenza/).

Epicurves are only available at the end of an outbreak. Then the length, peak and total number of cases or deaths are known. Still, we want to estimate where we are in the trajectory while the disease evolves.
We therefore estimate these numbers as follows. First, we target one or more countries that have potentially completed the first wave of the disease. We use these countries as a benchmark epicurve. As of today, we use China as a benchmark. As more countries complete the outbreak cycle, these will also contribute to the benchmark of the "true" epicurve for COVID.

Second, we forecast the trajectory for Belgium. We predict future growth rates and estimate where the peak of the epidemic might be. This shifts the currently observed data for Belgium relative to the trajectory of China on the *x*-axis. Then, based on the predicted growth rates, we calculate the number of cases per day over the trajectory. This rescales the observed data on the *y*-axis. The resulting graph then overlays the current predicted trajectory for Belgium against the benchmark countries.

The results are informative: if Belgium has reached its first peak, the number of days from the onset to the peak of the outbreak is around 25-30 days, comparable to China. From there, we might hope for a similar trajectory as China in the decline. However, also for China we observe the potential onset of a second wave. We compare cases and deaths over time as the outbreak evolves, and we re-estimate, fit and update these curves daily.

It's important to stress that these trajectories depend on several factors, including policy measures taken in each country, population density and geographic disparity. E.g. it is possible that China's cycle is faster due to more stringent policies. These epicurves therefore do not serve as a instrument to strengthen/release COVID policies. However, conditional on policies and cross-country differences in cycle length and severity, we assume that the epicurve follows a similar trajectory.

{% include plots/daily-update-2020-04-09/2020-04-09-MA_ln_share_cases-midpoint-Belgium.html %}
<p style="text-align: center; font-style: italic;">Figure 5: Epicurves: an estimated evolution of the epidemic waves.</p>

### 2. Daily updates, world and EU28 <a name="cap2"></a>
[*Back to Table of Contents*](#tbc)

-------------------------------------

#### 2.1 Number of cases and deaths

We continue with the number of cases and deaths for the 10 most infected countries in the world and the EU28.[^6]

[^6]: Some of these graphs are similar to the popular graphs in the [Financial Times](https://www.ft.com/coronavirus-latest).

Figure 6 shows the total number of cases over time. The country with the most cases is United States of America with 432,132 total confirmed cases. Second is Spain with 146,690 cases, and Italy follows, with 139,422 cases. The Figure reports the total number of cases (in log scale), since the 100th confirmed case within that country. In the initial outbreak phase, the epidemic [spreads exponentially](https://medium.com/data-for-science/epidemic-modeling-101-or-why-your-covid19-exponential-fits-are-wrong-97aa50c55f8), but tapers off as the epidemic evolves, due to constraints on the spread of the virus (e.g. policies, geography, density). Synchronizing dates since the 100th confirmed case allows to compare the speed and evolution of the epidemic across countries. China has been stabilizing since the end of February, signalling that its first peak has passed. The longer this curve stays flat, the more hopeful China can be. However, the arrival of new domestic cases signal the possible onset of a second wave. The curve for several countries tapers off, but other countries are still in the onset, facing close to exponential growth rates.

When looking at the EU28, the country with the most cases is Spain with 146,690 total confirmed cases. 
Second is Italy, with 139,422 confirmed cases, and Germany follows, with 108,202 cases. It's worth noting that Sweden's infection rate has decreased significantly since around the 9th day after the 100th confirmed case, while having a [more lenient policy](https://www.forbes.com/sites/davidnikel/2020/03/30/why-swedens-coronavirus-approach-is-so-different-from-others/#538677cb562b).  

The Figure also reports the total number of deaths since the 10th death. As noted in the introduction, both the number of cases and deaths are prone to several sources of non-random measurement error. However, we expect the measurement error to be smaller for the reported number of deaths. As of today, the country with the most deaths is Italy, with 17,669 deaths. Second is United States of America, with 14,817 deaths, and Spain follows, with 14,555 deaths. Again, we see that China has stabilized for now, with around 3,500 deaths. We repeat the graph for the 10 highest mortality countries in the EU28.

The EU28 country with the most deaths is Italy, with 17,669 deaths. Second is Spain, with 14,555 deaths, and France follows, with 10,869 deaths.

{% include plots/daily-update-2020-04-09/2020-04-09-ln_cum_cases-ln_cum_deaths-after_10th.html %}
<p style="text-align: center; font-style: italic;">Figure 6: Evolution of cases and deaths for the world and EU28 countries (top 10).</p>

In Figure 7, we plot the number of cases and deaths for these countries, as a fraction of the population. For cases, we report since the 0,01% case, for mortality, since the 0,001% death. Absolute numbers are a key statistic in the onset of the epidemic, as they relate to the number of people infected from one patient. Moreover, in standard S(E)IR models, the predicted number of infected people rises almost identical in countries with vastly different population sizes.
As the epidemic tapers off, these shares will converge to the final case and mortality rates of the disease.[^7]  

[^7]: The first few weeks in the outbreak, higher per-capita numbers mostly imply smaller countries, not different policies or growth rates.

As of today, the EU28 has an average infection rate of 0.128%/0.012%, calculated as the total number of cases/deaths over the EU28 population. This is still far off the [projections](https://www.hsph.harvard.edu/news/hsph-in-the-news/the-latest-on-the-coronavirus/) of 30-70% of adult world population ultimately being infected.  There are at least four hypotheses:
(i) real infection rates are orders of magnitude larger than reported ones. If we are at the end of the epidemic, this implies real infection rates are around 100-300 times larger than currently reported.
(ii) the epidemic is only in its onset, and we expect to reach higher infection rates.
(iii) we are reaching the end of the epidemic, and infection rates are much lower than projected. Given the growth rates and our estimates for epidemic curves, we believe this scenario is not probable at this moment.
(iv) flattening-the-curve policies lower the speed with which the epidemic rages. It is not clear yet whether these policies affect the total infection rate at the end of the epidemic. With such policies in place, the share of infected population can grow at a lower rate but over a longer period.

{% include plots/daily-update-2020-04-09/2020-04-09-cum_cases_population-cum_deaths_population-after_0.001.html %}
<p style="text-align: center; font-style: italic;">Figure 7: Evolution of cases and deaths for the world and EU28 countries, as a fraction of the population (top 10).</p>

#### 2.2 Growth rates

Next, we plot the evolution of growth rates of the number of cases and deaths, since the 100th case and the 10th death, in Figure 8. Growth rates are expressed in percentage changes from date *t-1* to *t*. We take a 3-day simple moving average to account for strong fluctuations from e.g. reporting lags within countries.

Each country wants to see this growth rate going to zero as soon as possible. China has seen close to zero growth rates for a series of days now. Two things are worth noting. First, the slopes, or decreases in growth rates, are not the same across countries. Second, even smoothed by a 3-day moving average, these growth rates are not monotonically decreasing. 
This might be partially due to temporal new outbursts of the virus within countries, or to increased testing policies.[^8]

[^8]: Approximating these growth rates with a 4th-order polynomial fit (not shown) also shows these non-monotonicities.

{% include plots/daily-update-2020-04-09/2020-04-09-MA_cases-MA_deaths-after_100th.html %}
<p style="text-align: center; font-style: italic;">Figure 8: Evolution of growth rates of cases and deaths for the world and the EU28 (top 10).</p>

#### 2.3 Epicurves, world and EU28

We conclude with an estimate of real-time epidemic curves for cases and deaths, for both the top 10 world countries and the EU in Figure 9.  These initial projections suggest that China has experienced a turning point at around 25-30 days. Italy might be on a similar track with a turning point at around 30 days, as well as France.

{% include plots/daily-update-2020-04-09/2020-04-09-MA_ln_share_cases-MA_ln_share_deaths-midpoint.html %}
<p style="text-align: center; font-style: italic;">Figure 9: Real-time epicurves.</p>

-------------------------------------

We are back with updated numbers tomorrow.

In the mean time, stay safe, and take care of yourself and of others.

Federico and Glenn.
